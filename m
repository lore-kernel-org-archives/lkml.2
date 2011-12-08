Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751084Ab1LHLd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 06:33:29 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33015 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab1LHLd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 06:33:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAPRPZsAqjWtbUH8FSh3O3C6iQ7+L11782fc1e=-UDSQkgm7FPg@mail.gmail.com>
References: <CAPRPZsCrGXKwYiOTzDde=5=8wMnMX0sxFvnustSSz4Z6BYJNzA@mail.gmail.com>
	<20111130154445.GA27198@gere.osrc.amd.com>
	<1E8B869C0C6913418421A406C094DF7C0205358F@sshaexmb1.amd.com>
	<CAPRPZsAL=xUCjTKaSgq117zppvZS0S7fHB0Ebk-JqXvV1vTPCQ@mail.gmail.com>
	<4EDB6C10.10102@ladisch.de>
	<CAPRPZsAc8wr_2KsRi3LnGi4ic-CzrFLbRvQfkrXckH--vaLkVQ@mail.gmail.com>
	<CAPRPZsBdnrProsTaSYnMKi6Q3dSsP9nYkw0CKnmb-BrmJxBivw@mail.gmail.com>
	<CAPRPZsBO_hvAv8o0vKh7XuE+RiEunETaxaPsmdm5yPe5YvOdPA@mail.gmail.com>
	<CAPRPZsDU2+ApCjQvEzRfOXfMLgfDS1j5zXF7hw4wy5yrzT-_7Q@mail.gmail.com>
	<4EDBA70E.3090905@ladisch.de>
	<CAPRPZsAqjWtbUH8FSh3O3C6iQ7+L11782fc1e=-UDSQkgm7FPg@mail.gmail.com>
Date: Thu, 8 Dec 2011 12:33:27 +0100
Message-ID: <CAPRPZsBzBNzrzbNDN2fBnWwQ-MYcRssfY5V+5mDXLbJ+-gd9SA@mail.gmail.com>
Subject: Re: Unhandled IRQs on AMD E-450
From: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "Huang, Shane" <Shane.Huang@amd.com>, Borislav Petkov <bp@amd64.org>,
        "Nguyen, Dong" <Dong.Nguyen@amd.com>, linux-kernel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I will now be checking this again on a fresh build (to ensure I
> haven't forgotten to unpatch anything). I will also install a new
> e1000 card although I doubt that it is defective.

I made a fresh 3.2.0-rc2 build and the problems are still there (the
previous kernel still had IRQ_FORCED_THREADING disabled).

I both modified the IRQ handlers in the firewire-ohci and e1000 driver
to log, when they are called, whether they think the interrupt was
meant for them ('ours') or not ('not ours').

The results (for IRQ16 it took a rather long while to obtain) are listed below.

I have the impression that I see the same failure mechanism for both
IRQs. All goes well for a while, until an IRQ storm starts right
(e1000: 19 us, firewire-ohci: 39 us) after a valid IRQ.

Therefore there is a strong correlation between the arrival of the
spurious interrupt, alledgedly caused by a mystery device, and the
earlier arrival of a valid interrupt for a device. Combined with the
fact that it happens on 2 different IRQs pretty much rules out the
possibilty for me that there is either a mystery device at all, or
that the existing devices would both be defective, does it not ?

I also do not understand, if there would be a stuck IRQ line, why I
can unload and reload e1000 and firewire-ohci without immediately
getting the same IRQ storm.

Are there any tools suitable for tracing the handling of the last
valid interrupt ?

Thanks for any tips (and again for Clemens for providing a hack making
it possible for me to keep the disk IRQs out of the danger zone).


J.


dmesg logs for IRQ 16 and IRQ 19 getting banned.


...
[67962.892870] e1000: ours (271)
[67964.897018] e1000: ours (272)
[67966.900981] e1000: ours (273)
[67968.904908] e1000: ours (274)
[67970.908794] e1000: ours (275)
[67970.908813] e1000: not ours (0)
[67970.908825] e1000: not ours (1)
[67970.908835] e1000: not ours (2)
[67970.908845] e1000: not ours (3)
[67970.908855] e1000: not ours (4)
[67970.908865] e1000: not ours (5)
[67970.908877] e1000: not ours (6)
[67970.908887] e1000: not ours (7)
[67970.908895] e1000: not ours (8)
[67970.908907] e1000: not ours (9)
[67970.908917] e1000: not ours (10)
[67970.908927] e1000: not ours (11)
[67970.908936] e1000: not ours (12)
[67970.908945] e1000: not ours (13)
[67970.908954] e1000: not ours (14)
[67970.908964] e1000: not ours (15)
[67971.904010] e1000_intr: 152423 callbacks suppressed
[67971.904013] e1000: not ours (16)
[67971.904021] e1000: not ours (17)
[67971.904030] e1000: not ours (18)
[67971.904039] e1000: not ours (19)
[67971.904047] e1000: not ours (20)
[67971.904056] e1000: not ours (21)
[67971.904065] e1000: not ours (22)
[67971.904075] e1000: not ours (23)
[67971.904084] e1000: not ours (24)
[67971.904093] e1000: not ours (25)
[67971.904102] e1000: not ours (26)
[67971.904112] e1000: not ours (27)
[67971.904121] e1000: not ours (28)
[67971.904128] e1000: not ours (29)
[67971.904137] e1000: not ours (30)
[67971.904147] e1000: not ours (31)
[67971.904156] e1000: not ours (32)
[67971.904165] e1000: not ours (33)
[67971.904174] e1000: not ours (34)
[67971.904184] e1000: not ours (35)
[67972.210296] irq 19: nobody cared (try booting with the "irqpoll" option)
[67972.210305] Pid: 0, comm: swapper Not tainted 3.2.0-rc2 #2
[67972.210309] Call Trace:
[67972.210312]  <IRQ>  [<ffffffff810bbafd>] __report_bad_irq+0x3d/0xe0
[67972.210329]  [<ffffffff810bbf3d>] note_interrupt+0x14d/0x210
[67972.210335]  [<ffffffff810b98c4>] handle_irq_event_percpu+0xc4/0x290
[67972.210342]  [<ffffffff810b9ad8>] handle_irq_event+0x48/0x70
[67972.210348]  [<ffffffff810bc92a>] handle_fasteoi_irq+0x5a/0xe0
[67972.210354]  [<ffffffff81004012>] handle_irq+0x22/0x40
[67972.210361]  [<ffffffff81506caa>] do_IRQ+0x5a/0xd0
[67972.210367]  [<ffffffff814fe86b>] common_interrupt+0x6b/0x6b
[67972.210370]  <EOI>  [<ffffffff81009906>] ? native_sched_clock+0x26/0x70
[67972.210387]  [<ffffffffa00c50d3>] ?
acpi_idle_enter_simple+0xc5/0x102 [processor]
[67972.210395]  [<ffffffffa00c50ce>] ?
acpi_idle_enter_simple+0xc0/0x102 [processor]
[67972.210403]  [<ffffffff814224e8>] cpuidle_idle_call+0xb8/0x230
[67972.210409]  [<ffffffff81001215>] cpu_idle+0xc5/0x130
[67972.210416]  [<ffffffff814e24a0>] rest_init+0x94/0xa4
[67972.210423]  [<ffffffff81aafba4>] start_kernel+0x3a7/0x3b4
[67972.210429]  [<ffffffff81aaf322>] x86_64_start_reservations+0x132/0x136
[67972.210435]  [<ffffffff81aaf416>] x86_64_start_kernel+0xf0/0xf7
[67972.210438] handlers:
[67972.210445] [<ffffffffa008e4f0>] e1000_intr
[67972.210449] Disabling IRQ #19
[67992.794771] irq_handler: 47265 callbacks suppressed
[67992.794783] firewire_ohci: ours (14)
[68056.795654] firewire_ohci: ours (15)
...

...
[158362.106314] firewire_ohci: ours (1426)
[158426.107131] firewire_ohci: ours (1427)
[158490.107972] firewire_ohci: ours (1428)
[158554.108857] firewire_ohci: ours (1429)
[158618.109671] firewire_ohci: ours (1430)
[158682.110521] firewire_ohci: ours (1431)
[158746.111369] firewire_ohci: ours (1432)
[158746.111408] firewire_ohci: not ours (0)
[158746.111421] firewire_ohci: not ours (1)
[158746.111432] firewire_ohci: not ours (2)
[158746.111444] firewire_ohci: not ours (3)
[158746.111461] firewire_ohci: not ours (4)
[158746.111473] firewire_ohci: not ours (5)
[158746.111484] firewire_ohci: not ours (6)
[158746.111495] firewire_ohci: not ours (7)
[158746.111502] firewire_ohci: not ours (8)
[158746.111510] firewire_ohci: not ours (9)
[158746.111518] firewire_ohci: not ours (10)
[158746.111526] firewire_ohci: not ours (11)
[158746.111534] firewire_ohci: not ours (12)
[158746.111542] firewire_ohci: not ours (13)
[158746.111550] firewire_ohci: not ours (14)
[158746.111558] firewire_ohci: not ours (15)
[158746.111565] firewire_ohci: not ours (16)
[158746.111573] firewire_ohci: not ours (17)
[158746.111581] firewire_ohci: not ours (18)
[158747.362748] irq 16: nobody cared (try booting with the "irqpoll" option)
[158747.362757] Pid: 0, comm: kworker/0:0 Not tainted 3.2.0-rc2 #2
[158747.362761] Call Trace:
[158747.362764]  <IRQ>  [<ffffffff810bbafd>] __report_bad_irq+0x3d/0xe0
[158747.362782]  [<ffffffff810bbf3d>] note_interrupt+0x14d/0x210
[158747.362788]  [<ffffffff810b98c4>] handle_irq_event_percpu+0xc4/0x290
[158747.362794]  [<ffffffff810b9ad8>] handle_irq_event+0x48/0x70
[158747.362800]  [<ffffffff810bc92a>] handle_fasteoi_irq+0x5a/0xe0
[158747.362807]  [<ffffffff81004012>] handle_irq+0x22/0x40
[158747.362814]  [<ffffffff81506caa>] do_IRQ+0x5a/0xd0
[158747.362820]  [<ffffffff814fe86b>] common_interrupt+0x6b/0x6b
[158747.362823]  <EOI>  [<ffffffff81009906>] ? native_sched_clock+0x26/0x70
[158747.362840]  [<ffffffffa00c50d3>] ?
acpi_idle_enter_simple+0xc5/0x102 [processor]
[158747.362848]  [<ffffffffa00c50ce>] ?
acpi_idle_enter_simple+0xc0/0x102 [processor]
[158747.362856]  [<ffffffff814224e8>] cpuidle_idle_call+0xb8/0x230
[158747.362862]  [<ffffffff81001215>] cpu_idle+0xc5/0x130
[158747.362869]  [<ffffffff814efb86>] start_secondary+0x1ed/0x1f4
[158747.362873] handlers:
[158747.362879] [<ffffffffa00b2100>] irq_handler
[158747.362883] Disabling IRQ #16
...
