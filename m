Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab1AGV43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 16:56:29 -0500
Received: from torres.zugschlus.de ([85.214.131.164]:58068 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab1AGV42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 16:56:28 -0500
Date: Fri, 7 Jan 2011 22:56:26 +0100
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Oxford serial Expresscard buffer/handshake issues?
Message-ID: <20110107215626.GA26043@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to use an Expresscard-based serial card as serial console
for a notebook that is positioned in a datacenter. The card reports
itself as:
04:00.0 Serial controller [0700]: Oxford Semiconductor Ltd Device [1415:c138]
and causes the following log entries when it is plugged in:
Jan  7 22:33:40 swivel kernel: [ 3184.840290] pciehp 0000:00:1c.2:pcie04: Card present on Slot(4)
Jan  7 22:33:40 swivel kernel: [ 3184.852448] pciehp 0000:00:1c.2:pcie04: Card not present on Slot(4)
Jan  7 22:33:40 swivel kernel: [ 3184.901059] pciehp 0000:00:1c.2:pcie04: Card present on Slot(4)
Jan  7 22:33:40 swivel kernel: [ 3185.024094] pci 0000:04:00.0: reg 10: [mem 0x00000000-0x00003fff]
Jan  7 22:33:40 swivel kernel: [ 3185.024114] pci 0000:04:00.0: reg 14: [mem 0x00000000-0x001fffff]
Jan  7 22:33:40 swivel kernel: [ 3185.024134] pci 0000:04:00.0: reg 18: [mem 0x00000000-0x001fffff]
Jan  7 22:33:40 swivel kernel: [ 3185.024247] pci 0000:04:00.0: supports D1 D2
Jan  7 22:33:40 swivel kernel: [ 3185.024251] pci 0000:04:00.0: PME# supported from D1 D2 D3hot D3cold
Jan  7 22:33:40 swivel kernel: [ 3185.024259] pci 0000:04:00.0: PME# disabled
Jan  7 22:33:40 swivel kernel: [ 3185.024304] pci 0000:04:00.0: BAR 1: assigned [mem 0xe8000000-0xe81fffff]
Jan  7 22:33:40 swivel kernel: [ 3185.024314] pci 0000:04:00.0: BAR 1: set to [mem 0xe8000000-0xe81fffff] (PCI address [0xe8000000-0xe81fffff]
Jan  7 22:33:40 swivel kernel: [ 3185.024318] pci 0000:04:00.0: BAR 2: assigned [mem 0xe8200000-0xe83fffff]
Jan  7 22:33:40 swivel kernel: [ 3185.024327] pci 0000:04:00.0: BAR 2: set to [mem 0xe8200000-0xe83fffff] (PCI address [0xe8200000-0xe83fffff]
Jan  7 22:33:40 swivel kernel: [ 3185.024331] pci 0000:04:00.0: BAR 0: assigned [mem 0xe8400000-0xe8403fff]
Jan  7 22:33:40 swivel kernel: [ 3185.024339] pci 0000:04:00.0: BAR 0: set to [mem 0xe8400000-0xe8403fff] (PCI address [0xe8400000-0xe8403fff]
Jan  7 22:33:40 swivel kernel: [ 3185.024343] pcieport 0000:00:1c.2: PCI bridge to [bus 04-0b]
Jan  7 22:33:40 swivel kernel: [ 3185.024349] pcieport 0000:00:1c.2:   bridge window [io  0x6000-0x7fff]
Jan  7 22:33:40 swivel kernel: [ 3185.024358] pcieport 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
Jan  7 22:33:40 swivel kernel: [ 3185.024364] pcieport 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff 64bit pref]
Jan  7 22:33:40 swivel kernel: [ 3185.024384] pcieport 0000:00:1c.2: setting latency timer to 64
Jan  7 22:33:40 swivel kernel: [ 3185.024403] pci 0000:04:00.0: no hotplug settings from platform
Jan  7 22:33:40 swivel kernel: [ 3185.024522] serial 0000:04:00.0: enabling device (0000 -> 0002)
Jan  7 22:33:40 swivel kernel: [ 3185.024532] serial 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan  7 22:33:40 swivel kernel: [ 3185.024568] 1 ports detected on Oxford PCI Express device
Jan  7 22:33:40 swivel kernel: [ 3185.024712] 0000:04:00.0: ttyS0 at MMIO 0xe8401000 (irq = 18) is a 16C950/954

If I understand correctly, this says that the interface is handled by
the stock serial driver. My kernel 2.6.26.2 is configured as follows:

$ grep SERIAL /boot/config-2.6.36.2-zgws1  | grep -v '^#'
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
$

However, there seems to be an issue with flow control and/or
buffering. When I start a getty on ttyS0, it looks like a lot of
output is missing:
|ser2net port 2100 device /dev/ttyUSB0 [9600 N81] (Debian GNU/Linux)
|
|
|Debian GNU/Linuxswivel login: mh
|Password:
|
|Login incorrecswivel login: mh
|Password:
|Last login: Fri Linux swivel 2.6ystem are free s/*/copyright.
|
|
|Filesystem      G   12K  1.5G   dev/shm
|/tmp        15G  4.5G  ome
|/dev/mapperv/mapper/scyw0021% /home/mh/musieo
|                 cached
|Mem
|Swap:      781ROM             init4: kded4 [kdtelnet localhost[1/501]mh@swivel
|[1/501]mh@swivellspci
|00:00.0 Host bri00:01.0 PCI bridAudio device: Inn N10/ICH 7 Fami2)
|00:1c.2 PCI 0/ICH 7 Family Pev 02)
|00:1d.1 l Corporation N1HCI Controller #I bridge: Intel ace Bridge (rev ler: Intel Corpoly SMBus Controlnet controller:  3945ABG [Golan]ridge: Texas Ins[2/502]mh@swivel

This happens as soon as the Expresscard is handling the serial port
that the getty is running on, regardless of the device that is
connecting to (tried a "real" serial port, a PL2303, and the aux
interface of a Cisco Router). On the other hand, all three connecting
devices work fine with getty if the device being connected to is
either a "real" serial port or a PL2303.

Is additional configuration necessary to make use of the Oxford serial
card as a serial console, or am I doing something differently wrong?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
