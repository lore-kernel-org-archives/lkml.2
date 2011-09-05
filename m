Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab1IEJE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 05:04:58 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63554 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab1IEJEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 05:04:51 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1109040945370.9175-100000@netrider.rowland.org>
References: <CAF1ivSbuRiY6Q75LUTGV6tN=KrKfVYjTV3=rZ51EiZY==707Uw@mail.gmail.com>
	<Pine.LNX.4.44L0.1109040945370.9175-100000@netrider.rowland.org>
Date: Mon, 5 Sep 2011 17:04:50 +0800
Message-ID: <CABqxG0dt74NfvsRAR5k+75UN085t_d90hOSCgqgHFTxLWgMqbg@mail.gmail.com>
Subject: Re: [BUG] D state process after unplug and umount usb disk
From: Dave Young <hidave.darkstar@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Lin Ming <mlin@ss.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/4/11, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sun, 4 Sep 2011, Lin Ming wrote:
>
>> On Sat, Sep 3, 2011 at 6:31 PM, Dave Young <hidave.darkstar@gmail.com>
>> wrote:
>> > Hi,
>> >
>> > Known issue?
>> >
>> > Reproduce by:
>> > mount /dev/sdb2 /mnt/sdb2 -t ext3
>> > cat /mnt/sdb2/* >/dev/null
>> > unplug usb disk
>> > umount -f /mnt/sdb2
>> >
>> > dmesg as below:
>
> BTW, this may or may not be related:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=25832  (kernel crashes when
> a mounted ext3/4 file system is physically removed)

Thanks for the info, but It seems a different problem. I can not
reproduce it with 3.0 kernel for 30 times test. it can easily
reproduce with recent kernel in 1-5 times test

>
>> > [ 1440.567271] SysRq : Show Blocked State
>> > [ 1440.567278]   task                        PC stack   pid father
>> > [ 1440.567312] cat             D ffff880037a1e378  4296  2381   2310
>> > 0x00000004
>> > [ 1440.567320]  ffff88003cca5838 0000000000000046 ffff88003cca57e8
>> > ffffffff00000000
>> > [ 1440.567332]  00000000000134c0 00000000000134c0 00000000000134c0
>> > ffff880037a1e000
>> > [ 1440.567339]  00000000000134c0 ffff88003cca5fd8 00000000000134c0
>> > 00000000000134c0
>> > [ 1440.567347] Call Trace:
>> > [ 1440.567357]  [<ffffffff810c0468>] ? lock_page+0x2a/0x2a
>> > [ 1440.567363]  [<ffffffff815e452d>] io_schedule+0x5e/0x79
>> > [ 1440.567368]  [<ffffffff810c0471>] sleep_on_page+0x9/0xd
>> > [ 1440.567373]  [<ffffffff815e4adf>] __wait_on_bit_lock+0x41/0x8a
>> > [ 1440.567378]  [<ffffffff810c0437>] __lock_page+0x61/0x68
>> > [ 1440.567384]  [<ffffffff81058739>] ?
>> > autoremove_wake_function+0x34/0x34
>> > [ 1440.567390]  [<ffffffff8102f704>] ? should_resched+0x9/0x29
>> > [ 1440.567395]  [<ffffffff810c9b0b>] lock_page+0x25/0x29
>> > [ 1440.567400]  [<ffffffff810ca1ac>]
>> > truncate_inode_pages_range+0x2a6/0x32d
>> > [ 1440.567406]  [<ffffffff810ca240>] truncate_inode_pages+0xd/0xf
>> > [ 1440.567411]  [<ffffffff811642cf>] ext3_evict_inode+0xc9/0x1d7
>> > [ 1440.567417]  [<ffffffff8111288e>] evict+0xa3/0x15e
>> > [ 1440.567422]  [<ffffffff81112b34>] dispose_list+0x3d/0x49
>> > [ 1440.567426]  [<ffffffff81113475>] evict_inodes+0xf1/0x100
>> > [ 1440.567431]  [<ffffffff810ffd21>] generic_shutdown_super+0x47/0xc7
>> > [ 1440.567436]  [<ffffffff810ffdc3>] kill_block_super+0x22/0x65
>> > [ 1440.567441]  [<ffffffff811000da>] deactivate_locked_super+0x21/0x52
>> > [ 1440.567445]  [<ffffffff811009ab>] deactivate_super+0x35/0x39
>> > [ 1440.567452]  [<ffffffff81116395>] mntput_no_expire+0xcb/0xd0
>> > [ 1440.567457]  [<ffffffff811163bb>] mntput+0x21/0x23
>> > [ 1440.567461]  [<ffffffff810ff8e7>] fput+0x196/0x1a5
>> > [ 1440.567467]  [<ffffffff810fc7a1>] filp_close+0x6b/0x76
>> > [ 1440.567472]  [<ffffffff8103fa8a>] put_files_struct+0x73/0xd1
>> > [ 1440.567477]  [<ffffffff8103fb7b>] exit_files+0x46/0x4f
>> > [ 1440.567481]  [<ffffffff8103fe01>] do_exit+0x27d/0x7b3
>> > [ 1440.567487]  [<ffffffff8104d97f>] ? get_signal_to_deliver+0x81/0x4ac
>> > [ 1440.567493]  [<ffffffff812e5e27>] ? do_raw_spin_lock+0x6b/0x122
>> > [ 1440.567497]  [<ffffffff810405c5>] do_group_exit+0x7d/0xa8
>> > [ 1440.567502]  [<ffffffff8104dd8b>] get_signal_to_deliver+0x48d/0x4ac
>> > [ 1440.567509]  [<ffffffff81001ea2>] do_signal+0x39/0x600
>> > [ 1440.567514]  [<ffffffff810fdb37>] ? fsnotify_access+0x5d/0x65
>> > [ 1440.567519]  [<ffffffff810024a4>] do_notify_resume+0x27/0x69
>> > [ 1440.567524]  [<ffffffff812e158e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>> > [ 1440.567529]  [<ffffffff815ecd63>] int_signal+0x12/0x17
>
>> Where does this exit signal come from?
>> Does USB interrupt handler will send kill signal to all processes
>> accessing it when it's unplugged(by hand)?
>
> The USB stack does not send any signals at all unless a process
> specifically asks for them.
>
> Alan Stern
>
>


-- 
Regards
Yang RuiRui
