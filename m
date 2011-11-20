Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab1KTL5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 06:57:36 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53216 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab1KTL5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 06:57:34 -0500
From: Antonio Marcos =?utf-8?q?L=C3=B3pez_Alonso?= 
	<amlopezalonso@gmail.com>
Reply-To: amlopezalonso@gmail.com
To: linux-kernel@vger.kernel.org
Subject: VIA-Rhine II looses connectivity
Date: Sun, 20 Nov 2011 11:56:46 +0000
User-Agent: KMail/1.13.7 (Linux/3.0.0-2-amd64; KDE/4.6.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_+rOyOct9y1w+qs3"
Message-Id: <201111201156.46778.amlopezalonso@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_+rOyOct9y1w+qs3
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Since several releases ago I'm experiencing apparently random network 
disconnects due to some VIA-Rhine II related issue, having to reboot my Debian 
box (this was reported as Debian bugs #641919, #549606). By now, I'm unable  
to discover the exact moment in which the disconnects happens but seems to be 
somewhat related to network activity degree. The phenomenon brings lots of:

via-rhine 0000:00:12.0: eth0: Transmit timed out, status 0003, PHY status 
786d, resetting...
via-rhine 0000:00:12.0: eth0: link up, 100Mbps, full-duplex, lpa 0x41E1

In earlier releases it seemed that heavy network activity (such as torrent) 
seemed to ease the problem. Also setting irqpoll and/or noapic options seemed 
to help a bit but didn't completely fix the problem.

Now in recent releases the problem seems to increases its happening 
probability with heavy network activity (the opposite behavior). Of course, 
this observation is completely subjective.

I'm attaching a kernel oops log. In the meantime I'll test again the noapic 
option.

Thanks for any advice.
Antonio

--Boundary-00=_+rOyOct9y1w+qs3
Content-Type: text/x-log;
  charset="UTF-8";
  name="kernel.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="kernel.log"

Kernel failure message 1:
=2D-----------[ cut here ]------------
WARNING: at /build/buildd-linux-2.6_3.0.0-6-amd64-WVZwan/linux-2.6-3.0.0/de=
bian/build/source_amd64_none/net/sched/sch_generic.c:255 dev_watchdog+0xe9/=
0x148()
Hardware name: System Product Name
NETDEV WATCHDOG: eth0 (via-rhine): transmit queue 0 timed out
Modules linked in: nls_cp437 vfat fat usb_storage uas pci_stub vboxpci(O) v=
boxnetadp(O) vboxnetflt(O) vboxdrv(O) snd_hrtimer powernow_k8 mperf cpufreq=
_stats cpufreq_userspace cpufreq_conservative cpufreq_powersave ppdev lp bi=
nfmt_misc fuse nls_utf8 ntfs loop cx22702 nvidia(P) cx88_dvb cx88_vp3054_i2=
c videobuf_dvb dvb_core snd_hda_codec_realtek ir_lirc_codec lirc_dev rc_hau=
ppauge ir_sony_decoder snd_hda_intel snd_hda_codec snd_hwdep cx88_alsa tune=
r_simple tuner_types ir_jvc_decoder snd_seq_midi ir_rc6_decoder snd_rawmidi=
 ir_rc5_decoder tuner snd_pcm_oss snd_seq_midi_event snd_mixer_oss ir_nec_d=
ecoder snd_pcm snd_seq cx8802 cx8800 cx88xx rc_core i2c_algo_bit tveeprom v=
4l2_common videodev snd_timer media edac_core edac_mce_amd snd_seq_device v=
4l2_compat_ioctl32 evdev psmouse snd btcx_risc videobuf_dma_sg i2c_viapro s=
oundcore videobuf_core serio_raw pcspkr i2c_core snd_page_alloc k8temp parp=
ort_pc shpchp pci_hotplug asus_atk0110 parport processor button thermal_sys=
 ext4 mbcache jbd2 crc16 sg sr_mod sd_mod cdrom crc_t10dif ata_generic sata=
_via pata_via libata uhci_hcd floppy ehci_hcd scsi_mod usbcore via_rhine mi=
i [last unloaded: scsi_wait_scan]
Pid: 3826, comm: gnucash Tainted: P           O 3.0.0-2-amd64 #1
Call Trace:
 <IRQ>  [<ffffffff810464c1>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffff81046576>] ? warn_slowpath_fmt+0x45/0x4a
 [<ffffffff81017259>] ? x86_pmu_enable_all+0x38/0x4b
 [<ffffffff81295718>] ? netif_tx_lock+0x43/0x77
 [<ffffffff81295881>] ? dev_watchdog+0xe9/0x148
 [<ffffffff81052aa4>] ? run_timer_softirq+0x1bf/0x28a
 [<ffffffff811a84e7>] ? rb_insert_color+0xb1/0xd9
 [<ffffffff81295798>] ? netif_tx_unlock+0x4c/0x4c
 [<ffffffff810670d3>] ? timekeeping_get_ns+0xd/0x2a
 [<ffffffff8104bd74>] ? __do_softirq+0xb9/0x178
 [<ffffffff8133d29c>] ? call_softirq+0x1c/0x30
 [<ffffffff8100a9ef>] ? do_softirq+0x3f/0x84
 [<ffffffff8104bfe0>] ? irq_exit+0x3f/0xa3
 [<ffffffff8101f56e>] ? smp_apic_timer_interrupt+0x76/0x86
 [<ffffffff8133ca53>] ? apic_timer_interrupt+0x13/0x20
 <EOI>=20
=2D--[ end trace 0e8265e480e37954 ]---
--Boundary-00=_+rOyOct9y1w+qs3--
