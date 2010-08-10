Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab0HJVJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 17:09:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56024 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab0HJVJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:09:42 -0400
Date: Tue, 10 Aug 2010 23:09:41 +0200
From: Heinz Diehl <htd@fritha.org>
To: linux-kernel@vger.kernel.org
Subject: [BUG] USB no longer works for APCUPS
Message-ID: <20100810210941.GA7938@fritha.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100810 (GNU/Linux)
X-Provags-ID: V02:K0:Hk34cvZaiNijxV/DZa0d8uM4GcUZCrXDD5IIk0J4Tbr
 +OXRl+mdiN2IWMkuOPrSmX3qCNThQ8YRO53bYz1az87bPA5+jD
 4+DVUARI71htHt7yLbBQ8i0Pv3dloTgT0sojIWnKFB84oEx/jz
 4XgIzkptv4+4SrDtDeqLVLlRdpLg7yhbMBuCJDtDM8PEpgKZ97
 IaU5xQgpPLiBraCIrasTA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm getting this in my logs with the latest -git7/8/9 kernels. Thw apcups
is not defective, it works flawlessly with 2.6.34.X.

Aug 10 23:01:44 liesel apcupsd[7687]: apcupsd FATAL ERROR in linux-usb.c
at line 609 Cannot find UPS device -- For a link to detailed USB trouble
shooting information, please see <http://www.apcupsd.com/support.html>.
Aug 10 23:01:44 liesel apcupsd[7687]: apcupsd error shutdown completed
Aug 10 23:04:40 liesel kernel: ------------[ cut here ]------------

Aug 10 23:04:40 liesel kernel: WARNING: at lib/kobject.c:595 kobject_put+0x2f/0x50()
Aug 10 23:04:40 liesel kernel: Hardware name: GA-MA770-UD3 Aug 10 23:04:40 liesel kernel: kobject: '(null)' (ffff88022c651898): is
not initialized, yet kobject_put() is being called. Aug 10 23:04:40 liesel kernel: Modules linked in: xt_pkttype ipt_LOG
xt_limit aes_x86_64 aes_generic af_packet it87 hwmon_vid binfmt_misc snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device cpufreq_conservative
cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table mperf xt_NOTRACK xt_state iptable_raw nf_conntrack_netbios_ns
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip6_tables ipt_REJECT iptable_filter ip_tables tcp_vegas uhci_hcd rt73usb rt2x00usb rt2x00lib
r8169 led_class mii mac80211 snd_hda_codec_realtek ppdev parport_pc cfg80211 parport snd_hda_intel snd_hda_codec snd_pcm snd_timer snd
soundcore sr_mod k10temp hwmon i2c_piix4 pcspkr cdrom button rfkill joydev snd_page_alloc i2c_core sg xts usbhid sd_mod ohci_hcd ehci_hcd rtc_cmos
rtc_core pata_atiixp rtc_lib usbcore ahci libahci hmac dm_snapshot dm_crypt dm_mod gf128mul sha512_generic sha256_generic twofish_x86_64
twofish_common serpent cbc tgr192 loop ecb arc4 fuse edd ide_pci_generic amd74xx ide_core fan pata_amd sata_nv libata scsi
Aug 10 23:04:40 liesel kernel: Pid: 1115, comm: khubd Not tainted 2.6.35-git9 #1
Aug 10 23:04:40 liesel kernel: Call Trace:
Aug 10 23:04:40 liesel kernel:  [<ffffffff812a620f>] ? kobject_put+0x2f/0x50
Aug 10 23:04:40 liesel kernel:  [<ffffffff812a620f>] ? kobject_put+0x2f/0x50
Aug 10 23:04:40 liesel kernel:  [<ffffffff810414f1>] ? warn_slowpath_common+0x81/0xe0
Aug 10 23:04:40 liesel kernel:  [<ffffffff81041605>] ? warn_slowpath_fmt+0x45/0x50
Aug 10 23:04:40 liesel kernel:  [<ffffffff812a620f>] ? kobject_put+0x2f/0x50
Aug 10 23:04:40 liesel kernel:  [<ffffffffa00bea3e>] ? usbhid_disconnect+0x1e/0x40 [usbhid]
Aug 10 23:04:40 liesel kernel:  [<ffffffffa01a7525>] ? usb_unbind_interface+0xc5/0x120 [usbcore]
Aug 10 23:04:40 liesel kernel:  [<ffffffff8133ffc8>] ? __device_release_driver+0x78/0xf0
Aug 10 23:04:40 liesel kernel:  [<ffffffff81340125>] ? device_release_driver+0x25/0x40
Aug 10 23:04:40 liesel kernel:  [<ffffffff8133f4a2>] ? bus_remove_device+0xa2/0xf0
Aug 10 23:04:40 liesel kernel:  [<ffffffff8133d7da>] ? device_del+0x12a/0x1d0
Aug 10 23:04:40 liesel kernel:  [<ffffffffa01a4b8d>] ? usb_disable_device+0x8d/0x110 [usbcore]
Aug 10 23:04:40 liesel kernel:  [<ffffffffa019f6bb>] ? usb_disconnect+0x7b/0x120 [usbcore]
Aug 10 23:04:40 liesel kernel:  [<ffffffffa01a03c2>] ? hub_thread+0x322/0x11d0 [usbcore]
Aug 10 23:04:40 liesel kernel:  [<ffffffff81034a77>] ? set_next_entity+0x37/0x80
Aug 10 23:04:40 liesel kernel:  [<ffffffff8105c330>] ? autoremove_wake_function+0x0/0x30
Aug 10 23:04:40 liesel kernel:  [<ffffffffa01a00a0>] ? hub_thread+0x0/0x11d0 [usbcore]
Aug 10 23:04:40 liesel kernel:  [<ffffffffa01a00a0>] ? hub_thread+0x0/0x11d0 [usbcore]
Aug 10 23:04:40 liesel kernel:  [<ffffffff8105be56>] ? kthread+0x96/0xb0
Aug 10 23:04:40 liesel kernel:  [<ffffffff81003b14>] ? kernel_thread_helper+0x4/0x10
Aug 10 23:04:40 liesel kernel:  [<ffffffff8105bdc0>] ? kthread+0x0/0xb0
Aug 10 23:04:40 liesel kernel:  [<ffffffff81003b10>] ? kernel_thread_helper+0x0/0x10
Aug 10 23:04:40 liesel kernel: ---[ end trace 808e80ff1e6d651e ]---

