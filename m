Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab1DOHnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 03:43:07 -0400
Received: from swm.pp.se ([212.247.200.143]:43448 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754672Ab1DOHnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 03:43:05 -0400
Date: Fri, 15 Apr 2011 09:43:02 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: Mark Lord <kernel@teksavvy.com>
cc: Bruce Stenning <b.stenning@indigovision.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
In-Reply-To: <4DA7BC4B.9090104@teksavvy.com>
Message-ID: <alpine.DEB.2.00.1104150941220.14027@uplift.swm.pp.se>
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com> <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com> <4D9CD275.9000002@teksavvy.com> <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com>
 <alpine.DEB.2.00.1104150510181.14027@uplift.swm.pp.se> <4DA7BC4B.9090104@teksavvy.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011, Mark Lord wrote:

> I would like to see the output, next time you can get it.

Apr 14 18:39:54 host kernel: [  137.276051] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Apr 14 18:39:54 host kernel: [  137.284557] ------------[ cut here ]------------
Apr 14 18:39:54 host kernel: [  137.284626] WARNING: at /build/buildd-linux-2.6_2.6.32-31-amd64-vrfdM4/linux-2.6-2.6.32/debian/build/source_amd64_none/drivers/ata/libata-sff.c:1208 ata_sff_hsm_move+0x47/0x642 [libata]()
Apr 14 18:39:54 host kernel: [  137.284733] Hardware name: P5E WS Pro
Apr 14 18:39:54 host kernel: [  137.284797] Modules linked in: ext2 loop snd_pcm snd_timer snd soundcore snd_page_alloc i2c_i801 i2c_core evdev pcspkr asus_atk0110 x38_edac shpchp pci_hotplug edac_core button processor ext3 jbd mbcache sha256_generic aes_x86_64 aes_generic cbc dm_crypt dm_mod usbhid hid sd_mod crc_t10dif sata_mv uhci_hcd sata_sil24 ahci mpt2sas libata sky2 scsi_transport_sas thermal ehci_hcd thermal_sys scsi_mod usbcore nls_base [last unloaded: scsi_wait_scan]
Apr 14 18:39:54 host kernel: [  137.286426] Pid: 240, comm: ata/1 Not tainted 2.6.32-5-amd64 #1
Apr 14 18:39:54 host kernel: [  137.286482] Call Trace:
Apr 14 18:39:54 host kernel: [  137.286536]  [<ffffffffa00b1438>] ? ata_sff_hsm_move+0x47/0x642 [libata]
Apr 14 18:39:54 host kernel: [  137.286597]  [<ffffffffa00b1438>] ? ata_sff_hsm_move+0x47/0x642 [libata]
Apr 14 18:39:54 host kernel: [  137.286658]  [<ffffffff8104df00>] ? warn_slowpath_common+0x77/0xa3
Apr 14 18:39:54 host kernel: [  137.286718]  [<ffffffffa00b1438>] ? ata_sff_hsm_move+0x47/0x642 [libata]
Apr 14 18:39:54 host kernel: [  137.286780]  [<ffffffffa00b1d87>] ? ata_pio_task+0x9a/0xa6 [libata]
Apr 14 18:39:54 host kernel: [  137.286838]  [<ffffffff8106186b>] ? worker_thread+0x188/0x21d
Apr 14 18:39:54 host kernel: [  137.286897]  [<ffffffffa00b1ced>] ? ata_pio_task+0x0/0xa6 [libata]
Apr 14 18:39:54 host kernel: [  137.286955]  [<ffffffff81064e96>] ? autoremove_wake_function+0x0/0x2e
Apr 14 18:39:54 host kernel: [  137.287012]  [<ffffffff810616e3>] ? worker_thread+0x0/0x21d
Apr 14 18:39:54 host kernel: [  137.287068]  [<ffffffff81064bc9>] ? kthread+0x79/0x81
Apr 14 18:39:54 host kernel: [  137.287124]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
Apr 14 18:39:54 host kernel: [  137.292927]  [<ffffffff81064b50>] ? kthread+0x0/0x81
Apr 14 18:39:54 host kernel: [  137.292984]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
Apr 14 18:39:54 host kernel: [  137.293041] ---[ end trace 0ce5491cb936fb17 ]---
Apr 14 18:39:54 host kernel: [  137.306180] ata9.00: failed to IDENTIFY (I/O error, err_mask=0x2)

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
