Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab1DAOY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:24:27 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46221 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab1DAOYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:24:23 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Random crashes with v4l2_device_register_subdev
Date: Fri,  1 Apr 2011 11:24:16 -0300
Message-Id: <1301667857-5145-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently I received a report about crashes with mxb v4l driver
(https://bugs.launchpad.net/ubuntu/+source/linux/+bug/745213), there are
two slightly different reported crashes which I paste here:

1) BootDmesg.txt crash:

[   21.210232] general protection fault: 0000 [#1] SMP 
[   21.210292] last sysfs file: /sys/bus/i2c/drivers/tda9840/uevent
[   21.210357] CPU 0 
[   21.210379] Modules linked in: tda9840 tea6415c tea6420 snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec saa7115 mxb(+) snd_seq_midi snd_hwdep snd_rawmidi snd_pcm snd_seq_midi_event snd_seq snd_timer snd_seq_device saa7146_vv saa7146 snd videobuf_dma_sg videobuf_core v4l2_common videodev edac_core soundcore shpchp snd_page_alloc sp5100_tco edac_mce_amd xhci_hcd v4l2_compat_ioctl32 k10temp i2c_piix4 asus_atk0110 lp parport radeon usbhid ttm hid drm_kms_helper drm ahci sym53c8xx firewire_ohci e1000 scsi_transport_spi r8169 pata_atiixp firewire_core i2c_algo_bit libahci crc_itu_t pata_via
[   21.211030] 
[   21.211047] Pid: 812, comm: work_for_cpu Not tainted 2.6.38-7-generic #39-Ubuntu System manufacturer System Product Name/M4A88TD-V EVO/USB3
[   21.211187] RIP: 0010:[<ffffffffa029e745>]  [<ffffffffa029e745>] v4l2_device_register_subdev+0x95/0x170 [videodev]
[   21.211304] RSP: 0018:ffff880209de5d10  EFLAGS: 00010202
[   21.211362] RAX: 6564656572662e67 RBX: 00000000ffffffea RCX: ffff88020f38d0c8
[   21.211438] RDX: ffff88020ea90e40 RSI: ffff88020b5ad380 RDI: ffff88020eb72018
[   21.211514] RBP: ffff880209de5d40 R08: 0000000000000000 R09: dead000000200200
[   21.211590] R10: 0000000000000001 R11: 0000000000000001 R12: ffff88020b5ad380
[   21.211667] R13: ffff88020eb72018 R14: ffffffffa03820e0 R15: ffff88020eb72018
[   21.211743] FS:  00007f9933fa1720(0000) GS:ffff8800cfc00000(0000) knlGS:0000000000000000
[   21.211831] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   21.211892] CR2: 000000000048c000 CR3: 000000020fb3b000 CR4: 00000000000006f0
[   21.211968] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   21.212045] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   21.212121] Process work_for_cpu (pid: 812, threadinfo ffff880209de4000, task ffff88020d2716c0)
[   21.212214] Stack:
[   21.212236]  ffff880209de5d40 ffffffff8146fc05 ffff88020b097c00 ffff88020b5ad380
[   21.212318]  ffff88020eb72018 ffffffffa03820e0 ffff880209de5d70 ffffffffa028f6b5
[   21.212401]  ffff880209de5d80 0000000000000000 0000000000000042 ffff88020eb52010
[   21.212484] Call Trace:
[   21.212513]  [<ffffffff8146fc05>] ? i2c_new_device+0x135/0x1c0
[   21.212578]  [<ffffffffa028f6b5>] v4l2_i2c_new_subdev_board+0xf5/0x160 [v4l2_common]
[   21.212663]  [<ffffffffa028f795>] v4l2_i2c_new_subdev+0x75/0xa0 [v4l2_common]
[   21.215825]  [<ffffffffa0333714>] mxb_probe+0x124/0x260 [mxb]
[   21.219016]  [<ffffffffa03345a3>] mxb_attach+0x33/0x1f0 [mxb]
[   21.220214]  [<ffffffffa02e24c7>] saa7146_init_one+0x887/0x13c0 [saa7146]
[   21.220214]  [<ffffffff812fef4f>] local_pci_probe+0x5f/0xd0
[   21.220214]  [<ffffffff8107f890>] ? do_work_for_cpu+0x0/0x30
[   21.220214]  [<ffffffff8107f8a8>] do_work_for_cpu+0x18/0x30
[   21.220214]  [<ffffffff81086fe6>] kthread+0x96/0xa0
[   21.220214]  [<ffffffff8100ce24>] kernel_thread_helper+0x4/0x10
[   21.220214]  [<ffffffff81086f50>] ? kthread+0x0/0xa0
[   21.220214]  [<ffffffff8100ce20>] ? kernel_thread_helper+0x0/0x10
[   21.220214] Code: f6 74 19 41 83 3e 02 0f 84 eb 00 00 00 49 8b 86 68 02 00 00 65 ff 00 66 66 66 66 90 49 8b 44 24 30 4d 89 6c 24 20 48 85 c0 74 13 <48> 8b 00 48 85 c0 74 0b 4c 89 e7 ff d0 85 c0 89 c3 75 85 49 8b 
[   21.220214] RIP  [<ffffffffa029e745>] v4l2_device_register_subdev+0x95/0x170 [videodev]
[   21.220214]  RSP <ffff880209de5d10>
[   21.260394] ---[ end trace 5adfede4ff2f2907 ]---

2) Another crash, OopsText.txt:

043b
IP: [<ffffffffa014c745>] v4l2_device_register_subdev+0x95/0x170 [videodev]
PGD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/bus/i2c/drivers/tea6415c/uevent
CPU 0 
Modules linked in: tea6415c binfmt_misc tea6420 snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi saa7115 snd_seq_midi_event edac_core edac_mce_amd snd_seq mxb(+) saa7146_vv k10temp saa7146 videobuf_dma_sg videobuf_core asus_atk0110 v4l2_common snd_timer snd_seq_device videodev v4l2_compat_ioctl32 snd soundcore snd_page_alloc sp5100_tco i2c_piix4 xhci_hcd shpchp lp parport usbhid hid sym53c8xx ahci scsi_transport_spi e1000 libahci firewire_ohci r8169 pata_via pata_atiixp firewire_core crc_itu_t

Pid: 589, comm: work_for_cpu Not tainted 2.6.38-7-generic #39-Ubuntu System manufacturer System Product Name/M4A88TD-V EVO/USB3
RIP: 0010:[<ffffffffa014c745>]  [<ffffffffa014c745>] v4l2_device_register_subdev+0x95/0x170 [videodev]
RSP: 0018:ffff88020e8dfd10  EFLAGS: 00010202
RAX: 000000000000043b RBX: 00000000ffffffea RCX: ffff88020e889908
RDX: ffff88020aeeb240 RSI: ffff88020f5a8200 RDI: ffff88020ff61a18
RBP: ffff88020e8dfd40 R08: 0000000000000000 R09: 0000000000000002
R10: 0000000000000000 R11: 0000000000000004 R12: ffff88020f5a8200
R13: ffff88020ff61a18 R14: ffffffffa01f10e0 R15: ffff88020ff61a18
FS:  00007f0bb556e720(0000) GS:ffff8800cfc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000000043b CR3: 0000000001a03000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process work_for_cpu (pid: 589, threadinfo ffff88020e8de000, task ffff88020e8cdb00)
Stack:
 ffff88020e8dfd40 ffffffff8146fc05 ffff88020691b800 ffff88020f5a8200
 ffff88020ff61a18 ffffffffa01f10e0 ffff88020e8dfd70 ffffffffa01726b5
 ffff88020e8dfd80 0000000000000000 0000000000000043 ffff88020dac6010
Call Trace:
 [<ffffffff8146fc05>] ? i2c_new_device+0x135/0x1c0
 [<ffffffffa01726b5>] v4l2_i2c_new_subdev_board+0xf5/0x160 [v4l2_common]
 [<ffffffffa0172795>] v4l2_i2c_new_subdev+0x75/0xa0 [v4l2_common]
 [<ffffffffa01d06f3>] mxb_probe+0x103/0x260 [mxb]
 [<ffffffffa01d15a3>] mxb_attach+0x33/0x1f0 [mxb]
 [<ffffffffa01924c7>] saa7146_init_one+0x887/0x13c0 [saa7146]
 [<ffffffff812fef4f>] local_pci_probe+0x5f/0xd0
 [<ffffffff8107f890>] ? do_work_for_cpu+0x0/0x30
 [<ffffffff8107f8a8>] do_work_for_cpu+0x18/0x30
 [<ffffffff81086fe6>] kthread+0x96/0xa0
 [<ffffffff8100ce24>] kernel_thread_helper+0x4/0x10
 [<ffffffff81086f50>] ? kthread+0x0/0xa0
 [<ffffffff8100ce20>] ? kernel_thread_helper+0x0/0x10
Code: f6 74 19 41 83 3e 02 0f 84 eb 00 00 00 49 8b 86 68 02 00 00 65 ff 00 66 66 66 66 90 49 8b 44 24 30 4d 89 6c 24 20 48 85 c0 74 13 <48> 8b 00 48 85 c0 74 0b 4c 89 e7 ff d0 85 c0 89 c3 75 85 49 8b 
RIP  [<ffffffffa014c745>] v4l2_device_register_subdev+0x95/0x170 [videodev]
 RSP <ffff88020e8dfd10>
CR2: 000000000000043b
---[ end trace f6215d41cb05d370 ]---


The crashs are on same place, v4l2_device_register_subdev+0x95/0x170

Using the debug symbols of kernel above [1] and source [2], we can see:
(gdb) l *(v4l2_device_register_subdev+0x95)
0x6775 is in v4l2_device_register_subdev (/build/buildd/linux-2.6.38/drivers/media/video/v4l2-device.c:132).
127		/* Warn if we apparently re-register a subdev */
128		WARN_ON(sd->v4l2_dev != NULL);
129		if (!try_module_get(sd->owner))
130			return -ENODEV;
131		sd->v4l2_dev = v4l2_dev;
132		if (sd->internal_ops && sd->internal_ops->registered) {
133			err = sd->internal_ops->registered(sd);
134			if (err)
135				return err;
136		}

So the crash points out to be in dereference of sd->internal_ops, as if
it was sd it would likely crash earlier as sd is used previously in the
code.

And indeed if we look at decodecode of the oops, it matches
sd->internal_ops->registered dereference where the crash happens:

   0:	f6 74 19 41          	divb   0x41(%rcx,%rbx,1)
   4:	83 3e 02             	cmpl   $0x2,(%rsi)
   7:	0f 84 eb 00 00 00    	je     0xf8
   d:	49 8b 86 68 02 00 00 	mov    0x268(%r14),%rax
  14:	65 ff 00             	incl   %gs:(%rax)
  17:	66 66 66 66 90       	data32 data32 data32 xchg %ax,%ax
  1c:	49 8b 44 24 30       	mov    0x30(%r12),%rax
  21:	4d 89 6c 24 20       	mov    %r13,0x20(%r12)
  26:	48 85 c0             	test   %rax,%rax
  29:	74 13                	je     0x3e
  2b:*	48 8b 00             	mov    (%rax),%rax     <-- trapping instruction
  2e:	48 85 c0             	test   %rax,%rax
  31:	74 0b                	je     0x3e
  33:	4c 89 e7             	mov    %r12,%rdi
  36:	ff d0                	callq  *%rax
  38:	85 c0                	test   %eax,%eax
  3a:	89 c3                	mov    %eax,%ebx
  3c:	75 85                	jne    0xffffffffffffffc3
  3e:	49                   	rex.WB
  3f:	8b                   	.byte 0x8b

(gdb) p &((struct v4l2_subdev *)0)->internal_ops
$1 = (const struct v4l2_subdev_internal_ops **) 0x30
(gdb) p &((struct v4l2_subdev_internal_ops *)0)->registered
$2 = (int (**)(struct v4l2_subdev *)) 0x0

So it dereferences and tests successfuly sd->internal_ops:
mov 0x30(%r12),%rax
...
test   %rax,%rax
and when it tries to dereference sd->internal_ops->registered it
crashes:
mov    (%rax),%rax

But looking at oopses above, look that RAX in each case has a different
value, in first it tries to dereference 0x6564656572662e67, in the other
it is 0x43b instead, so random values in sd->internal_ops

Now wonder why internal_ops got random values. Well, looking back in the
traces, specially at mxb_probe where each crash happens, we can see:

* for the first oops:
(gdb) l *(mxb_probe+0x124)
0x744 is in mxb_probe (/build/buildd/linux-2.6.38/drivers/media/video/mxb.c:197).
192				"tea6420", I2C_TEA6420_2, NULL);
193		mxb->tea6415c = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
194				"tea6415c", I2C_TEA6415C, NULL);
195		mxb->tda9840 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
196				"tda9840", I2C_TDA9840, NULL);
197		mxb->tuner = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
198				"tuner", I2C_TUNER, NULL);
199	
200		/* check if all devices are present */
201		if (!mxb->tea6420_1 || !mxb->tea6420_2 || !mxb->tea6415c ||

* for the second oops:
(gdb) l *(mxb_probe+0x103)
0x723 is in mxb_probe (/build/buildd/linux-2.6.38/drivers/media/video/mxb.c:195).
190				"tea6420", I2C_TEA6420_1, NULL);
191		mxb->tea6420_2 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
192				"tea6420", I2C_TEA6420_2, NULL);
193		mxb->tea6415c = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
194				"tea6415c", I2C_TEA6415C, NULL);
195		mxb->tda9840 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
196				"tda9840", I2C_TDA9840, NULL);
197		mxb->tuner = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
198				"tuner", I2C_TUNER, NULL);
199

Hmm the crash seems to be at random, in the cases above probably
when getting tea6415c/tda9840.

Looking at the code then, notice how sd (struct v4l2_subdev *) is
allocated, for example in tda9840_probe we have
sd = kmalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);

So it's not kzalloc, the same holds for tea6415c, its probe function
uses kmalloc as well.

And this is why sd->internal_ops should be getting a random value. I
don't see anywhere in current code where we clear sd->internal_ops on
initialization, and as many of these tuners etc. allocate using just
kmalloc, we get random data in sd.

A fix could be to drivers allocating/zeroing sd using kzalloc/memset
before use.

But seems current v4l code assumes drivers can use kmalloc, and
initialization is done in v4l2_subdev_init, so in a reply to this I
propose a patch to initialize sd->internal_ops to null in
v4l2_subdev_init, which should fix these random crashes.

[1] http://ddebs.ubuntu.com/pool/main/l/linux/linux-image-2.6.38-7-generic-dbgsym_2.6.38-7.39_amd64.ddeb
[2] git://kernel.ubuntu.com/ubuntu/ubuntu-natty.git
    (pointing to Ubuntu-2.6.38-7.39 tag checkout)

-- 
[]'s
Herton
