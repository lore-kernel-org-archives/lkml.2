Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab0ESLPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:15:55 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:25649 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269Ab0ESLPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:15:53 -0400
From: "Buehl, Reiner" <reiner.buehl@hp.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 19 May 2010 11:13:58 +0000
Subject: PROBLEM: ext3 filesystem corruption on md RAID1 device
Thread-Topic: PROBLEM: ext3 filesystem corruption on md RAID1 device
Thread-Index: Acr3RGDLXN1mODJeStaDeyU31QNq8A==
Message-ID: <BA8A2107B0FD8A48AEB0405BDC36CE4F3F48B1D711@GVW1115EXC.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I keep getting ext3 filesystem corruptions for no obvious reasons:

EXT3-fs error (device md1): htree_dirblock_to_tree: bad entry in directory #17269110: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0

This forces an automatic fsck at the next reboot that fails. The manual
fsck.ext3 -y /dev/md1 takes a long time but manages to get a clean FS again. After the reboot, it takes just a few minutes until the first of these messages appear again.

The two disks used in the RAID1 md device are both Seagate ST31000528AS that show no errors in long and short SMART test and Seatools. Memtest shows no memory problems. Two other RAID1 systems connected to the same Intel Ibex Peak 6 port SATA AHCI Controller (rev 06) show no such problems. A RAID5 with 4 Seagate ST3750640AS on a Promise PDC40718 (SATA 300 TX4) also works without problems in the same system. 

I saw that sata_sil.c has a blacklist that includes mainly Seagate drives but do not know if this is related to my problem since I my system uses an Intel SATA controller.

Here is the output of sh /usr/lib/linux-kbuild-2.6.32/scripts/ver_linux:
---------
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux bilbo.lan.buehl.net 2.6.32-bpo.4-686 #1 SMP Mon Apr 12 16:20:13 UTC 2010 i686 GNU/Linux
 
Gnu C                  4.3.2
Gnu make               3.81
binutils               2.18.0.20080103
util-linux             2.13.1.1
mount                  2.13.1.1
module-init-tools      3.4
e2fsprogs              1.41.3
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               6.10
udev                   125
Modules Loaded         dvb_ttpci dvb_core saa7146_vv videodev v4l1_compat saa7146 videobuf_dma_sg videobuf_core ttpci_eeprom ppdev parport_pc lp parport autofs4 acpi_cpufreq cpufreq_powersave cpufreq_stats cpufreq_conservative cpufreq_userspace nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc snd_hda_codec_realtek snd_hda_intel i2c_i801 snd_hda_codec snd_hwdep snd_pcm ati_remote pcspkr snd_seq snd_timer snd_seq_device snd evdev soundcore snd_page_alloc button processor ext3 mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx it8213 ide_core usbhid hid usb_storage ata_generic sata_promise ahci r8169 mii libata ehci_hcd uhci_hcd usbcore nls_base thermal fan thermal_sys radeonfb fb_ddc i2c_algo_bit i2c_core jbd sd_mod scsi_mod crc_t10dif raid1 md_mod
---------

Best regards,
Reiner.

