Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab0DLJeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 05:34:22 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:56615 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab0DLJeV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 05:34:21 -0400
Message-ID: <4BC2E918.50604@free.fr>
Date: Mon, 12 Apr 2010 11:34:16 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Andrey Rahmatullin <wrar@altlinux.org>
CC: linux-kernel@vger.kernel.org, lxc-devel@lists.sourceforge.net
Subject: Re: [lxc-devel] OOPS on lxc-stop
References: <20100411170542.GA5745@wrars-comp.wrarsdomain>
In-Reply-To: <20100411170542.GA5745@wrars-comp.wrarsdomain>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Rahmatullin wrote:
> Hello.
> When I run lxc-stop for my Debian container, my system OOPSes. This is not
> 100% reproducible, though. I could catch only a part of the OOPS report
> using netconsole:
>
>
> [ 9243.740626] Oops: 0000 [#1] PREEMPT
> [ 9243.740648] last sysfs file: /sys/devices/platform/w83627hf.656/fan1_input
> [ 9243.740655] Modules linked in: veth netconsole configfs cdc_acm nf_conntrack_ftp iptable_mangle radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core vboxnetadp vboxnetflt vboxdrv w83627hf hwmon_vid aes_i586 aes_generic af_packet ppp_deflate zlib_deflate bsd_comp ppp_async crc_ccitt ppp_generic slhc sit tunnel4 bridge stp llc ipv6 via_rhine mii ipt_LOG xt_limit ipt_REJECT xt_tcpudp xt_state xt_mac iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_filter ip_tables x_tables nls_cp1251 nls_cp866 vfat fat ext3 jbd mbcache arc4 ecb rt61pci crc_itu_t rt2x00pci snd_via82xx snd_ac97_codec ac97_bus snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi snd_seq_device snd rt2x00lib sr_mod cdrom processor fan thermal mac80211 thermal_sys usb_storage usb_libusual serial_core soundcore hwmon hid_a4tech button pata_via cfg80211 uhci_hcd eeprom_93cx6 fuse via_agp agpgart evdev usbhid hid ehci_hcd usbcore nls_base dm_mod [last unloaded: nf_conntrack_ftp]
> [ 9243.741009]
> [ 9243.741009] Pid: 22287, comm: init Not tainted 2.6.34-wrar-2 #1 KT600-8237/KT600-8237
> [ 9243.741009] EIP: 0060:[<c011e8a2>] EFLAGS: 00210086 CPU: 0
> [ 9243.741009] EIP is at set_next_entity+0xd/0x117
> [ 9243.741009] EAX: eeb050c0 EBX: 00000000 ECX: 00000000 EDX: 00000000
> [ 9243.741009] ESI: eeb050c0 EDI: c04734ac EBP: ed625df4 ESP: ed625de4
> [ 9243.741009]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> [ 9243.741009] Process init (pid: 22287, ti=ed625000 task=f36818c0 task.ti=ed625000)
> [ 9243.741009] Stack:
>
> This is 2.6.34-rc2, though I IIRC I had these crashes on .33 too.
>   

At the first glance I would say it is related to the FAIR_SCHEDULER. 
After having multiple Oops on my host, I decided to disable this option 
in the kernel. It is hard to reproduce, and with a few clues it is 
difficult to report the problem to lkml@.

Does sysrq + t show something ? Or the host is definitively stuck ?

Thanks
  -- Daniel

