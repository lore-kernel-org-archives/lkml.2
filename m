Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab1DLV7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 17:59:40 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51203 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417Ab1DLV7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 17:59:38 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinMAGmdEDviRwZ1-mxrAAe_WK5jvg@mail.gmail.com>
References: <BANLkTin3gtiBk8nvsWEiJetKHq2+9HTi4w@mail.gmail.com>
	<BANLkTimJLcfsYAhV+3=-F14YZvX12-yXgA@mail.gmail.com>
	<20110412182809.GA1218@redhat.com>
	<BANLkTinb1gXcZug5ApmmrudWLY7PwxNf-A@mail.gmail.com>
	<20110412192059.GA14360@redhat.com>
	<BANLkTimJgx_x=0bpBDWaUkJgZPYs3_iwsg@mail.gmail.com>
	<BANLkTimBegMUq2fX67o2YnoATWG-NDbKgA@mail.gmail.com>
	<BANLkTikoDELrA-RtA9BLm64mfoPgdADR0Q@mail.gmail.com>
	<BANLkTi=HyK+8DhJS3db0j2fefdOjwVMN3w@mail.gmail.com>
	<BANLkTinMAGmdEDviRwZ1-mxrAAe_WK5jvg@mail.gmail.com>
Date: Tue, 12 Apr 2011 23:59:37 +0200
Message-ID: <BANLkTinjGkbBMUo7MQ2Dg2yDwQ932qJ7rQ@mail.gmail.com>
Subject: Re: Processes hang in an unkillable state
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Ok, just to update you with what I'm currently doing:
>>
>> I'm testing now with 2.6.39-rc3 - according to
>> http://www.kernel.org/pub/linux/kernel/v2.6/testing/ChangeLog-2.6.39-rc3
>> it has vma_to_resize patch included
>> (982134ba62618c2d69fbbbd166d0a11ee3b7e3d8) - I applied the latest
>> Linus' patch for sys_mlock (the one patching memory.c and mlock.c),
>> disabled the sys_madvise in the fuzzer, and now I got the following
>> (full kdb dump attached)
>
> Ok, that's different from the apparent livelock.
>
> Except it once again is one of the BUG_ON's in vma_prio_tree_add() -
> and again, your kgdb thing has corrupted the bug information.
>
> Can you make a bug-report to the kgdb people?

Ok,

> You've lost Hugh's patch that did the vma dump instead of having the
> BUG_ON(). Can you try that one? And once more, I think that if you had
> CONFIG_OPTIMIZE_SIZE on, then I think gcc wouldn't re-order the basic
> blocks, and the BUG_ON() info would be easier to track.

Compiling now with CONFIG_OPTIMIZE_SIZE and vma dump code. Will
probably post some results tomorrow.

-- 
Robert Święcki
