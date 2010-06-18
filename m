Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485Ab0FROaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 10:30:30 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50894 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933443Ab0FROa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 10:30:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=JrrRQSHeU9lmz5+bnsOl3RqB/Zy8zAP/0/G+K3n9loquCKZ5QkigxkG8WCZLzpYXfH
         fBBwDeS+22zgkEiuUuGyAKyS3ir1Qm9A9fuhVUJhXEPrymWFaEuixCGMyzixQyxISMHX
         k7Eljtfva3BRfUoKi5eZsDZvMjexUz9KrbIYQ=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: bug-tar@gnu.org, linux-kernel@vger.kernel.org
Subject: RE: 2.6.35-rc3 BUG: unable to handle kernel paging request at 0000000000004008
Date: Fri, 18 Jun 2010 10:30:23 -0400
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc3; KDE/4.3.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006181030.23850.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings folks;

I finally got amanda running on an mdv-22010-x64 system last night & left it 
running when I went to bed as it had about 64Gb to backup.

Up just after 6ish, the system wasn't very responsive & while looking 
around, both kmail and x eventually hung.  I could see by the drive led that 
amanda was still working so I went back to bed.  But I'd found a couple of 
BUG entries in messages so here they are:

Jun 18 02:28:01 coyote klogd: [284057.476845] BUG: unable to handle kernel paging request at 0000000000004008                                       
Jun 18 02:28:01 coyote klogd: [284057.476852] IP: [<ffffffff810b3661>] find_get_page+0x51/0xe0                                                      
Jun 18 02:28:01 coyote klogd: [284057.476859] PGD dfde9067 PUD dfc73067 PMD 0                                                                       
Jun 18 02:28:01 coyote klogd: [284057.476863] Oops: 0000 [#1] PREEMPT SMP                                                                           
Jun 18 02:28:01 coyote klogd: [284057.476866] last sysfs file: /sys/devices/pci0000:00/0000:00:0f.0/0000:03:00.1/local_cpus                         
Jun 18 02:28:01 coyote klogd: [284057.476869] CPU 3                                                                                                 
Jun 18 02:28:01 coyote klogd: [284057.476871] Modules linked in: fuse rfcomm l2cap crc16 bluetooth radeon ttm drm_kms_helper drm agpgart nfsd exportfs nfs lockd fscache 
nfs_acl auth_rpcgss sunrpc af_packet ipv6 binfmt_misc loop or51132 cx88_dvb videobuf_dvb dvb_core rc_hauppauge_new tuner_simple tuner_types tda9887 tda8290 tuner 
snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus ir_sony_decoder snd_util_mem snd_hwdep ir_jvc_decoder snd_seq_dummy ir_rc6_decoder snd_seq_oss cx8802 
cx8800 snd_seq_midi_event ir_rc5_decoder snd_seq cx88xx snd_seq_device v4l2_common videodev snd_pcm_oss v4l1_compat i2c_algo_bit v4l2_compat_ioctl32 
ir_nec_decoder ir_common ir_core tveeprom i2c_nforce2 snd_pcm i2c_core usblp snd_timer snd_page_alloc snd_mixer_oss snd ftdi_sio usbserial usb_storage firewire_ohci 
firewire_core soundcore evdev forcedeth asus_atk0110 floppy fan k10temp thermal processor serio_raw pcspkr button sr_mod crc_itu_t videobuf_dma_sg videobuf_core 
btcx_risc hid_logitech sg pata_amd ata_generic pata_acpi sata_nv sd_m           
Jun 18 02:28:01 coyote klogd: d ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbhid hid usbcore [last unloaded: scsi_wait_scan]                              
Jun 18 02:28:01 coyote klogd: [284057.476932]                                                                                                       
Jun 18 02:28:01 coyote klogd: [284057.476936] Pid: 14517, comm: tar Not tainted 2.6.35-rc3 #2 M2N-SLI DELUXE/System Product Name                    
Jun 18 02:28:01 coyote klogd: [284057.476938] RIP: 0010:[<ffffffff810b3661>]  [<ffffffff810b3661>] find_get_page+0x51/0xe0                          
Jun 18 02:28:01 coyote klogd: [284057.476943] RSP: 0018:ffff88001c94bcd8  EFLAGS: 00010203                                                          
Jun 18 02:28:01 coyote klogd: [284057.476945] RAX: 0000000000003fff RBX: ffff8800d3617608 RCX: ffff8800dd693d58                                     
Jun 18 02:28:01 coyote klogd: [284057.476948] RDX: 0000000000000000 RSI: 000000000001bd40 RDI: 0000000000004000                                     
Jun 18 02:28:01 coyote klogd: [284057.476950] RBP: ffff88001c94bcf8 R08: 00000000000033ff R09: ffffea000238a2f0                                     
Jun 18 02:28:01 coyote klogd: [284057.476951] R10: ffff88001c94bfd8 R11: 0000000000000001 R12: 000000000001bd40                                     
Jun 18 02:28:01 coyote klogd: [284057.476953] R13: 0000000000004000 R14: ffff88001c9e0840 R15: ffff8800d36174e8                                     
Jun 18 02:28:01 coyote klogd: [284057.476956] FS:  00007f13b8d616f0(0000) GS:ffff880001980000(0000) knlGS:00000000f41feb70                          
Jun 18 02:28:01 coyote klogd: [284057.476958] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                                                     
Jun 18 02:28:01 coyote klogd: [284057.476960] CR2: 0000000000004008 CR3: 00000000bcb65000 CR4: 00000000000006e0                                     
Jun 18 02:28:01 coyote klogd: [284057.476962] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000                                     
Jun 18 02:28:01 coyote klogd: [284057.476964] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400                                     
Jun 18 02:28:01 coyote klogd: [284057.476966] Process tar (pid: 14517, threadinfo ffff88001c94a000, task ffff8800096178c0)                          
Jun 18 02:28:01 coyote klogd: [284057.476968] Stack:                                                                                                
Jun 18 02:28:01 coyote klogd: [284057.476969]  ffffea000238a2e8 ffffea000238a2e8 ffff8800d3617600 000000000001bd40                                  
Jun 18 02:28:01 coyote klogd: [284057.476972] <0> ffff88001c94bdd8 ffffffff810b52b8 ffffea00020866e8 000000000001bd40                               
Jun 18 02:28:01 coyote klogd: [284057.476975] <0> 0000000000001000 ffff88001c94beb8 ffff88001c94be40 0000000000000000                               
Jun 18 02:28:01 coyote klogd: [284057.476979] Call Trace:                                                                                           
Jun 18 02:28:01 coyote klogd: [284057.476984]  [<ffffffff810b52b8>] generic_file_aio_read+0x238/0x6e0                                               
Jun 18 02:28:01 coyote klogd: [284057.476988]  [<ffffffff810f9791>] ? pipe_write+0x1/0x5b0                                                          
Jun 18 02:28:01 coyote klogd: [284057.476991]  [<ffffffff810f078a>] do_sync_read+0xda/0x120                                                         
Jun 18 02:28:01 coyote klogd: [284057.476995]  [<ffffffff810039ae>] ? call_function_single_interrupt+0xe/0x20                                       
Jun 18 02:28:01 coyote klogd: [284057.476999]  [<ffffffff8112686c>] ? inotify_dentry_parent_queue_event+0xc/0xe0                                    
Jun 18 02:28:01 coyote klogd: [284057.477003]  [<ffffffff8133dcce>] ? common_interrupt+0xe/0x13                                                     
Jun 18 02:28:01 coyote klogd: [284057.477006]  [<ffffffff810f1395>] vfs_read+0xb5/0x180                                                             
Jun 18 02:28:01 coyote klogd: [284057.477009]  [<ffffffff810f1541>] sys_read+0x51/0x80                                                              
Jun 18 02:28:01 coyote klogd: [284057.477012]  [<ffffffff81003f4e>] ? do_device_not_available+0xe/0x10                                              
Jun 18 02:28:01 coyote klogd: [284057.477014]  [<ffffffff81002f2b>] system_call_fastpath+0x16/0x1b                                                  
Jun 18 02:28:01 coyote klogd: [284057.477016] Code: 5f 08 4c 89 e6 48 89 df e8 fd a5 0e 00 48 85 c0 48 89 c1 74 65 48 8b 38 40 f6 c7 01 75 e4 48 8d 47 ff 49 89 fd 48 83 
f8 fd 77 d7 <8b> 57 08 4c 8d 4f 08 85 d2 74 cc 44 8d 42 01 89 d0 f0 44 0f b1                                                   
Jun 18 02:28:01 coyote klogd: [284057.477044] RIP  [<ffffffff810b3661>] find_get_page+0x51/0xe0                                                     
Jun 18 02:28:01 coyote klogd: [284057.477051]  RSP <ffff88001c94bcd8>                                                                               
Jun 18 02:28:01 coyote klogd: [284057.477052] CR2: 0000000000004008                                                                                 
Jun 18 02:28:01 coyote klogd: [284057.477055] ---[ end trace 4fe343b5d1e3e778 ]---                                                                  
Jun 18 02:28:01 coyote klogd: [284057.477058] note: tar[14517] exited with preempt_count 1                                                          

Jun 18 02:34:46 coyote klogd: [284462.233776] BUG: unable to handle kernel paging request at 0000000000004008                                       
Jun 18 02:34:46 coyote klogd: [284462.233784] IP: [<ffffffff810b3557>] find_get_pages+0x77/0x130                                                    
Jun 18 02:34:46 coyote klogd: [284462.233793] PGD 10021c067 PUD 11ec0b067 PMD 0                                                                     
Jun 18 02:34:46 coyote klogd: [284462.233797] Oops: 0000 [#2] PREEMPT SMP                                                                           
Jun 18 02:34:46 coyote klogd: [284462.233801] last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/ATK0110:00/hwmon/hwmon1/temp2_label  
Jun 18 02:34:46 coyote klogd: [284462.233805] CPU 2                                                                                                 
Jun 18 02:34:46 coyote klogd: [284462.233807] Modules linked in: fuse rfcomm l2cap crc16 bluetooth radeon ttm drm_kms_helper drm agpgart nfsd exportfs nfs lockd fscache 
nfs_acl auth_rpcgss sunrpc af_packet ipv6 binfmt_misc loop or51132 cx88_dvb videobuf_dvb dvb_core rc_hauppauge_new tuner_simple tuner_types tda9887 tda8290 tuner 
snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus ir_sony_decoder snd_util_mem snd_hwdep ir_jvc_decoder snd_seq_dummy ir_rc6_decoder snd_seq_oss cx8802 
cx8800 snd_seq_midi_event ir_rc5_decoder snd_seq cx88xx snd_seq_device v4l2_common videodev snd_pcm_oss v4l1_compat i2c_algo_bit v4l2_compat_ioctl32 
ir_nec_decoder ir_common ir_core tveeprom i2c_nforce2 snd_pcm i2c_core usblp snd_timer snd_page_alloc snd_mixer_oss snd ftdi_sio usbserial usb_storage firewire_ohci 
firewire_core soundcore evdev forcedeth asus_atk0110 floppy fan k10temp thermal processor serio_raw pcspkr button sr_mod crc_itu_t videobuf_dma_sg videobuf_core 
btcx_risc hid_logitech sg pata_amd ata_generic pata_acpi sata_nv sd_m           
Jun 18 02:34:46 coyote klogd: d ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbhid hid usbcore [last unloaded: scsi_wait_scan]                              
Jun 18 02:34:46 coyote klogd: [284462.233867]                                                                                                       
Jun 18 02:34:46 coyote klogd: [284462.233871] Pid: 33, comm: kswapd0 Tainted: G      D     2.6.35-rc3 #2 M2N-SLI DELUXE/System Product Name         
Jun 18 02:34:46 coyote klogd: [284462.233874] RIP: 0010:[<ffffffff810b3557>]  [<ffffffff810b3557>] find_get_pages+0x77/0x130                        
Jun 18 02:34:46 coyote klogd: [284462.233879] RSP: 0018:ffff88011fee5b60  EFLAGS: 00010213                                                          
Jun 18 02:34:46 coyote klogd: [284462.233881] RAX: ffff8800dd693d58 RBX: ffff88011fee5c10 RCX: 000000000000000e                                     
Jun 18 02:34:46 coyote klogd: [284462.233883] RDX: 0000000000000005 RSI: 0000000000000001 RDI: 0000000000004000                                     
Jun 18 02:34:46 coyote klogd: [284462.233885] RBP: ffff88011fee5bb0 R08: 0000000000000001 R09: 0000000000000002                                     
Jun 18 02:34:46 coyote klogd: [284462.233887] R10: ffffea000238a2f0 R11: ffff8800dd693d98 R12: 000000000000000e                                     
Jun 18 02:34:46 coyote klogd: [284462.233889] R13: 000000000001bd3b R14: ffff88011fee5c38 R15: 0000000000000005                                     
Jun 18 02:34:46 coyote klogd: [284462.233892] FS:  00007f21027b86f0(0000) GS:ffff880001900000(0000) knlGS:00000000f2dffb70                          
Jun 18 02:34:46 coyote klogd: [284462.233894] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b                                                     
Jun 18 02:34:46 coyote klogd: [284462.233896] CR2: 0000000000004008 CR3: 00000001000bd000 CR4: 00000000000006e0                                     
Jun 18 02:34:46 coyote klogd: [284462.233897] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000                                     
Jun 18 02:34:46 coyote klogd: [284462.233899] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400                                     
Jun 18 02:34:46 coyote klogd: [284462.233902] Process kswapd0 (pid: 33, threadinfo ffff88011fee4000, task ffff88011fd44ac0)                         
Jun 18 02:34:46 coyote klogd: [284462.233903] Stack:                                                                                                
Jun 18 02:34:46 coyote klogd: [284462.233905]  ffffea0002f1e260 ffffea0002f1e298 ffffea0002f1e2d0 ffff8800d3617608                                  
Jun 18 02:34:46 coyote klogd: [284462.233908] <0> ffffea0002f1e308 ffff88011fee5c00 000000000001ba42 ffffffffffffffff                               
Jun 18 02:34:46 coyote klogd: [284462.233911] <0> ffff88011fee5c00 ffff8800d3617600 ffff88011fee5bd0 ffffffff810bcb42                               
Jun 18 02:34:46 coyote klogd: [284462.233915] Call Trace:                                                                                           
Jun 18 02:34:46 coyote klogd: [284462.233920]  [<ffffffff810bcb42>] pagevec_lookup+0x22/0x30                                                        
Jun 18 02:34:46 coyote klogd: [284462.233924]  [<ffffffff810bdcbb>] invalidate_mapping_pages+0x6b/0x140                                             
Jun 18 02:34:46 coyote klogd: [284462.233929]  [<ffffffff81107950>] shrink_icache_memory+0x2b0/0x2e0                                                
Jun 18 02:34:46 coyote klogd: [284462.233932]  [<ffffffff810c0b28>] shrink_slab+0x118/0x180                                                         
Jun 18 02:34:46 coyote klogd: [284462.233935]  [<ffffffff810c0fd2>] balance_pgdat+0x442/0x700                                                       
Jun 18 02:34:46 coyote klogd: [284462.233938]  [<ffffffff810c133a>] kswapd+0xaa/0x1a0                                                               
Jun 18 02:34:46 coyote klogd: [284462.233942]  [<ffffffff81063cf0>] ? autoremove_wake_function+0x0/0x40                                             
Jun 18 02:34:46 coyote klogd: [284462.233945]  [<ffffffff810c1290>] ? kswapd+0x0/0x1a0                                                              
Jun 18 02:34:46 coyote klogd: [284462.233948]  [<ffffffff81063756>] kthread+0x96/0xa0                                                               
Jun 18 02:34:46 coyote klogd: [284462.233952]  [<ffffffff81003c54>] kernel_thread_helper+0x4/0x10                                                   
Jun 18 02:34:46 coyote klogd: [284462.233954]  [<ffffffff810636c0>] ? kthread+0x0/0xa0                                                              
Jun 18 02:34:46 coyote klogd: [284462.233957]  [<ffffffff81003c50>] ? kernel_thread_helper+0x0/0x10                                                 
Jun 18 02:34:46 coyote klogd: [284462.233959] Code: 0f 84 aa 00 00 00 49 89 de 45 31 ff 31 d2 66 0f 1f 44 00 00 49 8b 06 48 8b 38 40 f6 c7 01 75 ca 48 85 ff 74 36 48 83 ff 
ff 74 bf <8b> 77 08 4c 8d 57 08 85 f6 74 e1 44 8d 4e 01 89 f0 f0 44 0f b1                                                   
Jun 18 02:34:46 coyote klogd: [284462.233982] RIP  [<ffffffff810b3557>] find_get_pages+0x77/0x130                                                   
Jun 18 02:34:46 coyote klogd: [284462.233986]  RSP <ffff88011fee5b60>                                                                               
Jun 18 02:34:46 coyote klogd: [284462.233987] CR2: 0000000000004008                                                                                 
Jun 18 02:34:46 coyote klogd: [284462.233996] ---[ end trace 4fe343b5d1e3e779 ]---                                                                  
Jun 18 02:34:46 coyote klogd: [284462.233999] note: kswapd0[33] exited with preempt_count 1

No idea if this is a kernel bug, or a tar triggered bug.
Kernel is 2.6.35-rc3, tar is 1.22, system is Mandriva-2010-x86_64.
AMD Phenom, 4Gb of ram.

Amanda did finish according to the printed report.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I am not afraid of tomorrow, for I have seen yesterday and I love today.
		-- William Allen White
