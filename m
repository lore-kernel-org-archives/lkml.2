Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab2FTRX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 13:23:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39475 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab2FTRX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 13:23:56 -0400
Message-ID: <4FE2071B.5040602@zytor.com>
Date: Wed, 20 Jun 2012 10:23:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86/apic: Try to spread IRQ vectors to different
 priority levels
References: <20120607131514.GD4759@dhcp-26-207.brq.redhat.com> <tip-1bccd58bfffc5a677051937b332b71f0686187c1@git.kernel.org>
In-Reply-To: <tip-1bccd58bfffc5a677051937b332b71f0686187c1@git.kernel.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2012 07:50 AM, tip-bot for Alexander Gordeev wrote:
> Commit-ID:  1bccd58bfffc5a677051937b332b71f0686187c1
> Gitweb:     http://git.kernel.org/tip/1bccd58bfffc5a677051937b332b71f0686187c1
> Author:     Alexander Gordeev <agordeev@redhat.com>
> AuthorDate: Thu, 7 Jun 2012 15:15:15 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Fri, 8 Jun 2012 11:44:28 +0200
> 
> x86/apic: Try to spread IRQ vectors to different priority levels
> 
> When assigning a new vector it is primarially done by adding 8
> to the previously given out vector number. Hence, two
> consequently allocated vector numbers would likely fall into the
> same priority level. Try to spread vector numbers to different
> priority levels better by changing the step from 8 to 16.
> 

OK, stupid question: WHY?

In general, in Linux the random prioritization is actually a negative.
The only reason for the spreading by 8 is because of bugs/misfeatures in
old APIC implementations which made them handle more than two interrupts
per priority level rather inefficiently.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

