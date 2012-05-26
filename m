Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab2EZDSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 23:18:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40734 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab2EZDS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 23:18:28 -0400
Message-ID: <4FC04B80.3000007@lwfinger.net>
Date: Fri, 25 May 2012 22:18:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Lockdep warning from 3.4-gitX
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A newly built mainline kernel that git-describe shows as v3.4-7895-g1937f4f has 
the following lockdep log splat:

[   69.013395] =============================================
[   69.013397] [ INFO: possible recursive locking detected ]
[   69.013401] 3.4.0-Linus-07895-g1937f4f #148 Not tainted
[   69.013403] ---------------------------------------------
[   69.013405] bash/3631 is trying to acquire lock:
[   69.013415]  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff81382662>] 
tty_lock+0x32/0x70
[   69.013417]
[   69.013417] but task is already holding lock:
[   69.013423]  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff81382662>] 
tty_lock+0x32/0x70
[   69.013425]
[   69.013425] other info that might help us debug this:
[   69.013427]  Possible unsafe locking scenario:
[   69.013427]
[   69.013429]        CPU0
[   69.013430]        ----
[   69.013433]   lock(&tty->legacy_mutex);
[   69.013435]   lock(&tty->legacy_mutex);
[   69.013437]
[   69.013437]  *** DEADLOCK ***
[   69.013437]
[   69.013439]  May be due to missing lock nesting notation
[   69.013439]
[   69.013442] 2 locks held by bash/3631:
[   69.013449]  #0:  (tty_mutex){+.+.+.}, at: [<ffffffff812577e1>] 
tty_release+0x191/0x580
[   69.013456]  #1:  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff81382662>] 
tty_lock+0x32/0x70
[   69.013457]
[   69.013457] stack backtrace:
[   69.013461] Pid: 3631, comm: bash Not tainted 3.4.0-Linus-07895-g1937f4f #148
[   69.013463] Call Trace:
[   69.013468]  [<ffffffff8108c3d8>] __lock_acquire+0xee8/0x1c80
[   69.013472]  [<ffffffff81382662>] ? tty_lock+0x32/0x70
[   69.013476]  [<ffffffff8108d735>] lock_acquire+0x95/0x150
[   69.013479]  [<ffffffff81382662>] ? tty_lock+0x32/0x70
[   69.013483]  [<ffffffff8137f933>] ? mutex_lock_nested+0x273/0x350
[   69.013486]  [<ffffffff8137f72b>] mutex_lock_nested+0x6b/0x350
[   69.013490]  [<ffffffff81382662>] ? tty_lock+0x32/0x70
[   69.013493]  [<ffffffff8108e185>] ? trace_hardirqs_on_caller+0x105/0x190
[   69.013497]  [<ffffffff81382662>] tty_lock+0x32/0x70
[   69.013500]  [<ffffffff813826f5>] tty_lock_pair+0x55/0x5c
[   69.013504]  [<ffffffff812577ec>] tty_release+0x19c/0x580
[   69.013509]  [<ffffffff8112c3a5>] fput+0xf5/0x260
[   69.013513]  [<ffffffff81382886>] ? retint_swapgs+0xe/0x13
[   69.013517]  [<ffffffff81128846>] filp_close+0x56/0x80
[   69.013520]  [<ffffffff8112890b>] sys_close+0x9b/0x100
[   69.013525]  [<ffffffff81382fe2>] system_call_fastpath+0x16/0x1b

Thanks,

Larry
