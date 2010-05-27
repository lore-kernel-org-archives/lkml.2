Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab0E0QRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:17:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:47926 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab0E0QRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:17:45 -0400
Message-ID: <4BFE9ABA.6030907@kernel.org>
Date: Thu, 27 May 2010 18:15:54 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>, Sridhar Samudrala <sri@us.ibm.com>,
       netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
       Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/3] workqueue: Add an API to create a singlethread	workqueue
 attached to the current task's cgroup
References: <1274227491.2370.110.camel@w-sridhar.beaverton.ibm.com> <20100527091426.GA6308@redhat.com> <20100527124448.GA4241@redhat.com> <20100527131254.GB7974@redhat.com>
In-Reply-To: <20100527131254.GB7974@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 27 May 2010 16:15:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/27/2010 03:12 PM, Michael S. Tsirkin wrote:
>> I don't understand the reasons for this patch, but this doesn't matter.
> 
> Depending on userspace application, driver can create a lot of work
> for a workqueue to handle. By making the workqueue thread
> belong in a cgroup, we make it possible to the CPU and other
> resources thus consumed.

Hmmm.... I don't really get it.  The unit of scheduling in workqueue
is a work.  Unless you're gonna convert every driver to use this
special kind of workqueue (and what happens when multiple tasks from
different cgroups share the driver?), I can't see how this is gonna be
useful.  If you really wanna impose cgroup control on workqueue items,
you'll have to do it per work item which might lead to the problem of
priority inversion.  Can you please describe what you're trying to do
in more detail?

Thank you.

-- 
tejun
