Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1DGVsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 17:48:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39022 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1DGVsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 17:48:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=gjPaclRv8id7VSaCTj7UsoeVs10EXe5S7PEREGee3492R1TXz248mPtREzLo8hAQtm
         MrVwIg1QXQoRm0S6/fQeqfxcR9YQ05hrWf3HGRL97ZhoXv3UYkLSjkvCHm3KyFsy1zpj
         PjoIu5ucBWpX9u66zWPv45l4gMS7mxSqp6ir4=
MIME-Version: 1.0
Date: Thu, 7 Apr 2011 23:48:33 +0200
Message-ID: <BANLkTikd606C54jgaynZ5pppKALfHiDc8Q@mail.gmail.com>
Subject: Endless loop with "detected XactErr"
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've been trying to track some resume error with Intel GPU - and
notice a couple problems related to resume of my Lenovo T61.
Laptop has been docked - and suspend/resume has been performed without
'undocking' laptop.

After several iterations of suspend/resume - I've got this endless
printing loop with this line on console display:

ehci_hcd 0000:00:1a.7: detected XactErr len 0/4 retry 1

Just with changing last number - I've got only one such line on serial console.
By looking into  "drivers/usb/host/ehci-q.c"  - there seems to be
endless goto loop.

>From the log it looks like my USB mouse connected to docking station
was the source of problem.
(Maybe a movement ??)

Here is the trace from last resume:

[    0.000000] Linux version 2.6.39-rc2-00005-gf04d4dc (kabi@linux)
(gcc version 4.6.0 20110331 (Red Hat 4.6.0-2) (GCC) ) #119 SMP PREEMPT
Wed Apr 6 15:27:55 CEST 2011
[    0.000000] Command line: ro root=/dev/sda2 selinux=0 kmemleak=off
lockdep.prove_locking=0 lockdep.lock_stat=0 SYSFONT=latarcyrheb-sun16
LANG=cs_CZ.UTF-8 KEYTABLE=us systemd.log_level=info
systemd.log_target=kmsg systemd.sysv_console=true
console=ttyS0,115200n8 console=tty drm.debug=0xe
...
[    3.605707] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.612698] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.620138] usb usb2: Product: EHCI Host Controller
[    3.625187] usb usb2: Manufacturer: Linux 2.6.39-rc2-00005-gf04d4dc ehci_hcd
[    3.632406] usb usb2: SerialNumber: 0000:00:1a.7
...
[    7.017440] input: Logitech Optical USB Mouse as
/devices/pci0000:00/0000:00:1a.7/usb2/2-4/2-4.4/2-4.4:1.0/input/input5
[    7.017666] generic-usb 0003:046D:C016.0001: input: USB HID v1.10
Mouse [Logitech Optical USB Mouse] on usb-0000:00:1a.7-4.4/input0
...
[  466.138551] PM: resume of devices complete after 3797.616 msecs
[  467.809750] PM: Finishing wakeup.
[  467.813162] Restarting tasks ...
[  467.816673] hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0000
[  467.822422] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  467.827956] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  467.833510] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  467.839041] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  467.844571] hub 1-0:1.0: state 7 ports 2 chg 0004 evt 0004
[  467.850164] hub 1-0:1.0: port 2, status 0103, change 0000, 12 Mb/s
[  467.852203] done.
[  467.858332] hub 2-0:1.0: state 7 ports 4 chg 0010 evt 0000
[  467.862691] video LNXVIDEO:00: Restoring backlight state
[  467.869497] [drm:intel_panel_get_max_backlight], max backlight PWM = 12056655
[  467.869500] [drm:intel_panel_set_backlight], set backlight PWM = 12056655
[  467.869504] [drm:intel_panel_get_max_backlight], max backlight PWM = 12056655
[  467.869511] [drm:intel_opregion_asle_intr], non asle set request??
[  467.869515] [drm:intel_opregion_asle_intr], non asle set request??
[  467.869572] hub 2-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[  467.920355] ehci_hcd 0000:00:1a.7: port 4 high speed
[  467.923301] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001005 0
 ACK POWER sig=se0 PE CONNECT
[  467.975320] [drm:drm_crtc_helper_set_config],
[  467.975323] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9]
#connectors=1 (x y) (0 0)
[  467.975338] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1]
to [CRTC:4]
[  468.005138] usb 2-4: new high speed USB device number 12 using ehci_hcd
[  468.067008] ehci_hcd 0000:00:1a.7: port 4 high speed
[  468.069960] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001005 0
 ACK POWER sig=se0 PE CONNECT
[  468.154142] usb 2-4: udev 12, busnum 2, minor = 139
[  468.161303] usb 2-4: New USB device found, idVendor=04b3, idProduct=4485
[  468.170269] usb 2-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[  468.179654] usb 2-4: usb_probe_device
[  468.185068] usb 2-4: configuration #1 chosen from 1 choice
[  468.193537] usb 2-4: adding 2-4:1.0 (config #1, interface 0)
[  468.201128] hub 2-4:1.0: usb_probe_interface
[  468.207421] hub 2-4:1.0: usb_probe_interface - got id
[  468.214292] hub 2-4:1.0: USB hub found
[  468.220402] hub 2-4:1.0: 4 ports detected
[  468.228538] hub 2-4:1.0: standalone hub
[  468.234184] hub 2-4:1.0: individual port power switching
[  468.241381] hub 2-4:1.0: individual port over-current protection
[  468.249652] hub 2-4:1.0: TT per port
[  468.254985] hub 2-4:1.0: TT requires at most 8 FS bit times (666 ns)
[  468.263575] hub 2-4:1.0: power on to power good time: 100ms
[  468.271550] hub 2-4:1.0: local power source is good
[  468.278823] hub 2-4:1.0: enabling power on all ports
[  468.289997] drivers/usb/core/inode.c: creating file '012'
[  468.387705] hub 2-4:1.0: port 4: status 0301 change 0001
[  468.496728] usb 2-4: link qh256-0001/ffff880120b9ac00 start 9 [1/0 us]
[  468.507602] hub 2-4:1.0: state 7 ports 4 chg 0010 evt 0000
[  468.517597] hub 2-4:1.0: port 4, status 0301, change 0000, 1.5 Mb/s
[  468.537004] hub 2-4:1.0: port 4 not reset yet, waiting 10ms
[  468.610244] usb 2-4.4: new low speed USB device number 13 using ehci_hcd
[  468.630223] hub 2-4:1.0: port 4 not reset yet, waiting 10ms
[  468.723696] usb 2-4.4: skipped 1 descriptor after interface
[  468.734517] usb 2-4.4: default language 0x0409
[  468.745646] usb 2-4.4: udev 13, busnum 2, minor = 140
[  468.754995] usb 2-4.4: New USB device found, idVendor=046d, idProduct=c016
[  468.766392] usb 2-4.4: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[  468.775979] usb 2-4.4: Product: Optical USB Mouse
[  468.782487] usb 2-4.4: Manufacturer: Logitech
[  468.789890] usb 2-4.4: usb_probe_device
[  468.795515] usb 2-4.4: configuration #1 chosen from 1 choice
[  468.803441] usb 2-4.4: adding 2-4.4:1.0 (config #1, interface 0)
[  468.811385] usbhid 2-4.4:1.0: usb_probe_interface
[  468.817759] usbhid 2-4.4:1.0: usb_probe_interface - got id
[  468.827419] input: Logitech Optical USB Mouse as
/devices/pci0000:00/0000:00:1a.7/usb2/2-4/2-4.4/2-4.4:1.0/input/input14
[  468.840451] usb 2-4.4: link qh8-0e01/ffff8801177d5900 start 2 [1/2 us]
[  468.849214] generic-usb 0003:046D:C016.0005: input: USB HID v1.10
Mouse [Logitech Optical USB Mouse] on usb-0000:00:1a.7-4.4/input0
[  468.863600] drivers/usb/core/inode.c: creating file '013'
[  470.340197] hub 4-0:1.0: hub_suspend
[  470.348199] usb usb4: bus auto-suspend
[  470.356097] ehci_hcd 0000:00:1d.7: suspend root hub
[  470.365083] hub 3-0:1.0: hub_suspend
[  470.372770] usb usb3: bus auto-suspend
[  470.380585] usb usb3: suspend_rh
[  470.387916] hub 7-0:1.0: hub_suspend
[  470.395551] usb usb7: bus auto-suspend
[  470.403356] usb usb7: suspend_rh
[  470.410592] hub 5-0:1.0: hub_suspend
[  470.418098] usb usb5: bus auto-suspend
[  470.425732] usb usb5: suspend_rh
[  470.432783] hub 6-0:1.0: hub_suspend
[  470.440145] usb usb6: bus auto-suspend
[  470.447700] usb usb6: suspend_rh
[  473.873802] ACPI: \_SB_.GDCK - undocking
[  473.897678] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0010
[  473.904809] ehci_hcd 0000:00:1a.7: detected XactErr len 0/4 retry 1
