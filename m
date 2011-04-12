Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354Ab1DLSeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:34:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65002 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757917Ab1DLSeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:34:10 -0400
MIME-Version: 1.0
In-Reply-To: <20110412182809.GA1218@redhat.com>
References: <BANLkTin3gtiBk8nvsWEiJetKHq2+9HTi4w@mail.gmail.com>
	<BANLkTimJLcfsYAhV+3=-F14YZvX12-yXgA@mail.gmail.com>
	<20110412182809.GA1218@redhat.com>
Date: Tue, 12 Apr 2011 20:34:10 +0200
Message-ID: <BANLkTinb1gXcZug5ApmmrudWLY7PwxNf-A@mail.gmail.com>
Subject: Re: Processes hang in an unkillable state
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 8:28 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 04/12, Américo Wang wrote:
>>
>> 2011/4/12 Robert Święcki <robert@swiecki.net>:
>> > Hi, while fuzzing Linux system calls (32bit fuzzer, 64bi linux
>> > kernel), it happens after some time (10-20mins) that some processes
>> > enter a state which makes them un-killable. They are either in R or D
>> > state.
>> >
>> > # strace ps wwuax
>> > ...
>> > ...
>> > open("/proc/450/cmdline", O_RDONLY)     = 6
>> > read(6,  -             hangs....
>> >
>> > # kill -9 450
>> > # kill -9 450 (no ESRCH)
>> >
>> > More data in the attachment - I'll keep it in the kdb session for
>> > further examination.
>>
>> http://marc.info/?t 0260440100004
>>
>> Hmm, it must be stuck at
>>
>> lib/rwsem.c
>>
>>         /* wait to be given the lock */
>>         for (;;) {
>>                 if (!waiter.task)
>>                         break;
>>                 schedule();
>>                 set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>>         }
>>
>> don't know why it still can't acquire the ->mmap_sem...
>>
>> Cc'ing Oleg...
>
> I seem to understand...
>
> Please wait a bit, I need to recheck.

Btw, Linus Torvalds is looking into a similar case in another thread -
http://marc.info/?l=linux-kernel&m=130262886420218&w=2

-- 
Robert Święcki
