Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab3AIRQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 12:16:46 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39798 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab3AIRQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 12:16:45 -0500
Date: Wed, 9 Jan 2013 17:16:42 +0000
From: Morten Rasmussen <Morten.Rasmussen@arm.com>
To: Alex Shi <alex.shi@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 0/22] sched: simplified fork, enable load average into
 LB and power awareness scheduling
Message-ID: <20130109171641.GA2046@e103034-lin>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
In-Reply-To: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 09 Jan 2013 17:16:41.0727 (UTC) FILETIME=[179850F0:01CDEE8D]
X-MC-Unique: 113010917164301801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Sat, Jan 05, 2013 at 08:37:29AM +0000, Alex Shi wrote:
> The patch set base on Linus tree, includes 3 parts,
> 1, bug fix and fork/wake balancing clean up. patch 1~6,
> the first patch remove one domain level. patch 2~6 simplified fork/wake
> balancing, it can increase 10+% hackbench performance on our 4 sockets
> SNB EP machine.
> 
> V3 change:
> a, added the first patch to remove one domain level on x86 platform.
> b, some small changes according to Namhyung Kim's comments, thanks!
> 
> 2, bug fix for load average and implement it into LB, patch 7~12,
> That using load average in load balancing, with a initial runnable load
> value bug fix.
> 
> V3 change:
> a, use rq->cfs.runnable_load_avg as cpu load not
> rq->avg.load_avg_contrib, since the latter need much time to accumulate
> for new forked task,
> b, a build issue fixed with Namhyung Kim's reminder.
> 
> 3, power awareness scheduling, patch 13~22,
> The subset implement my previous power aware scheduling proposal:
> https://lkml.org/lkml/2012/8/13/139
> It defines 2 new power aware policy balance and powersaving, and then
> try to spread or pack tasks on each of sched group level according the
> different scheduler policy. That can save much power when task number in
> system is no more then LCPU number.

Interesting stuff. I have read through your patches, but it is still not
clear to me what metrics you use to determine whether a sched group is
fully utilized or if it can be used for packing more tasks. Is it based on
nr_running or PJT's tracked load or both? How is the threshold defined?

Best regards,
Morten

> 
> V3 change:
> a, engaged nr_running in max potential utils consideration in periodic
> power balancing.
> b, try exec/wake small tasks on running cpu not idle cpu.
> 
> Thanks comments on previous version. and Any more comments are appreciated!
> 
> -- Thanks Alex
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

