Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab1GaPlY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 11:41:24 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46781 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab1GaPlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 11:41:19 -0400
Message-ID: <4E35779B.7020908@gmail.com>
Date: Sun, 31 Jul 2011 17:41:15 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: linux-rt-users <linux-rt-users@vger.kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: bug with debug registers and 3.0rt6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Portal 2's anti debugger checks hangs on rt6:

[21940.633370] BUG: sleeping function called from invalid context at kernel/rtmutex.c:645
[21940.633371] in_atomic(): 1, irqs_disabled(): 0, pid: 4235, name: portal2.exe
[21940.633372] Pid: 4235, comm: portal2.exe Tainted: P        WC  3.0.0-rt6-patser+ #3
[21940.633377] Call Trace:
[21940.633381]  [<ffffffff8103fc0a>] __might_sleep+0xca/0xf0
[21940.633383]  [<ffffffff8160d344>] rt_spin_lock+0x24/0x40
[21940.633385]  [<ffffffff8106b879>] force_sig_info+0x49/0x100
[21940.633387]  [<ffffffff8100e6d8>] send_sigtrap+0x68/0x70
[21940.633389]  [<ffffffff8160e6f0>] do_debug+0x150/0x160
[21940.633390]  [<ffffffff8160dbf2>] debug+0x22/0x40

and int3:
[15945.341955] BUG: sleeping function called from invalid context at kernel/rtmutex.c:645
[15945.341957] in_atomic(): 1, irqs_disabled(): 0, pid: 3166, name: portal2.exe
[15945.341958] Pid: 3166, comm: portal2.exe Tainted: P        WC  3.0.0-rt6-patser+ #3
[15945.341959] Call Trace:
[15945.341963]  [<ffffffff8103fc0a>] __might_sleep+0xca/0xf0
[15945.341965]  [<ffffffff8160d344>] rt_spin_lock+0x24/0x40
[15945.341968]  [<ffffffff8106b879>] force_sig_info+0x49/0x100
[15945.341969]  [<ffffffff8106b946>] force_sig+0x16/0x20
[15945.341970]  [<ffffffff8160e0ab>] do_trap+0x16b/0x170
[15945.341972]  [<ffffffff8160e509>] do_int3+0x99/0xc0
[15945.341973]  [<ffffffff8160dc32>] int3+0x22/0x40

Is there a better solution than converting the siglock to a raw spinlock?

~Maarten
