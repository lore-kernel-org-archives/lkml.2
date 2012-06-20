Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab2FTVk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 17:40:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:7200 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737Ab2FTVk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 17:40:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158844039"
Subject: Re: [tip:x86/apic] x86/apic: Try to spread IRQ vectors to different
 priority levels
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@kernel.org, agordeev@redhat.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Date: Wed, 20 Jun 2012 14:41:11 -0700
In-Reply-To: <4FE2071B.5040602@zytor.com>
References: <20120607131514.GD4759@dhcp-26-207.brq.redhat.com>
	 <tip-1bccd58bfffc5a677051937b332b71f0686187c1@git.kernel.org>
	 <4FE2071B.5040602@zytor.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1340228471.3696.62.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 10:23 -0700, H. Peter Anvin wrote:
> On 06/08/2012 07:50 AM, tip-bot for Alexander Gordeev wrote:
> > Commit-ID:  1bccd58bfffc5a677051937b332b71f0686187c1
> > Gitweb:     http://git.kernel.org/tip/1bccd58bfffc5a677051937b332b71f0686187c1
> > Author:     Alexander Gordeev <agordeev@redhat.com>
> > AuthorDate: Thu, 7 Jun 2012 15:15:15 +0200
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Fri, 8 Jun 2012 11:44:28 +0200
> > 
> > x86/apic: Try to spread IRQ vectors to different priority levels
> > 
> > When assigning a new vector it is primarially done by adding 8
> > to the previously given out vector number. Hence, two
> > consequently allocated vector numbers would likely fall into the
> > same priority level. Try to spread vector numbers to different
> > priority levels better by changing the step from 8 to 16.
> > 
> 
> OK, stupid question: WHY?
> 
> In general, in Linux the random prioritization is actually a negative.

Thinking loud in the context of your e-mail. With the relatively recent
changes like the commit mentioned below, window of higher priority class
preempting the lower priority class is minimized to the point at which
the cpu decides which interrupt to be serviced next. And in this case,
it doesn't matter if the two vectors are in two different priority
classes or the same class. Higher the vector number higher the priority
for the cpu to service next.
 
commit e58aa3d2d0cc01ad8d6f7f640a0670433f794922
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Mar 26 00:06:51 2010 +0000

    genirq: Run irq handlers with interrupts disabled


> The only reason for the spreading by 8 is because of bugs/misfeatures in
> old APIC implementations which made them handle more than two interrupts
> per priority level rather inefficiently.

Peter, Is it just inefficiency or a functional bug in those old apic's?
Just wondering if it is just inefficiency and given the above linux
behavior does the inefficiency matter?

Anyways, these are old platforms that we probably don't want to mess
with. Perhaps we should go back to '8' and add a comment with all this
info, that the real intention is not to spread them across different
priority class but to avoid running into some old apic bugs.

thanks,
suresh


