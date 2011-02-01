Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab1BARIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:08:37 -0500
Received: from service87.mimecast.com ([94.185.240.25]:53725 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751949Ab1BARIg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:08:36 -0500
Subject: Re: [PATCH v2] oprofile: add SMP barriers for hrtimer hotplug code
From: Will Deacon <will.deacon@arm.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-kernel@vger.kernel.org,
        oprofile-list@lists.sf.net, Robert Richter <robert.richter@amd.com>
In-Reply-To: <AANLkTimBTrqOk_ctBKmT0c=teZ8oG3c7Ai6-BmZwOj+g@mail.gmail.com>
References: <1296496389-30647-1-git-send-email-will.deacon@arm.com>
	 <1db705ac90529708ef559eee9708b648@mail.gmail.com>
	 <AANLkTimBTrqOk_ctBKmT0c=teZ8oG3c7Ai6-BmZwOj+g@mail.gmail.com>
Date: Tue, 01 Feb 2011 17:08:27 +0000
Message-ID: <1296580107.13713.1.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 01 Feb 2011 17:08:30.0559 (UTC) FILETIME=[A65F06F0:01CBC232]
X-MC-Unique: 111020117083204101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 08:03 +0000, Ming Lei wrote:
> Hi,
> 
Hello Lei Ming,

> 2011/2/1 Santosh Shilimkar <santosh.shilimkar@ti.com>:
> >> -----Original Message-----
> >> From: Will Deacon [mailto:will.deacon@arm.com]
> >> diff --git a/drivers/oprofile/timer_int.c
> >> b/drivers/oprofile/timer_int.c
> >> index 0107251..a3a94ea 100644
> >> --- a/drivers/oprofile/timer_int.c
> >> +++ b/drivers/oprofile/timer_int.c
> >> @@ -48,6 +48,7 @@ static int oprofile_hrtimer_start(void)
> >>  {
> >>       get_online_cpus();
> >>       ctr_running = 1;
> >> +     smp_mb();
> >>       on_each_cpu(__oprofile_hrtimer_start, NULL, 1);
> 
> Just a little question:
> 
> Before calling __oprofile_hrtimer_start in other CPUs,
> there have been some smp_mb executed already, such as called by
> smp_call_function_many in current CPU, and called by
> generic_smp_call_function_interrupt in the func-calling CPU,
> so are these smp_mb enough for correct order of access
> for 'ctr_running' ?

I didn't dive into the guts of the cross-calling implementation, but it
appears that you're correct. There's also the csd_{un}lock functions
which have smp_mb() in them too, so I think we have plenty of barrier
goodness as it is.

I'll trash the patch.

Cheers,

Will


