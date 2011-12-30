Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab1L3PhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 10:37:20 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:58723 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab1L3PhR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 10:37:17 -0500
MIME-Version: 1.0
Date: Fri, 30 Dec 2011 10:37:14 -0500
Message-ID: <CAFp-nYgSA0_v7SLgcaEyrPmLAPGCg1pEUhEki7r1bZy0ZoW+ow@mail.gmail.com>
Subject: [BUG] Ksoftirqd and kworker use %100 of the cpu after resuming from
 the suspend and the hibernation mode
From: Servet Portakal <servetportakal@gmail.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm Servet. I have a problem with my asus laptop for 3 years.
Ksoftirqd and kworker use %100 of the cpu after resuming from the
suspend and the hibernation mode. For example;  Ksoftirqd/1 %42,
kworker/1:0 %29, kworker/1:1 %28 .( probably they use only one core)

I'm not an expert. nonetheless I tried to pick some
error messegas to ease your work.

I suspended the machine. then I pressed a key to resume. Before the
computer is completely ready, I pressed consistently 'ctrl+alt+F1' . I
saw some messages on the black screen.

ata1: ACPİ set timing mode failed (status: 0x300b)
ata3.00 : exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata3.00 : failed command :READ VERİFY SECTOR(S)
cmd: 40/00:01:00:00:00/00:00:00:00/e0 tag 0
res: 40/00:01:00:00:00/00:00:00:00/40 Emask:0x4 (timeout)
pm_op():scsi_bus_resume_common+0x0/0x60 returns 134217730
PM: Device 2:0:0:0 failed to resume async:error 134217730

Other messages that I picked randomly...

Dec 22 12:07:10 pp-F5SR kernel: [  953.824052] ata3: lost interrupt
(Status 0x50)
Dec 18 20:19:02 pp-F5SR kernel: [ 6201.389186] ACPI Exception:
AE_AML_PACKAGE_LIMIT, Index (0x00000000FFFFFFFF) is beyond end of
object (20110623/exoparg2-418)
Dec 22 08:11:26 pp-F5SR kernel: [ 3673.781367] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.IDEC.IDE0._STM] (Node
ffff8800ba233b40), AE_AML_PACKAGE_LIMIT (20110623/psparse-536)
Dec 18 20:19:02 pp-F5SR kernel: [ 6231.840067] ata3.00: status: { DRDY }
Dec 18 20:19:02 pp-F5SR kernel: [ 6231.840090] ata3: soft resetting link
Dec 18 20:19:02 pp-F5SR kernel: [ 6232.020419] ata3.00: configured for UDMA/133
Dec 18 20:19:02 pp-F5SR kernel: [ 6232.020424] ata3.00: device
reported invalid CHS sector 0
Dec 18 20:19:02 pp-F5SR kernel: [ 6232.020437] ata3: EH complete
Dec 18 20:19:02 pp-F5SR kernel: [ 6232.020444] sd 2:0:0:0: [sda]
START_STOP FAILED
Dec 18 20:19:02 pp-F5SR kernel: [ 6232.020447] sd 2:0:0:0: [sda]
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Dec 18 20:19:02 pp-F5SR kernel: [ 6232.020451] sd 2:0:0:0: [sda]
Sense Key : Aborted Command [current] [descriptor]
Dec 18 20:19:02 pp-F5SR kernel: [ 6232.020455] sd 2:0:0:0: [sda]  Add.
Sense: No additional sense information
Dec 18 20:19:02 pp-F5SR kernel: [ 6232.027242] WARNING: at
/build/buildd/linux-3.2.0/kernel/power/suspend_test.c:53
suspend_test_finish+0x86/0x90()
Hardware name: F5SR
Component: resume devices, time: 30308
Modules linked in: nls_iso8859_1 nls_cp437 vfat fat bnep rfcomm
pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) fglrx(P) vboxdrv(O)
parport_pc ppdev joydev btusb bluetooth snd_hda_codec_realtek uvcvideo
videodev v4l2_compat_ioctl32 snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm snd_seq_midi snd_rawmidi arc4 snd_seq_midi_event snd_seq
snd_timer snd_seq_device snd psmouse serio_raw video ath9k mac80211
soundcore asus_laptop sparse_keymap input_polldev snd_page_alloc
ath9k_common ath9k_hw ath cfg80211 sis_agp lp parport usbhid hid
usb_storage uas sata_sis sis190
Pid: 5804, comm: pm-suspend Tainted: P           O 3.2.0-6-generic #12-Ubuntu
Dec 22 08:11:26 pp-F5SR kernel: [ 3704.088453] Call Trace:
Dec 22 08:11:26 pp-F5SR kernel: [ 3704.088460]  [<ffffffff810651af>]
warn_slowpath_common+0x7f/0xc0
Dec 22 08:11:26 pp-F5SR kernel: [ 3704.088464]  [<ffffffff810652a6>]
warn_slowpath_fmt+0x46/0x50
Dec 22 08:11:26 pp-F5SR kernel: [ 3704.088467]  [<ffffffff810a9566>]
suspend_test_finish+0x86/0x90
Dec 22 08:11:26 pp-F5SR kernel: [ 3704.088470]  [<ffffffff810a925b>]
suspend_devices_and_enter+0xfb/0x1f0
Dec 22 08:11:26 pp-F5SR kernel: [ 3704.088474]  [<ffffffff810a9421>]
enter_state+0xd1/0x110
Dec 22 08:11:26 pp-F5SR kernel: [ 3704.088477]  [<ffffffff810a7e27>]
state_store+0xb7/0x130
Dec 22 08:11:26 pp-F5SR kernel: [ 3704.088482]  [<ffffffff8130854f>]
kobj_attr_store+0xf/0x30
Dec 22 08:11:26 pp-F5SR kernel: [ 3704.088486]  [<ffffffff811e995f>]
sysfs_write_file+0xef/0x170
Dec 22 08:11:26 pp-F5SR kernel: [ 3704.088491]  [<ffffffff81176393>]
vfs_write+0xb3/0x180
Dec 22 08:11:26 pp-F5SR kernel: [ 3704.088494]  [<ffffffff811766ba>]
sys_write+0x4a/0x90
Dec 22 08:11:26 pp-F5SR kernel: [ 3704.088499]  [<ffffffff81659fc2>]
system_call_fastpath+0x16/0x1b
Dec 22 08:11:26 pp-F5SR kernel: [ 3704.088501] ---[ end trace
97db7a78a723efe4 ]---
Dec 22 08:11:26 pp-F5SR kernel: [ 3704.088801] PM: Finishing wakeup.
Dec 22 08:11:26 pp-F5SR kernel: [ 3704.088802] Restarting tasks ... done.
Dec 22 08:11:27 pp-F5SR kernel: [ 3705.084533]
[fglrx:fireglAsyncioIntEnableMsgHandler] *ERROR* interrupt source
ff000066 is not supported on this hardware (return code = 1)
Dec 22 08:11:27 pp-F5SR kernel: [ 3705.854881] EXT4-fs (sda5):
re-mounted. Opts: errors=remount-ro,commit=0
Dec 22 08:11:28 pp-F5SR kernel: [ 3706.092179]
[fglrx:fireglAsyncioIntEnableMsgHandler] *ERROR* interrupt source
ff000066 is not supported on this hardware (return code = 1)
Dec 22 10:50:30 pp-F5SR kernel: [    0.953710] sis190: 0000:00:04.0:
Error EEPROM read 0
Dec 19 13:45:36 pp-F5SR kernel: [    0.539077] ERST: Table is not found!
Dec 19 13:45:36 pp-F5SR kernel: [    0.539079] GHES: HEST is not enabled!
Dec 19 13:45:36 pp-F5SR kernel: [    0.472120] Simple Boot Flag value
0xc0 read from CMOS RAM was invalid

/usr/lib/pm-utils/sleep.d/49bluetooth suspend suspend: not applicable.
Running hook /usr/lib/pm-utils/sleep.d/55NetworkManager suspend suspend:
Having NetworkManager put all interaces to sleep...Failed.

/usr/lib/pm-utils/sleep.d/55NetworkManager suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/60_wpa_supplicant suspend suspend:
Failed to connect to wpa_supplicant - wpa_ctrl_open: No such file or directory

Dec 22 08:11:26 pp-F5SR kernel: [ 3673.781367] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.IDEC.IDE0._STM] (Node
ffff8800ba233b40), AE_AML_PACKAGE_LIMIT (20110623/psparse-536)
Dec 22 10:50:44 pp-F5SR pulseaudio[1821]: [pulseaudio]
bluetooth-util.c: Error from RegisterEndpoint reply:
org.freedesktop.DBus.Error.UnknownMethod

On windows 7, suspend mode was not working unless I close hybrid-sleep
mode. İt may help...

I'm not attaching any log file to the mail. My first message with 20
files attached didn't reach the list.
I think İt was blocked. İf you need more information, please tell me simply.

Bestow me to spend your time. And for my low level English.

Best regards.
Servet   -   Asus X59Sr-200DV
