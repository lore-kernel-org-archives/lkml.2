Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab2LKT4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 14:56:20 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:49202 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab2LKT4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 14:56:19 -0500
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5kjfpK+TPQ==
X-RZG-CLASS-ID: mo00
Message-ID: <50C78FE0.5040805@hartkopp.net>
Date: Tue, 11 Dec 2012 20:56:16 +0100
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.11) Gecko/20121123 Icedove/10.0.11
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: tty Linux 3.7: possible circular locking dependency detected
Content-Type: multipart/mixed;
 boundary="------------070204000703020005060104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070204000703020005060104
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello all,

i've seen two possible circular locking dependencies with my bluetooth dialup
setup. The dmesg outputs are attached.

Any idea?

I'll check, if i can reproduce this dmesg output.
Please let me know, if you need additional infos.

Best regards,
Oliver

--------------070204000703020005060104
Content-Type: text/plain;
 name="tty_lock_issue"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tty_lock_issue"

[ 1003.760488] PPP generic driver version 2.4.2
[ 1008.042682] Bluetooth: TIOCGSERIAL is not supported
[ 1008.850769] Bluetooth: TIOCGSERIAL is not supported
[ 1042.449682] PPP BSD Compression module registered
[ 1042.458694] PPP Deflate Compression module registered
[ 1128.563091] 
[ 1128.563097] ======================================================
[ 1128.563099] [ INFO: possible circular locking dependency detected ]
[ 1128.563103] 3.7.0 #195 Not tainted
[ 1128.563105] -------------------------------------------------------
[ 1128.563107] kworker/1:1/31 is trying to acquire lock:
[ 1128.563109]  (&tty->legacy_mutex){+.+.+.}, at: [<c150f286>] tty_lock_nested+0x36/0x80
[ 1128.563123] 
[ 1128.563123] but task is already holding lock:
[ 1128.563125]  ((&tty->hangup_work)){+.+...}, at: [<c1052983>] process_one_work+0x123/0x4d0
[ 1128.563135] 
[ 1128.563135] which lock already depends on the new lock.
[ 1128.563135] 
[ 1128.563138] 
[ 1128.563138] the existing dependency chain (in reverse order) is:
[ 1128.563140] 
[ 1128.563140] -> #2 ((&tty->hangup_work)){+.+...}:
[ 1128.563145]        [<c1085809>] lock_acquire+0x79/0xf0
[ 1128.563151]        [<c1053168>] flush_work+0x48/0x250
[ 1128.563155]        [<c1294a56>] tty_ldisc_flush_works+0x16/0x30
[ 1128.563160]        [<c1295941>] tty_ldisc_release+0x21/0x70
[ 1128.563164]        [<c128ee7c>] tty_release+0x37c/0x4a0
[ 1128.563170]        [<c11175cc>] __fput+0xcc/0x1f0
[ 1128.563176]        [<c11176fd>] ____fput+0xd/0x10
[ 1128.563179]        [<c1056eb9>] task_work_run+0x89/0xa0
[ 1128.563184]        [<c1002b11>] do_notify_resume+0x51/0x80
[ 1128.563189]        [<c150f578>] work_notifysig+0x29/0x31
[ 1128.563193] 
[ 1128.563193] -> #1 (&tty->legacy_mutex/1){+.+...}:
[ 1128.563199]        [<c1085809>] lock_acquire+0x79/0xf0
[ 1128.563203]        [<c150c1fa>] mutex_lock_nested+0x4a/0x2f0
[ 1128.563208]        [<c150f286>] tty_lock_nested+0x36/0x80
[ 1128.563212]        [<c150f319>] tty_lock_pair+0x29/0x70
[ 1128.563216]        [<c128ec30>] tty_release+0x130/0x4a0
[ 1128.563220]        [<c11175cc>] __fput+0xcc/0x1f0
[ 1128.563224]        [<c11176fd>] ____fput+0xd/0x10
[ 1128.563227]        [<c1056eb9>] task_work_run+0x89/0xa0
[ 1128.563231]        [<c1002b11>] do_notify_resume+0x51/0x80
[ 1128.563235]        [<c150f578>] work_notifysig+0x29/0x31
[ 1128.563239] 
[ 1128.563239] -> #0 (&tty->legacy_mutex){+.+.+.}:
[ 1128.563243]        [<c10852ae>] __lock_acquire+0x165e/0x1710
[ 1128.563248]        [<c1085809>] lock_acquire+0x79/0xf0
[ 1128.563252]        [<c150c1fa>] mutex_lock_nested+0x4a/0x2f0
[ 1128.563255]        [<c150f286>] tty_lock_nested+0x36/0x80
[ 1128.563259]        [<c150f2df>] tty_lock+0xf/0x20
[ 1128.563263]        [<c128d904>] __tty_hangup+0x54/0x430
[ 1128.563267]        [<c128dcf2>] do_tty_hangup+0x12/0x20
[ 1128.563272]        [<c1052a02>] process_one_work+0x1a2/0x4d0
[ 1128.563275]        [<c1054509>] worker_thread+0x119/0x3b0
[ 1128.563279]        [<c105a1ff>] kthread+0x9f/0xb0
[ 1128.563283]        [<c150fc37>] ret_from_kernel_thread+0x1b/0x28
[ 1128.563287] 
[ 1128.563287] other info that might help us debug this:
[ 1128.563287] 
[ 1128.563290] Chain exists of:
[ 1128.563290]   &tty->legacy_mutex --> &tty->legacy_mutex/1 --> (&tty->hangup_work)
[ 1128.563290] 
[ 1128.563297]  Possible unsafe locking scenario:
[ 1128.563297] 
[ 1128.563299]        CPU0                    CPU1
[ 1128.563301]        ----                    ----
[ 1128.563302]   lock((&tty->hangup_work));
[ 1128.563305]                                lock(&tty->legacy_mutex/1);
[ 1128.563309]                                lock((&tty->hangup_work));
[ 1128.563312]   lock(&tty->legacy_mutex);
[ 1128.563315] 
[ 1128.563315]  *** DEADLOCK ***
[ 1128.563315] 
[ 1128.563319] 2 locks held by kworker/1:1/31:
[ 1128.563320]  #0:  (events){.+.+.+}, at: [<c1052983>] process_one_work+0x123/0x4d0
[ 1128.563328]  #1:  ((&tty->hangup_work)){+.+...}, at: [<c1052983>] process_one_work+0x123/0x4d0
[ 1128.563335] 
[ 1128.563335] stack backtrace:
[ 1128.563339] Pid: 31, comm: kworker/1:1 Not tainted 3.7.0 #195
[ 1128.563341] Call Trace:
[ 1128.563348]  [<c1506992>] print_circular_bug+0x1af/0x1b9
[ 1128.563352]  [<c10852ae>] __lock_acquire+0x165e/0x1710
[ 1128.563358]  [<c1085809>] lock_acquire+0x79/0xf0
[ 1128.563362]  [<c150f286>] ? tty_lock_nested+0x36/0x80
[ 1128.563366]  [<c150c1fa>] mutex_lock_nested+0x4a/0x2f0
[ 1128.563370]  [<c150f286>] ? tty_lock_nested+0x36/0x80
[ 1128.563375]  [<c128d8d2>] ? __tty_hangup+0x22/0x430
[ 1128.563379]  [<c150f286>] tty_lock_nested+0x36/0x80
[ 1128.563383]  [<c150f2df>] tty_lock+0xf/0x20
[ 1128.563388]  [<c128d904>] __tty_hangup+0x54/0x430
[ 1128.563391]  [<c1052983>] ? process_one_work+0x123/0x4d0
[ 1128.563396]  [<c128dcf2>] do_tty_hangup+0x12/0x20
[ 1128.563400]  [<c1052a02>] process_one_work+0x1a2/0x4d0
[ 1128.563403]  [<c1052983>] ? process_one_work+0x123/0x4d0
[ 1128.563407]  [<c10545ae>] ? worker_thread+0x1be/0x3b0
[ 1128.563411]  [<c128dce0>] ? __tty_hangup+0x430/0x430
[ 1128.563415]  [<c1054509>] worker_thread+0x119/0x3b0
[ 1128.563419]  [<c10543f0>] ? __next_gcwq_cpu+0x60/0x60
[ 1128.563424]  [<c105a1ff>] kthread+0x9f/0xb0
[ 1128.563428]  [<c150fc37>] ret_from_kernel_thread+0x1b/0x28
[ 1128.563433]  [<c105a160>] ? kthread_create_on_node+0xe0/0xe0

--------------070204000703020005060104
Content-Type: text/plain;
 name="tty_lock_issue2"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tty_lock_issue2"

[   14.711344] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   14.713505] Bluetooth: BNEP socket layer initialized
[   14.714497] Bluetooth: RFCOMM TTY layer initialized
[   14.714511] Bluetooth: RFCOMM socket layer initialized
[   14.714512] Bluetooth: RFCOMM ver 1.11
[   15.385668] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input17
[   57.826528] PPP generic driver version 2.4.2
[   66.309295] 
[   66.309301] ======================================================
[   66.309303] [ INFO: possible circular locking dependency detected ]
[   66.309307] 3.7.0 #195 Not tainted
[   66.309308] -------------------------------------------------------
[   66.309310] kworker/2:1/35 is trying to acquire lock:
[   66.309313]  (&tty->legacy_mutex){+.+.+.}, at: [<c150f286>] tty_lock_nested+0x36/0x80
[   66.309328] 
[   66.309328] but task is already holding lock:
[   66.309330]  ((&tty->hangup_work)){+.+...}, at: [<c1052983>] process_one_work+0x123/0x4d0
[   66.309340] 
[   66.309340] which lock already depends on the new lock.
[   66.309340] 
[   66.309343] 
[   66.309343] the existing dependency chain (in reverse order) is:
[   66.309345] 
[   66.309345] -> #2 ((&tty->hangup_work)){+.+...}:
[   66.309351]        [<c1085809>] lock_acquire+0x79/0xf0
[   66.309357]        [<c1053168>] flush_work+0x48/0x250
[   66.309360]        [<c1294a56>] tty_ldisc_flush_works+0x16/0x30
[   66.309366]        [<c1295941>] tty_ldisc_release+0x21/0x70
[   66.309370]        [<c128ee7c>] tty_release+0x37c/0x4a0
[   66.309376]        [<c11175cc>] __fput+0xcc/0x1f0
[   66.309381]        [<c11176fd>] ____fput+0xd/0x10
[   66.309385]        [<c1056eb9>] task_work_run+0x89/0xa0
[   66.309390]        [<c1002b11>] do_notify_resume+0x51/0x80
[   66.309394]        [<c150f578>] work_notifysig+0x29/0x31
[   66.309399] 
[   66.309399] -> #1 (&tty->legacy_mutex/1){+.+...}:
[   66.309405]        [<c1085809>] lock_acquire+0x79/0xf0
[   66.309409]        [<c150c1fa>] mutex_lock_nested+0x4a/0x2f0
[   66.309413]        [<c150f286>] tty_lock_nested+0x36/0x80
[   66.309417]        [<c150f319>] tty_lock_pair+0x29/0x70
[   66.309421]        [<c128ec30>] tty_release+0x130/0x4a0
[   66.309425]        [<c11175cc>] __fput+0xcc/0x1f0
[   66.309429]        [<c11176fd>] ____fput+0xd/0x10
[   66.309432]        [<c1056eb9>] task_work_run+0x89/0xa0
[   66.309436]        [<c1002b11>] do_notify_resume+0x51/0x80
[   66.309440]        [<c150f578>] work_notifysig+0x29/0x31
[   66.309444] 
[   66.309444] -> #0 (&tty->legacy_mutex){+.+.+.}:
[   66.309448]        [<c10852ae>] __lock_acquire+0x165e/0x1710
[   66.309453]        [<c1085809>] lock_acquire+0x79/0xf0
[   66.309456]        [<c150c1fa>] mutex_lock_nested+0x4a/0x2f0
[   66.309460]        [<c150f286>] tty_lock_nested+0x36/0x80
[   66.309464]        [<c150f2df>] tty_lock+0xf/0x20
[   66.309468]        [<c128d904>] __tty_hangup+0x54/0x430
[   66.309472]        [<c128dcf2>] do_tty_hangup+0x12/0x20
[   66.309476]        [<c1052a02>] process_one_work+0x1a2/0x4d0
[   66.309480]        [<c1054509>] worker_thread+0x119/0x3b0
[   66.309484]        [<c105a1ff>] kthread+0x9f/0xb0
[   66.309488]        [<c150fc37>] ret_from_kernel_thread+0x1b/0x28
[   66.309492] 
[   66.309492] other info that might help us debug this:
[   66.309492] 
[   66.309495] Chain exists of:
[   66.309495]   &tty->legacy_mutex --> &tty->legacy_mutex/1 --> (&tty->hangup_work)
[   66.309495] 
[   66.309502]  Possible unsafe locking scenario:
[   66.309502] 
[   66.309504]        CPU0                    CPU1
[   66.309506]        ----                    ----
[   66.309507]   lock((&tty->hangup_work));
[   66.309510]                                lock(&tty->legacy_mutex/1);
[   66.309514]                                lock((&tty->hangup_work));
[   66.309517]   lock(&tty->legacy_mutex);
[   66.309520] 
[   66.309520]  *** DEADLOCK ***
[   66.309520] 
[   66.309524] 2 locks held by kworker/2:1/35:
[   66.309525]  #0:  (events){.+.+.+}, at: [<c1052983>] process_one_work+0x123/0x4d0
[   66.309532]  #1:  ((&tty->hangup_work)){+.+...}, at: [<c1052983>] process_one_work+0x123/0x4d0
[   66.309539] 
[   66.309539] stack backtrace:
[   66.309543] Pid: 35, comm: kworker/2:1 Not tainted 3.7.0 #195
[   66.309545] Call Trace:
[   66.309552]  [<c1506992>] print_circular_bug+0x1af/0x1b9
[   66.309556]  [<c10852ae>] __lock_acquire+0x165e/0x1710
[   66.309562]  [<c1085809>] lock_acquire+0x79/0xf0
[   66.309566]  [<c150f286>] ? tty_lock_nested+0x36/0x80
[   66.309571]  [<c150c1fa>] mutex_lock_nested+0x4a/0x2f0
[   66.309575]  [<c150f286>] ? tty_lock_nested+0x36/0x80
[   66.309579]  [<c128d8d2>] ? __tty_hangup+0x22/0x430
[   66.309583]  [<c150f286>] tty_lock_nested+0x36/0x80
[   66.309588]  [<c150f2df>] tty_lock+0xf/0x20
[   66.309592]  [<c128d904>] __tty_hangup+0x54/0x430
[   66.309596]  [<c1052983>] ? process_one_work+0x123/0x4d0
[   66.309600]  [<c128dcf2>] do_tty_hangup+0x12/0x20
[   66.309604]  [<c1052a02>] process_one_work+0x1a2/0x4d0
[   66.309607]  [<c1052983>] ? process_one_work+0x123/0x4d0
[   66.309611]  [<c10545ae>] ? worker_thread+0x1be/0x3b0
[   66.309616]  [<c128dce0>] ? __tty_hangup+0x430/0x430
[   66.309620]  [<c1054509>] worker_thread+0x119/0x3b0
[   66.309624]  [<c10543f0>] ? __next_gcwq_cpu+0x60/0x60
[   66.309628]  [<c105a1ff>] kthread+0x9f/0xb0
[   66.309633]  [<c150fc37>] ret_from_kernel_thread+0x1b/0x28
[   66.309637]  [<c105a160>] ? kthread_create_on_node+0xe0/0xe0

--------------070204000703020005060104--
