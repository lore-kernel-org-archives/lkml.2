Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab0KRIAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:00:00 -0500
Received: from mognix.dark-green.com ([88.116.226.179]:62355 "EHLO
	mognix.dark-green.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab0KRH77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 02:59:59 -0500
MIME-Version: 1.0
Date: Thu, 18 Nov 2010 08:59:56 +0100
From: gimli <gimli@dark-green.com>
To: <linux-usb@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <gimli@dark-green.com>
Subject: [PATCH 1/1] Fix broken EHCI on MacbookAir3,1 and 3,2
Message-ID: <ab0700a6dccc811536a199377f38fa26@mognix.dark-green.com>
User-Agent: RoundCube Webmail/0.2.2
Content-Type: multipart/mixed;
	boundary="=_582954021befed6c798f4ebc0a91290b"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=_582954021befed6c798f4ebc0a91290b
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"

Workaround and fixup for EHCI power managment on MacBookAir3,1(2). The
breake happened after 2.6.35.

Insmod ehci_hcd with ppcd and lpm on the MacBookAir :

2010-11-18T08:31:41.286309+01:00 MacBookAir kernel: ehci_hcd: USB 2.0
'Enhanced' Host Controller (EHCI) Driver
2010-11-18T08:31:41.286350+01:00 MacBookAir kernel: Warning! ehci_hcd
should always be loaded before uhci_hcd and ohci_hcd, not after
2010-11-18T08:31:41.286356+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
power state changed by ACPI to D0
2010-11-18T08:31:41.286361+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
power state changed by ACPI to D0
2010-11-18T08:31:41.286379+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
PCI INT B -> Link[LUS2] -> GSI 22 (level, low) -> IRQ 22
2010-11-18T08:31:41.286384+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
setting latency timer to 64
2010-11-18T08:31:41.286394+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
EHCI Host Controller
2010-11-18T08:31:41.286400+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
new USB bus registered, assigned bus number 1
2010-11-18T08:31:41.286405+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
debug port 1
2010-11-18T08:31:41.309626+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
cache line size of 256 is not supported
2010-11-18T08:31:41.309669+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
irq 22, io mem 0x9328b100
2010-11-18T08:31:41.309675+01:00 MacBookAir kernel: usb 3-3: USB
disconnect, address 2
2010-11-18T08:31:41.319608+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
USB 2.0 started, EHCI 1.10
2010-11-18T08:31:41.319627+01:00 MacBookAir kernel: hub 1-0:1.0: USB hub
found
2010-11-18T08:31:41.319631+01:00 MacBookAir kernel: hub 1-0:1.0: 6 ports
detected
2010-11-18T08:31:41.319635+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
power state changed by ACPI to D0
2010-11-18T08:31:41.319638+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
power state changed by ACPI to D0
2010-11-18T08:31:41.319642+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
PCI INT B -> Link[Z001] -> GSI 21 (level, low) -> IRQ 21
2010-11-18T08:31:41.319646+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
setting latency timer to 64
2010-11-18T08:31:41.319649+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
EHCI Host Controller
2010-11-18T08:31:41.319653+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
new USB bus registered, assigned bus number 2
2010-11-18T08:31:41.319656+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
debug port 1
2010-11-18T08:31:41.342951+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
cache line size of 256 is not supported
2010-11-18T08:31:41.342985+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
irq 21, io mem 0x9328b000
2010-11-18T08:31:41.352971+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
USB 2.0 started, EHCI 1.10
2010-11-18T08:31:41.353006+01:00 MacBookAir kernel: bcm5974: bcm5974: could
not read from device
2010-11-18T08:31:41.353010+01:00 MacBookAir kernel: hub 2-0:1.0: USB hub
found
2010-11-18T08:31:41.353016+01:00 MacBookAir kernel: hub 2-0:1.0: 6 ports
detected
2010-11-18T08:31:41.483061+01:00 MacBookAir kernel: usb 3-5: USB
disconnect, address 3
2010-11-18T08:31:41.483098+01:00 MacBookAir kernel: usb 3-5.3: USB
disconnect, address 6
2010-11-18T08:31:41.483179+01:00 MacBookAir kernel: btusb_bulk_complete:
hci0 urb ffff880037bf4900 failed to resubmit (19)
2010-11-18T08:31:41.483185+01:00 MacBookAir kernel: btusb_intr_complete:
hci0 urb ffff880037bf4f00 failed to resubmit (19)
2010-11-18T08:31:41.483191+01:00 MacBookAir kernel: btusb_bulk_complete:
hci0 urb ffff880037bf4d80 failed to resubmit (19)
2010-11-18T08:31:41.483196+01:00 MacBookAir kernel: btusb_send_frame: hci0
urb ffff8800374519c0 submission failed
2010-11-18T08:31:41.856341+01:00 MacBookAir kernel: usb 3-6: USB
disconnect, address 7
2010-11-18T08:31:41.976284+01:00 MacBookAir kernel: usb 4-2: USB
disconnect, address 2
2010-11-18T08:31:41.976321+01:00 MacBookAir kernel: asix 4-2:1.0: eth1:
unregister 'asix' usb-0000:00:06.0-2, ASIX AX88772 USB 2.0 Ethernet
2010-11-18T08:31:43.729730+01:00 MacBookAir kernel: usb 1-6: new high speed
USB device using ehci_hcd and address 4
2010-11-18T08:31:43.969620+01:00 MacBookAir kernel: usb 1-6: unable to read
config index 0 descriptor/start: -71
2010-11-18T08:31:43.969657+01:00 MacBookAir kernel: usb 1-6: chopping to 0
config(s)
2010-11-18T08:31:44.036279+01:00 MacBookAir kernel: usb 1-6: string
descriptor 0 read error: -71
2010-11-18T08:31:44.036318+01:00 MacBookAir kernel: usb 1-6: no
configuration chosen from 0 choices
2010-11-18T08:31:44.142964+01:00 MacBookAir kernel: usb 2-2: new high speed
USB device using ehci_hcd and address 2
2010-11-18T08:31:44.382988+01:00 MacBookAir kernel: usb 2-2: unable to read
config index 0 descriptor/start: -71
2010-11-18T08:31:44.383026+01:00 MacBookAir kernel: usb 2-2: chopping to 0
config(s)
2010-11-18T08:31:44.446283+01:00 MacBookAir kernel: usb 2-2: string
descriptor 0 read error: -71
2010-11-18T08:31:44.446359+01:00 MacBookAir kernel: usb 2-2: no
configuration chosen from 0 choices
2010-11-18T08:31:44.731605+01:00 MacBookAir kernel: usb 3-3: new full speed
USB device using ohci_hcd and address 8
2010-11-18T08:31:44.949697+01:00 MacBookAir kernel: input: Apple Inc. Apple
Internal Keyboard / Trackpad as
/devices/pci0000:00/0000:00:04.0/usb3/3-3/3-3:1.0/input/input11
2010-11-18T08:31:44.949736+01:00 MacBookAir kernel: apple
0003:05AC:0243.0005: input,hidraw0: USB HID v1.11 Keyboard [Apple Inc.
Apple Internal Keyboard / Trackpad] on usb-0000:00:04.0-3/input0
2010-11-18T08:31:44.962959+01:00 MacBookAir kernel: apple
0003:05AC:0243.0006: hidraw1: USB HID v1.11 Device [Apple Inc. Apple
Internal Keyboard / Trackpad] on usb-0000:00:04.0-3/input1
2010-11-18T08:31:44.966248+01:00 MacBookAir kernel: input: bcm5974 as
/devices/pci0000:00/0000:00:04.0/usb3/3-3/3-3:1.2/input/input12
2010-11-18T08:31:45.246385+01:00 MacBookAir kernel: usb 3-5: new full speed
USB device using ohci_hcd and address 9
2010-11-18T08:31:45.449602+01:00 MacBookAir kernel: hub 3-5:1.0: USB hub
found
2010-11-18T08:31:45.452897+01:00 MacBookAir kernel: hub 3-5:1.0: 3 ports
detected
2010-11-18T08:31:45.756394+01:00 MacBookAir kernel: usb 3-5.1: new full
speed USB device using ohci_hcd and address 10
2010-11-18T08:31:45.872906+01:00 MacBookAir kernel: input: HID 05ac:820a as
/devices/pci0000:00/0000:00:04.0/usb3/3-5/3-5.1/3-5.1:1.0/input/input13
2010-11-18T08:31:45.872932+01:00 MacBookAir kernel: generic-usb
0003:05AC:820A.0007: input,hidraw2: USB HID v1.11 Keyboard [HID 05ac:820a]
on usb-0000:00:04.0-5.1/input0
2010-11-18T08:31:45.943021+01:00 MacBookAir kernel: usb 3-5.2: new full
speed USB device using ohci_hcd and address 11
2010-11-18T08:31:46.059630+01:00 MacBookAir kernel: input: HID 05ac:820b as
/devices/pci0000:00/0000:00:04.0/usb3/3-5/3-5.2/3-5.2:1.0/input/input14
2010-11-18T08:31:46.059667+01:00 MacBookAir kernel: generic-usb
0003:05AC:820B.0008: input,hidraw3: USB HID v1.11 Mouse [HID 05ac:820b] on
usb-0000:00:04.0-5.2/input0
2010-11-18T08:31:46.133015+01:00 MacBookAir kernel: usb 3-5.3: new full
speed USB device using ohci_hcd and address 12
2010-11-18T08:31:46.289594+01:00 MacBookAir kernel: usb 3-5.1: USB
disconnect, address 10
2010-11-18T08:31:46.436326+01:00 MacBookAir kernel: usb 3-5.2: USB
disconnect, address 11


Insmod withe ppcd and lpm workaround :

2010-11-18T08:33:48.729676+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
remove, state 1
2010-11-18T08:33:48.729714+01:00 MacBookAir kernel: usb usb2: USB
disconnect, address 1
2010-11-18T08:33:48.729719+01:00 MacBookAir kernel: usb 2-2: USB
disconnect, address 2
2010-11-18T08:33:48.729724+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
USB bus 2 deregistered
2010-11-18T08:33:48.729730+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
PCI INT B disabled
2010-11-18T08:33:48.729734+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
remove, state 1
2010-11-18T08:33:48.733419+01:00 MacBookAir kernel: usb usb1: USB
disconnect, address 1
2010-11-18T08:33:48.733456+01:00 MacBookAir kernel: usb 1-6: USB
disconnect, address 4
2010-11-18T08:33:48.733462+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
USB bus 1 deregistered
2010-11-18T08:33:48.736254+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
PCI INT B disabled
2010-11-18T08:33:49.013103+01:00 MacBookAir kernel: usb 3-6: new full speed
USB device using ohci_hcd and address 13
2010-11-18T08:33:49.376384+01:00 MacBookAir kernel: usb 4-2: new full speed
USB device using ohci_hcd and address 3
2010-11-18T08:33:50.466262+01:00 MacBookAir kernel: asix 4-2:1.0: eth1:
register 'asix' at usb-0000:00:06.0-2, ASIX AX88772 USB 2.0 Ethernet,
d8:30:62:a5:da:c1
2010-11-18T08:33:50.952889+01:00 MacBookAir kernel: ehci_hcd: Unknown
parameter `diable_ppcd'
2010-11-18T08:33:51.532930+01:00 MacBookAir kernel: eth1: link down
2010-11-18T08:33:51.566226+01:00 MacBookAir kernel: ADDRCONF(NETDEV_UP):
eth1: link is not ready
2010-11-18T08:33:52.101568+01:00 MacBookAir kernel:
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
2010-11-18T08:33:52.136219+01:00 MacBookAir kernel: eth1: link up, 100Mbps,
full-duplex, lpa 0x45E1
2010-11-18T08:33:58.036278+01:00 MacBookAir kernel: ehci_hcd: USB 2.0
'Enhanced' Host Controller (EHCI) Driver
2010-11-18T08:33:58.036299+01:00 MacBookAir kernel: Warning! ehci_hcd
should always be loaded before uhci_hcd and ohci_hcd, not after
2010-11-18T08:33:58.036302+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
power state changed by ACPI to D0
2010-11-18T08:33:58.036305+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
power state changed by ACPI to D0
2010-11-18T08:33:58.036309+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
PCI INT B -> Link[LUS2] -> GSI 22 (level, low) -> IRQ 22
2010-11-18T08:33:58.036312+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
setting latency timer to 64
2010-11-18T08:33:58.036316+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
EHCI Host Controller
2010-11-18T08:33:58.036320+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
new USB bus registered, assigned bus number 1
2010-11-18T08:33:58.036325+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
debug port 1
2010-11-18T08:33:58.059713+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
cache line size of 256 is not supported
2010-11-18T08:33:58.059749+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
irq 22, io mem 0x9328b100
2010-11-18T08:33:58.059754+01:00 MacBookAir kernel: usb 3-3: USB
disconnect, address 8
2010-11-18T08:33:58.069610+01:00 MacBookAir kernel: ehci_hcd 0000:00:04.1:
USB 2.0 started, EHCI 1.10
2010-11-18T08:33:58.069638+01:00 MacBookAir kernel: hub 1-0:1.0: USB hub
found
2010-11-18T08:33:58.069643+01:00 MacBookAir kernel: hub 1-0:1.0: 6 ports
detected
2010-11-18T08:33:58.069650+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
power state changed by ACPI to D0
2010-11-18T08:33:58.069655+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
power state changed by ACPI to D0
2010-11-18T08:33:58.069660+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
PCI INT B -> Link[Z001] -> GSI 21 (level, low) -> IRQ 21
2010-11-18T08:33:58.069666+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
setting latency timer to 64
2010-11-18T08:33:58.069670+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
EHCI Host Controller
2010-11-18T08:33:58.069676+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
new USB bus registered, assigned bus number 2
2010-11-18T08:33:58.069681+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
debug port 1
2010-11-18T08:33:58.096264+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
cache line size of 256 is not supported
2010-11-18T08:33:58.096314+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
irq 21, io mem 0x9328b000
2010-11-18T08:33:58.109624+01:00 MacBookAir kernel: ehci_hcd 0000:00:06.1:
USB 2.0 started, EHCI 1.10
2010-11-18T08:33:58.109659+01:00 MacBookAir kernel: hub 2-0:1.0: USB hub
found
2010-11-18T08:33:58.109664+01:00 MacBookAir kernel: hub 2-0:1.0: 6 ports
detected
2010-11-18T08:33:58.113133+01:00 MacBookAir kernel: bcm5974: bcm5974: could
not read from device
2010-11-18T08:33:58.239652+01:00 MacBookAir kernel: usb 3-5: USB
disconnect, address 9
2010-11-18T08:33:58.239670+01:00 MacBookAir kernel: usb 3-5.3: USB
disconnect, address 12
2010-11-18T08:33:58.239676+01:00 MacBookAir kernel: btusb_bulk_complete:
hci0 urb ffff88004f33bc00 failed to resubmit (19)
2010-11-18T08:33:58.239681+01:00 MacBookAir kernel: btusb_intr_complete:
hci0 urb ffff88002ca2ad80 failed to resubmit (19)
2010-11-18T08:33:58.239687+01:00 MacBookAir kernel: btusb_bulk_complete:
hci0 urb ffff88004f33b180 failed to resubmit (19)
2010-11-18T08:33:58.239692+01:00 MacBookAir kernel: btusb_send_frame: hci0
urb ffff88000ec510c0 submission failed
2010-11-18T08:33:58.609598+01:00 MacBookAir kernel: usb 3-6: USB
disconnect, address 13
2010-11-18T08:33:58.729609+01:00 MacBookAir kernel: usb 4-2: USB
disconnect, address 3
2010-11-18T08:33:58.729646+01:00 MacBookAir kernel: asix 4-2:1.0: eth1:
unregister 'asix' usb-0000:00:06.0-2, ASIX AX88772 USB 2.0 Ethernet
2010-11-18T08:33:59.209720+01:00 MacBookAir kernel: usb 1-6: new high speed
USB device using ehci_hcd and address 4
2010-11-18T08:33:59.349601+01:00 MacBookAir kernel: uvcvideo: Found UVC
1.00 device Built-in iSight (05ac:850a)
2010-11-18T08:33:59.356276+01:00 MacBookAir kernel: input: Built-in iSight
as /devices/pci0000:00/0000:00:04.1/usb1/1-6/1-6:1.0/input/input15
2010-11-18T08:33:59.466223+01:00 MacBookAir kernel: usb 2-2: new high speed
USB device using ehci_hcd and address 2
2010-11-18T08:34:00.387460+01:00 MacBookAir kernel: asix 2-2:1.0: eth1:
register 'asix' at usb-0000:00:06.1-2, ASIX AX88772 USB 2.0 Ethernet,
d8:30:62:a5:da:c1
2010-11-18T08:34:00.666301+01:00 MacBookAir kernel: usb 3-3: new full speed
USB device using ohci_hcd and address 14
2010-11-18T08:34:00.886274+01:00 MacBookAir kernel: input: Apple Inc. Apple
Internal Keyboard / Trackpad as
/devices/pci0000:00/0000:00:04.0/usb3/3-3/3-3:1.0/input/input16
2010-11-18T08:34:00.886314+01:00 MacBookAir kernel: apple
0003:05AC:0243.0009: input,hidraw0: USB HID v1.11 Keyboard [Apple Inc.
Apple Internal Keyboard / Trackpad] on usb-0000:00:04.0-3/input0
2010-11-18T08:34:00.896290+01:00 MacBookAir kernel: apple
0003:05AC:0243.000A: hidraw1: USB HID v1.11 Device [Apple Inc. Apple
Internal Keyboard / Trackpad] on usb-0000:00:04.0-3/input1
2010-11-18T08:34:00.899566+01:00 MacBookAir kernel: input: bcm5974 as
/devices/pci0000:00/0000:00:04.0/usb3/3-3/3-3:1.2/input/input17
2010-11-18T08:34:01.179637+01:00 MacBookAir kernel: usb 3-5: new full speed
USB device using ohci_hcd and address 15
2010-11-18T08:34:01.383039+01:00 MacBookAir kernel: hub 3-5:1.0: USB hub
found
2010-11-18T08:34:01.386235+01:00 MacBookAir kernel: hub 3-5:1.0: 3 ports
detected
2010-11-18T08:34:01.422884+01:00 MacBookAir kernel: eth1: link down
2010-11-18T08:34:01.426467+01:00 MacBookAir kernel: ADDRCONF(NETDEV_UP):
eth1: link is not ready
2010-11-18T08:34:01.686386+01:00 MacBookAir kernel: usb 3-5.1: new full
speed USB device using ohci_hcd and address 16
2010-11-18T08:34:01.799630+01:00 MacBookAir kernel: input: HID 05ac:820a as
/devices/pci0000:00/0000:00:04.0/usb3/3-5/3-5.1/3-5.1:1.0/input/input18
2010-11-18T08:34:01.799671+01:00 MacBookAir kernel: generic-usb
0003:05AC:820A.000B: input,hidraw2: USB HID v1.11 Keyboard [HID 05ac:820a]
on usb-0000:00:04.0-5.1/input0
2010-11-18T08:34:01.869623+01:00 MacBookAir kernel: usb 3-5.2: new full
speed USB device using ohci_hcd and address 17
2010-11-18T08:34:01.982955+01:00 MacBookAir kernel: input: HID 05ac:820b as
/devices/pci0000:00/0000:00:04.0/usb3/3-5/3-5.2/3-5.2:1.0/input/input19
2010-11-18T08:34:01.982994+01:00 MacBookAir kernel: generic-usb
0003:05AC:820B.000C: input,hidraw3: USB HID v1.11 Mouse [HID 05ac:820b] on
usb-0000:00:04.0-5.2/input0
2010-11-18T08:34:02.052931+01:00 MacBookAir kernel: usb 3-5.3: new full
speed USB device using ohci_hcd and address 18
2010-11-18T08:34:02.192880+01:00 MacBookAir kernel:
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
2010-11-18T08:34:02.192891+01:00 MacBookAir kernel: usb 3-5.1: USB
disconnect, address 16
2010-11-18T08:34:02.196393+01:00 MacBookAir kernel: eth1: link up, 100Mbps,
full-duplex, lpa 0x45E1
2010-11-18T08:34:02.346239+01:00 MacBookAir kernel: usb 3-5.2: USB
disconnect, address 17
2010-11-18T08:34:12.426233+01:00 MacBookAir kernel: eth1: no IPv6 routers
present


lsusb :

Bus 002 Device 003: ID 05ac:1402 Apple, Inc. 
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 004: ID 05ac:850a Apple, Inc. 
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 024: ID 05ac:821b Apple, Inc. 
Bus 003 Device 021: ID 0a5c:4500 Broadcom Corp. BCM2046B1 USB 2.0 Hub (part
of BCM2046 Bluetooth)
Bus 003 Device 020: ID 05ac:0243 Apple, Inc. 
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub


As you can see, not all devices are connected again after inserting
ehci-hcd.
In this bug : https://bugzilla.kernel.org/show_bug.cgi?id=21182 you see
another user with the same problem.
I'm not sure if only Apple users with Nvidia chipset are affected.


Please CC me, i'm not subscribed to the list.


Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>
--=_582954021befed6c798f4ebc0a91290b
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="UTF-8";
 name="macbookair_ehci.patch"; 
Content-Disposition: attachment;
 filename="macbookair_ehci.patch"; 

ZGlmZiAtdU5yIGxpbnV4LTIuNi4zNi9kcml2ZXJzL3VzYi9ob3N0L2VoY2kuaCBsaW51eC0yLjYu
MzYtcGF0Y2hlZC9kcml2ZXJzL3VzYi9ob3N0L2VoY2kuaAotLS0gbGludXgtMi42LjM2L2RyaXZl
cnMvdXNiL2hvc3QvZWhjaS5oCTIwMTAtMTAtMjAgMjI6MzA6MjIuMDAwMDAwMDAwICswMjAwCisr
KyBsaW51eC0yLjYuMzYtcGF0Y2hlZC9kcml2ZXJzL3VzYi9ob3N0L2VoY2kuaAkyMDEwLTExLTE4
IDA4OjIyOjI1Ljg0NjY2NjgwMiArMDEwMApAQCAtMTQyLDYgKzE0Miw3IEBACiAJX19oYzMyCQkJ
Km9oY2lfaGNjdHJsX3JlZzsKIAl1bnNpZ25lZAkJaGFzX2hvc3RwYzoxOwogCXVuc2lnbmVkCQlo
YXNfbHBtOjE7ICAvKiBzdXBwb3J0IGxpbmsgcG93ZXIgbWFuYWdlbWVudCAqLworCXVuc2lnbmVk
CQl1c2VfcHBjZDoxOyAvKiBlbmFibGUgYXV0b3N1cHBvcnQgcGVyLXBvcnQgY2hhbmdlIGJpdHMg
Ki8KIAl1bnNpZ25lZAkJaGFzX3BwY2Q6MTsgLyogc3VwcG9ydCBwZXItcG9ydCBjaGFuZ2UgYml0
cyAqLwogCXU4CQkJc2JybjsJCS8qIHBhY2tlZCByZWxlYXNlIG51bWJlciAqLwogCmRpZmYgLXVO
ciBsaW51eC0yLjYuMzYvZHJpdmVycy91c2IvaG9zdC9laGNpLWhjZC5jIGxpbnV4LTIuNi4zNi1w
YXRjaGVkL2RyaXZlcnMvdXNiL2hvc3QvZWhjaS1oY2QuYwotLS0gbGludXgtMi42LjM2L2RyaXZl
cnMvdXNiL2hvc3QvZWhjaS1oY2QuYwkyMDEwLTEwLTIwIDIyOjMwOjIyLjAwMDAwMDAwMCArMDIw
MAorKysgbGludXgtMi42LjM2LXBhdGNoZWQvZHJpdmVycy91c2IvaG9zdC9laGNpLWhjZC5jCTIw
MTAtMTEtMTggMDg6MjE6NTEuMDEzMzMzNDY4ICswMTAwCkBAIC01OTAsNyArNTkwLDcgQEAKIAlp
ZiAobG9nMl9pcnFfdGhyZXNoIDwgMCB8fCBsb2cyX2lycV90aHJlc2ggPiA2KQogCQlsb2cyX2ly
cV90aHJlc2ggPSAwOwogCXRlbXAgPSAxIDw8ICgxNiArIGxvZzJfaXJxX3RocmVzaCk7Ci0JaWYg
KEhDQ19QRVJfUE9SVF9DSEFOR0VfRVZFTlQoaGNjX3BhcmFtcykpIHsKKwlpZiAoSENDX1BFUl9Q
T1JUX0NIQU5HRV9FVkVOVChoY2NfcGFyYW1zKSAmJiBlaGNpLT51c2VfcHBjZCkgewogCQllaGNp
LT5oYXNfcHBjZCA9IDE7CiAJCWVoY2lfZGJnKGVoY2ksICJlbmFibGUgcGVyLXBvcnQgY2hhbmdl
IGV2ZW50XG4iKTsKIAkJdGVtcCB8PSBDTURfUFBDRUU7CmRpZmYgLXVOciBsaW51eC0yLjYuMzYv
ZHJpdmVycy91c2IvaG9zdC9laGNpLXBjaS5jIGxpbnV4LTIuNi4zNi1wYXRjaGVkL2RyaXZlcnMv
dXNiL2hvc3QvZWhjaS1wY2kuYwotLS0gbGludXgtMi42LjM2L2RyaXZlcnMvdXNiL2hvc3QvZWhj
aS1wY2kuYwkyMDEwLTEwLTIwIDIyOjMwOjIyLjAwMDAwMDAwMCArMDIwMAorKysgbGludXgtMi42
LjM2LXBhdGNoZWQvZHJpdmVycy91c2IvaG9zdC9laGNpLXBjaS5jCTIwMTAtMTEtMTggMDg6MzU6
MTEuMjI2NjY2ODAzICswMTAwCkBAIC0yMiw2ICsyMiwxNiBAQAogI2Vycm9yICJUaGlzIGZpbGUg
aXMgUENJIGJ1cyBnbHVlLiAgQ09ORklHX1BDSSBtdXN0IGJlIGRlZmluZWQuIgogI2VuZGlmCiAK
Ky8qIGRpc2FibGUgcGVyLXBvcnQgY2hhbmdlIGJpdHMgKi8KK3N0YXRpYyB1bnNpZ25lZCBpbnQg
ZGlzYWJsZV9wcGNkID0gMDsKK21vZHVsZV9wYXJhbShkaXNhYmxlX3BwY2QsIGludCwgU19JUlVH
Tyk7CitNT0RVTEVfUEFSTV9ERVNDKGRpc2FibGVfcHBjZCwgImV4cGxpY2l0IGRpc2FibGUgcGVy
LXBvcnQgY2hhbmdlIGJpdHMuIHNldCB0byAxIHRvIGRpc2FibGVcbiIpOworCisvKiBkaXNhYmxl
IGxpbmsgcG93ZXIgbWFuYWdlbWVudCAqLworc3RhdGljIHVuc2lnbmVkIGludCBkaXNhYmxlX2xw
bSA9IDA7Cittb2R1bGVfcGFyYW0oZGlzYWJsZV9scG0sIGludCwgU19JUlVHTyk7CitNT0RVTEVf
UEFSTV9ERVNDKGRpc2FibGVfbHBtLCAiZXhwbGljaXQgZm9yY2UgdG8gZGlzYWJsZSBsaW5rIHBv
d2VyIG1hbmFnZW1lbnQuIHNldCB0byAxIHRvIGRpc2FibGVcbiIpOworCiAvKi0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0qLwogCiAvKiBjYWxsZWQgYWZ0ZXIgcG93ZXJ1cCwgYnkgcHJvYmUgb3Igc3lzdGVtLXBt
ICJ3YWtldXAiICovCkBAIC0xNDgsNiArMTU4LDEzIEBACiAJCQlpZiAocGRldi0+cmV2aXNpb24g
PCAweGE0KQogCQkJCWVoY2ktPm5vX3NlbGVjdGl2ZV9zdXNwZW5kID0gMTsKIAkJCWJyZWFrOwor
ICAgIC8qIE1hY0Jvb2tBaXIzLDEoMikgCisgICAgICogcHBjZCBhbmQgbHBtIGRvZXMgbm90IHdv
cmsgKi8KKyAgICBjYXNlIDB4MGQ5YzoKKyAgICBjYXNlIDB4MGQ5ZDoKKwkgICAgZWhjaS0+dXNl
X3BwY2QgPSAwOworCSAgICBlaGNpLT5oYXNfbHBtID0gMDsKKyAgICAgIGJyZWFrOwogCQl9CiAJ
CWJyZWFrOwogCWNhc2UgUENJX1ZFTkRPUl9JRF9WSUE6CkBAIC0yNDksNiArMjY2LDE2IEBACiAJ
CX0KIAl9CiAKKyAgLyogZXhwbGljaXQgZGlzYWJsZSBwZXItcG9ydCBjaGFuZ2UgYml0cyAqLwor
ICBpZihlaGNpLT51c2VfcHBjZCAmJiBkaXNhYmxlX3BwY2QpIHsKKyAgICBlaGNpLT51c2VfcHBj
ZCA9IDA7CisgIH0KKworICAvKiBleHBsaWNpdCBkaXNhYmxlIHBlci1wb3J0IGNoYW5nZSBiaXRz
ICovCisgIGlmKGVoY2ktPmhhc19scG0gJiYgZGlzYWJsZV9scG0pIHsKKyAgICBlaGNpLT5oYXNf
bHBtID0gMDsKKyAgfQorCiAjaWZkZWYJQ09ORklHX1VTQl9TVVNQRU5ECiAJLyogUkVWSVNJVDog
dGhlIGNvbnRyb2xsZXIgd29ya3MgZmluZSBmb3Igd2FrZXVwIGlmZiB0aGUgcm9vdCBodWIKIAkg
KiBpdHNlbGYgaXMgImdsb2JhbGx5IiBzdXNwZW5kZWQsIGJ1dCB1c2Jjb3JlIGN1cnJlbnRseSBk
b2Vzbid0Cg==
--=_582954021befed6c798f4ebc0a91290b--

