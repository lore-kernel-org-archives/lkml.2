Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab0ENI4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:56:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64532 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0ENI4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=jXywfhsUV4vbAT2tgxFqrOJxEFmwrB+p/1ussf6SnAj0VVpiAIoe2XhDGK+Gt/hrSs
         61ECw/oLJOA5gkuQzYN6CSZ0cFOf1gI2B/j86xtwwjQP4ukf0Jh7Bwzg2WvuExZwa58R
         udPMQf0mC+sNixvbKs4kU8kYOCDvh3wj7+XsY=
MIME-Version: 1.0
Date: Fri, 14 May 2010 10:56:46 +0200
Message-ID: <AANLkTikyx2eaxaiUCFDSfpmn1UG0t2GOxArz6F4wp1LJ@mail.gmail.com>
Subject: WARNING: at lib/dma-debug.c:866 check_for_stack
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: olivier.grenie@dibcom.fr
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jslaby@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've noticed my dvb-t tuner reports this Warning about stack usage for DMA.
Is there some fix already available ?

dib0700: loaded with support for 14 different device-types
------------[ cut here ]------------
WARNING: at lib/dma-debug.c:866 check_for_stack+0xa4/0xe0()
Hardware name: 6464CTO
ehci_hcd 0000:00:1a.7: DMA-API: device driver maps memory fromstack
[addr=ffff8800a5083c68]
Modules linked in: dvb_usb_dib0700(+) dib7000p dib7000m dib0070
dvb_usb dib8000 dvb_core dib3000mc dibx000_common aes_generic hidp
rfcomm sco l2cap tun nfsd lockd nfs_acl auth_rpcgss exportfs
ip6_tables xt_tcpudp bridge stp llc autofs4 sunrpc ipv6 ipt_REJECT
xt_physdev xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables
binfmt_misc loop dm_mirror dm_region_hash dm_log dm_mod kvm_intel kvm
i915 drm_kms_helper drm i2c_algo_bit uinput arc4 ecb cryptomgr
snd_hda_codec_analog snd_hda_intel snd_hda_codec crypto_hash aead
pcompress snd_seq crypto_blkcipher crypto_algapi iwl3945
snd_seq_device snd_pcm iwlcore sdhci_pci sdhci thinkpad_acpi btusb
snd_timer mac80211 snd mmc_core cfg80211 bluetooth rtc_cmos psmouse
rtc_core soundcore i2c_i801 snd_page_alloc led_class iTCO_wdt rtc_lib
i2c_core nvram serio_raw iTCO_vendor_support rfkill e1000e evdev
battery ac usbhid hid sr_mod cdrom ehci_hcd uhci_hcd usbcore video
backlight output button [last unloaded: scsi_wait_scan]
Pid: 14621, comm: modprobe Not tainted 2.6.34-rc7-00017-gc41ef37 #69
Call Trace:
 [<ffffffff8104af2b>] warn_slowpath_common+0x7b/0xc0
 [<ffffffff8104afd1>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff81436b19>] ? sub_preempt_count+0xa9/0xe0
 [<ffffffff8126d904>] check_for_stack+0xa4/0xe0
 [<ffffffff8126db9d>] debug_dma_map_page+0xfd/0x160
 [<ffffffffa002a508>] dma_map_single_attrs.clone.2+0xc8/0x100 [usbcore]
 [<ffffffffa002ac06>] usb_hcd_submit_urb+0x6c6/0x8c0 [usbcore]
 [<ffffffff81080144>] ? static_obj+0x44/0x60
 [<ffffffff81081929>] ? lockdep_init_map+0x59/0x150
 [<ffffffff81433070>] ? _raw_spin_unlock_irq+0x30/0x60
 [<ffffffffa002b3e6>] usb_submit_urb+0xd6/0x260 [usbcore]
 [<ffffffffa002c78c>] usb_start_wait_urb+0x6c/0x100 [usbcore]
 [<ffffffffa002ba28>] ? usb_init_urb+0x28/0x40 [usbcore]
 [<ffffffffa002d0dd>] usb_control_msg+0xed/0x240 [usbcore]
 [<ffffffff81430d77>] ? __mutex_lock_common+0x387/0x4e0
 [<ffffffffa06064ab>] dib0700_identify_state+0x4b/0xa0 [dvb_usb_dib0700]
 [<ffffffff814327e5>] ? _raw_spin_lock_irqsave+0x25/0x90
 [<ffffffffa0579892>] dvb_usb_device_init+0x142/0x730 [dvb_usb]
 [<ffffffffa0607738>] dib0700_probe+0x68/0xf0 [dvb_usb_dib0700]
 [<ffffffffa0030194>] usb_probe_interface+0x114/0x1d0 [usbcore]
 [<ffffffff813156e6>] driver_probe_device+0x96/0x1a0
 [<ffffffff8131589b>] __driver_attach+0xab/0xb0
 [<ffffffff813157f0>] ? __driver_attach+0x0/0xb0
 [<ffffffff81314afc>] bus_for_each_dev+0x6c/0xa0
 [<ffffffff8131552e>] driver_attach+0x1e/0x20
 [<ffffffff81314de1>] bus_add_driver+0xe1/0x280
 [<ffffffff81315be4>] driver_register+0x74/0x130
 [<ffffffffa002fe2c>] usb_register_driver+0xdc/0x1a0 [usbcore]
 [<ffffffffa0557000>] ? dib0700_module_init+0x0/0x53 [dvb_usb_dib0700]
 [<ffffffffa0557037>] dib0700_module_init+0x37/0x53 [dvb_usb_dib0700]
 [<ffffffff810001dc>] do_one_initcall+0x3c/0x1d0
 [<ffffffff81094990>] sys_init_module+0xe0/0x260
 [<ffffffff810030db>] system_call_fastpath+0x16/0x1b
---[ end trace c5c0bb86c60e6f6b ]---
dvb-usb: found a 'Hauppauge Nova-TD Stick (52009)' in cold state, will
try to load a firmware
usb 2-3: firmware: requesting dvb-usb-dib0700-1.20.fw
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'



Zdenek
