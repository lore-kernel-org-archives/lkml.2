Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab0EXOSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 10:18:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62389 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757059Ab0EXOSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 10:18:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=I9ooOKRxVp3yT6BxytmUobMfU0tChfPjk8qnSe7AftCXkNNq1b2hZgE+sO2n7mZ8V+
         t8U+jFQrbSZ3Zd/qozvHZPyza2pfvPvg7PkWSnj1OWppgzXEP5DBMTvg3Q9lrSdblzIH
         E15LrfmvBkll6arDMnYCkPmgupFS+aVKl4sCE=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Paris <eparis@redhat.com>, Jan Kara <jack@ucw.cz>
Subject: Re: [git head f4b87dee9] BUG: using smp_processor_id() in preemptible (VFS-related)
References: <201005222337.00039.rjw@sisk.pl>
	<20100522163040.42bbde9d.akpm@linux-foundation.org>
	<20100524140002.GA11816@atrey.karlin.mff.cuni.cz>
Date: Mon, 24 May 2010 18:18:07 +0400
In-Reply-To: <20100524140002.GA11816@atrey.karlin.mff.cuni.cz> (Jan Kara's
	message of "Mon, 24 May 2010 16:00:02 +0200")
Message-ID: <87iq6dv0ww.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>   Hi,
>
>> On Sat, 22 May 2010 23:36:59 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>> > [    6.906133] EXT4-fs (sda7): mounted filesystem with ordered data mode
>> > [    7.014359] BUG: using smp_processor_id() in preemptible [00000000] code: mount/1501
>> > [    7.020570] caller is dqstats_inc+0x19/0x2c
>> > [    7.026658] Pid: 1501, comm: mount Not tainted 2.6.34-tst #25
>> > [    7.032792] Call Trace:
>> > [    7.038859]  [<ffffffff8117c12b>] debug_smp_processor_id+0xcb/0xdc
>> > [    7.045025]  [<ffffffff8111dfb5>] dqstats_inc+0x19/0x2c
>> > [    7.051201]  [<ffffffff81120fac>] vfs_quota_sync+0x144/0x210
>> > [    7.057349]  [<ffffffff810eccfa>] ? __shrink_dcache_sb+0x284/0x293
>> > [    7.063574]  [<ffffffff810fc48d>] __sync_filesystem+0x3a/0x7e
>> > [    7.069730]  [<ffffffff810fc552>] sync_filesystem+0x36/0x4c
>> > [    7.075867]  [<ffffffff810deef0>] do_remount_sb+0x65/0x13c
>> > [    7.081960]  [<ffffffff810f4359>] do_mount+0x251/0x78a
>> > [    7.088039]  [<ffffffff810f2c3e>] ? copy_mount_options+0xda/0x146
>> > [    7.094086]  [<ffffffff810f4911>] sys_mount+0x7f/0xb8
>> > [    7.100085]  [<ffffffff81002aeb>] system_call_fastpath+0x16/0x1b
>> > [    7.124208] BUG: using smp_processor_id() in preemptible [00000000] code: mount/1501
>> > [    7.130307] caller is dqstats_inc+0x19/0x2c
>> > [    7.136386] Pid: 1501, comm: mount Not tainted 2.6.34-tst #25
>> > [    7.142512] Call Trace:
>> > [    7.148629]  [<ffffffff8117c12b>] debug_smp_processor_id+0xcb/0xdc
>> > [    7.154846]  [<ffffffff8111dfb5>] dqstats_inc+0x19/0x2c
>> > [    7.161019]  [<ffffffff81120fac>] vfs_quota_sync+0x144/0x210
>> > [    7.167171]  [<ffffffff810fc48d>] __sync_filesystem+0x3a/0x7e
>> > [    7.173364]  [<ffffffff810fc563>] sync_filesystem+0x47/0x4c
>> > [    7.179522]  [<ffffffff810deef0>] do_remount_sb+0x65/0x13c
>> > [    7.185616]  [<ffffffff810f4359>] do_mount+0x251/0x78a
>> > [    7.191663]  [<ffffffff810f2c3e>] ? copy_mount_options+0xda/0x146
>> > [    7.197626]  [<ffffffff810f4911>] sys_mount+0x7f/0xb8
>> > [    7.203493]  [<ffffffff81002aeb>] system_call_fastpath+0x16/0x1b
>> > [   11.643596] udev: starting version 153
>> > 
>> > This is after reverting commit a7cf4145b (anon_inode: set S_IFREG on the
>> > anon_inode) that the system is not really useable with.
>> 
>> Caused by "quota: Make quota stat accounting lockless".
>> 
>> Guys, the code this patch adds utterly duplicates the interface
>> provided by include/linux/percpu_counter.h, only the quota code does it
>> wrongly and badly.  Please, can we use the nice library code?
>   I was thinking about this when merging the code and I thought that I'll save
> some memory (~200 bytes) because stats are fine with 32-bit counters (instead of
> 64-bit ones) and I'm interested only in rough counts, not exact ones. Since the
> code Dmitry added was quite simple, I thought the duplication won't be so bad.
>   But the code is probably more subtle than I thought so those 200 bytes aren't
> worth it. So let's convert it to generic per-cpu counters. Dmitry, will you do it?
Yes. I will.
BTW we are working on generic scalable resource counter which is 
based on percpu counters and lockless on fast-paths.
Resource counter examples: quota limits, bean-counters, etc.
The core idea in most situations resource has three main points:
zero, soft-barrier, hard-barrier where exact accuracy is required.
>   Hmm, I'm also wondering why I didn't see the warning Rafael was hitting in my
> test runs... Ah, my kernel config has CONFIG_PREEMPT_NONE! I guess using
> CONFIG_PREEMPT is likely to give a better test coverage, right?
Unfortunately preempt_debug was disabled on my testing hosts too.
>
> 									Honza
