Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab1DZVFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:05:23 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:53442 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab1DZVFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:05:20 -0400
X-Greylist: delayed 1494 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Apr 2011 17:05:20 EDT
Date: Tue, 26 Apr 2011 22:40:16 +0200
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: asterisk-dev@lists.digium.com
Cc: nikola.ciprich@linuxbox.cz, linux-kernel@vger.kernel.org
Subject: 2.6.32.21 + dahdi_dummy (dahdi-2.3.0.1) - uptime related crash?
Message-ID: <20110426204016.GA21044@linuxbox.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 5050704 records (last update: 20110426)
X-Envelope-From: ciprich@linuxbox.cz
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,
I have just experienced (almost) simultaneous crash of two identical machines running asterisks and using dahdi_dummy. Both machines were running without problems for about 250 days and suddenly almost at same time, both of them crashed.
both machines were running 2.6.32.21 (SMP x86_64) and using dahdi_dummy (dahdi-2.3.0.1)

here's the tail of the backtrace:

[<ffffffff81120cc7>] pollwake+0x57/0x60
[<ffffffff81046720>] ? default_wake_function+0x0/0x10
[<ffffffff8103683a>] __wake_up_common+0x5a/0x90
[<ffffffff8103a313>] __wake_up+0x43/0x70
[<ffffffffa0321573>] process_masterspan+0x643/0x670 [dahdi]
[<ffffffffa0326595>] coretimer_func+0x135/0x1d0 [dahdi]
[<ffffffff8105d74d>] run_timer_softirq+0x15d/0x320
[<ffffffffa0326460>] ? coretimer_func+0x0/0x1d0 [dahdi]
[<ffffffff8105690c>] __do_softirq+0xcc/0x220
[<ffffffff8100c40c>] call_softirq+0x1c/0x30
[<ffffffff8100e3ba>] do_softirq+0x4a/0x80
[<ffffffff810567c7>] irq_exit+0x87/0x90
[<ffffffff8100d7b7>] do_IRQ+0x77/0xf0
[<ffffffff8100bc53>] ret_from_intr+0x0/Oxa
<EUI> [<ffffffffa019e556>] ? acpi_idle_enter_bm+0x273/0x2a1 [processor]
[<ffffffffa019e54c>] ? acpi_idle_enter_bm+0x269/0x2a1 [processor]
[<ffffffff81280095>] ? cpuidle_idle_call+0xa5/0x150
[<ffffffff8100a18f>] ? cpu_idle+0x4f/0x90
[<ffffffff81323c95>] ? rest_init+0x75/0x80
[<ffffffff81582d7f>] ? start_kernel+0x2ef/0x390
[<ffffffff81582271>] ? x86_64_start_reservations+0x81/0xc0
[<ffffffff81582386>] ? x86_64_start_kernel+0xd6/0x100
Sorry, it's trimmed a bit :(

I can't find any related bugreport, so I'm not sure whether I've hit some problem already solved. To me, it seems like some counter might have overflowed or the like (that could explain why machines were running for so long and then suddenly both of them crashed..)
Of course used dahdi version was quite old, so I should update anyways, but I'd sleep safer if I'd know the problem already got fixed..
Anyone has some idea?
Should more information be needed, I'd be more then glad to help...
Thanks a lot in advance!
with best regards
nik

-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
