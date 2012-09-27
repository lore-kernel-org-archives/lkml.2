Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab2I0GQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:16:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:30306 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512Ab2I0GQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:16:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,493,1344236400"; 
   d="scan'208";a="197776749"
Message-ID: <1348726597.10877.279.camel@rui.sh.intel.com>
Subject: RE: inux-next: Tree for Sept 26 (not bootable on AMD64:
 thermal|acpi|drm/i915|pci related?)
From: Zhang Rui <rui.zhang@intel.com>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: Hugh Dickins <hughd@google.com>, Sedat Dilek <sedat.dilek@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 27 Sep 2012 14:16:37 +0800
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB591D3CF5@BGSMSX101.gar.corp.intel.com>
References: <CA+icZUWF92LaJ6pOMUPh6M-MVhF1GikJfyb9_1xXdNTxGLahXw@mail.gmail.com>
	 <alpine.LSU.2.00.1209261241190.2175@eggly.anvils>
	 <1348726082.10877.276.camel@rui.sh.intel.com>
	 <4D68720C2E767A4AA6A8796D42C8EB591D3CF5@BGSMSX101.gar.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 四, 2012-09-27 at 00:11 -0600, R, Durgadoss wrote:
> Hi Rui,
> 
> 
> > -----Original Message-----
> > From: Zhang, Rui
> > Sent: Thursday, September 27, 2012 11:38 AM
> > To: Hugh Dickins
> > Cc: Sedat Dilek; Stephen Rothwell; Andrew Morton; Dan Carpenter; R,
> > Durgadoss; linux-next@vger.kernel.org; linux-kernel@vger.kernel.org;
> > Rafael J. Wysocki; Dave Airlie; Daniel Vetter; Linux ACPI; linux-
> > pci@vger.kernel.org; DRI; Bjorn Helgaas
> > Subject: Re: inux-next: Tree for Sept 26 (not bootable on AMD64:
> > thermal|acpi|drm/i915|pci related?)
> > 
> > Hi, hugh,
> > 
> > On 三, 2012-09-26 at 12:51 -0700, Hugh Dickins wrote:
> > > On Wed, 26 Sep 2012, Sedat Dilek wrote:
> > > >
> > > > on my Ubuntu/precise AMD64 today's Linux-Next runs into the following
> > > > call-trace (machine freezes):
> > > >
> > > >  Sep 26 19:22:58 fambox kernel: [   11.124739] BUG: unable to handle
> > > > kernel NULL pointer dereference at 0000000000000018
> > > > Sep 26 19:22:58 fambox kernel: [   11.124806] IP: [<ffffffff814bb058>]
> > > > thermal_cooling_device_register+0x2c8/0x3d0
> > > > Sep 26 19:22:58 fambox kernel: [   11.124869] PGD 0
> > > > Sep 26 19:22:58 fambox kernel: [   11.124895] Oops: 0000 [#1] SMP
> > > > Sep 26 19:22:58 fambox kernel: [   11.124919] Modules linked in:
> > > > coretemp kvm_intel kvm snd_hda_intel(+) arc4 snd_hda_codec iwldvm
> > > > snd_hwdep ghash_clmulni_intel snd_pcm aesni_intel uvcvideo mac80211
> > > > aes_x86_64 snd_page_alloc ablk_helper i915(+) snd_seq_midi cryptd
> > > > videobuf2_vmalloc snd_seq_midi_event xts videobuf2_memops lrw
> > > > snd_rawmidi videobuf2_core joydev gf128mul videodev snd_seq
> > > > snd_seq_device hid_generic snd_timer drm_kms_helper iwlwifi drm snd
> > > > psmouse i2c_algo_bit soundcore btusb microcode serio_raw
> > > > samsung_laptop wmi cfg80211 bluetooth mei mac_hid video lpc_ich lp
> > > > parport ext4 jbd2 usbhid hid r8169
> > > > Sep 26 19:22:58 fambox kernel: [   11.125319] CPU 2
> > > > Sep 26 19:22:58 fambox kernel: [   11.125332] Pid: 579, comm: modprobe
> > > > Not tainted 3.6.0-rc7-next20120926-2-iniza-generic #1 SAMSUNG
> > > > ELECTRONICS CO., LTD.
> > 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH
> > > > Sep 26 19:22:58 fambox kernel: [   11.125401] RIP:
> > > > 0010:[<ffffffff814bb058>]  [<ffffffff814bb058>]
> > > > thermal_cooling_device_register+0x2c8/0x3d0
> > > > Sep 26 19:22:58 fambox kernel: [   11.125450] RSP:
> > > > 0018:ffff88010f23d838  EFLAGS: 00010246
> > > > Sep 26 19:22:58 fambox kernel: [   11.125475] RAX: 0000000000000000
> > > > RBX: ffff88010bfd4c00 RCX: 0000000000000001
> > > > Sep 26 19:22:58 fambox kernel: [   11.125507] RDX: 0000000000000000
> > > > RSI: 0000000000000282 RDI: 0000000000000282
> > > > Sep 26 19:22:58 fambox kernel: [   11.125539] RBP: ffff88010f23d878
> > > > R08: 0000000000000000 R09: 0000000000000001
> > > > Sep 26 19:22:58 fambox kernel: [   11.125570] R10: ffff8801054fc460
> > > > R11: 0000000000000000 R12: ffff88010bfd4c04
> > > > Sep 26 19:22:58 fambox kernel: [   11.125602] R13: ffff88011a73e000
> > > > R14: 0000000000000000 R15: 0000000000000000
> > > > Sep 26 19:22:58 fambox kernel: [   11.125634] FS:
> > > > 00007f6b8da29700(0000) GS:ffff88011fa80000(0000)
> > > > knlGS:0000000000000000
> > > > Sep 26 19:22:58 fambox kernel: [   11.125670] CS:  0010 DS: 0000 ES:
> > > > 0000 CR0: 0000000080050033
> > > > Sep 26 19:22:58 fambox kernel: [   11.125697] CR2: 0000000000000018
> > > > CR3: 0000000110185000 CR4: 00000000000407e0
> > > > Sep 26 19:22:58 fambox kernel: [   11.125729] DR0: 0000000000000000
> > > > DR1: 0000000000000000 DR2: 0000000000000000
> > > > Sep 26 19:22:58 fambox kernel: [   11.125761] DR3: 0000000000000000
> > > > DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > > Sep 26 19:22:58 fambox kernel: [   11.125793] Process modprobe (pid:
> > > > 579, threadinfo ffff88010f23c000, task ffff880116648000)
> > > > Sep 26 19:22:58 fambox kernel: [   11.127133] Stack:
> > > > Sep 26 19:22:58 fambox kernel: [   11.128461]  ffff88011a5d9098
> > > > ffff88010d74c300 ffff88010f23d878 ffff880110b06480
> > > > Sep 26 19:22:58 fambox kernel: [   11.129755]  ffff88010bfd1000
> > > > ffff88011a5d9098 ffff88010d74c300 ffff88011a625000
> > > > Sep 26 19:22:58 fambox kernel: [   11.130943]  ffff88010f23d958
> > > > ffffffffa00e5868 0000000000000000 ffffffff811fa033
> > > > Sep 26 19:22:58 fambox kernel: [   11.132749] Call Trace:
> > > > Sep 26 19:22:58 fambox kernel: [   11.133939]  [<ffffffffa00e5868>]
> > > > acpi_video_bus_add+0x9ba/0xce6 [video]
> > > > Sep 26 19:22:58 fambox kernel: [   11.135130]  [<ffffffff811fa033>] ?
> > > > sysfs_addrm_finish+0x33/0xc0
> > > > Sep 26 19:22:58 fambox kernel: [   11.136313]  [<ffffffff813454cc>]
> > > > acpi_device_probe+0x4e/0x11c
> > > > Sep 26 19:22:58 fambox kernel: [   11.137482]  [<ffffffff813d472b>]
> > > > driver_probe_device+0x7b/0x240
> > > > Sep 26 19:22:58 fambox kernel: [   11.138642]  [<ffffffff813d499b>]
> > > > __driver_attach+0xab/0xb0
> > > > Sep 26 19:22:58 fambox kernel: [   11.139798]  [<ffffffff813d48f0>] ?
> > > > driver_probe_device+0x240/0x240
> > > > Sep 26 19:22:58 fambox kernel: [   11.140981]  [<ffffffff813d2b46>]
> > > > bus_for_each_dev+0x56/0x90
> > > > Sep 26 19:22:58 fambox kernel: [   11.142129]  [<ffffffff813d425e>]
> > > > driver_attach+0x1e/0x20
> > > > Sep 26 19:22:58 fambox kernel: [   11.143264]  [<ffffffff813d3dd0>]
> > > > bus_add_driver+0x190/0x290
> > > > Sep 26 19:22:58 fambox kernel: [   11.144443]  [<ffffffff813d4efa>]
> > > > driver_register+0x7a/0x160
> > > > Sep 26 19:22:58 fambox kernel: [   11.145583]  [<ffffffff81345ccf>]
> > > > acpi_bus_register_driver+0x43/0x45
> > > > Sep 26 19:22:58 fambox kernel: [   11.146871]  [<ffffffffa00e4dac>]
> > > > acpi_video_register+0x20/0x39 [video]
> > > > Sep 26 19:22:58 fambox kernel: [   11.148167]  [<ffffffffa02f4bad>]
> > > > i915_driver_load+0x83d/0xea0 [i915]
> > > > Sep 26 19:22:58 fambox kernel: [   11.149451]  [<ffffffffa020ebc1>]
> > > > drm_get_pci_dev+0x191/0x2b0 [drm]
> > > > Sep 26 19:22:58 fambox kernel: [   11.150739]  [<ffffffffa0345e2b>]
> > > > i915_pci_probe+0x4f/0x57 [i915]
> > > > Sep 26 19:22:58 fambox kernel: [   11.152015]  [<ffffffff81309af9>]
> > > > local_pci_probe+0x79/0x100
> > > > Sep 26 19:22:58 fambox kernel: [   11.153287]  [<ffffffff8130b1f9>]
> > > > pci_device_probe+0x109/0x130
> > > > Sep 26 19:22:58 fambox kernel: [   11.154546]  [<ffffffff813d472b>]
> > > > driver_probe_device+0x7b/0x240
> > > > Sep 26 19:22:58 fambox kernel: [   11.155796]  [<ffffffff813d499b>]
> > > > __driver_attach+0xab/0xb0
> > > > Sep 26 19:22:58 fambox kernel: [   11.157048]  [<ffffffff813d48f0>] ?
> > > > driver_probe_device+0x240/0x240
> > > > Sep 26 19:22:58 fambox kernel: [   11.158280]  [<ffffffff813d2b46>]
> > > > bus_for_each_dev+0x56/0x90
> > > > Sep 26 19:22:58 fambox kernel: [   11.159496]  [<ffffffff813d425e>]
> > > > driver_attach+0x1e/0x20
> > > > Sep 26 19:22:58 fambox kernel: [   11.160708]  [<ffffffff813d3dd0>]
> > > > bus_add_driver+0x190/0x290
> > > > Sep 26 19:22:58 fambox kernel: [   11.161909]  [<ffffffff813d4efa>]
> > > > driver_register+0x7a/0x160
> > > > Sep 26 19:22:58 fambox kernel: [   11.163121]  [<ffffffff8130a159>]
> > > > __pci_register_driver+0x49/0x50
> > > > Sep 26 19:22:58 fambox kernel: [   11.164227]  [<ffffffffa020edfa>]
> > > > drm_pci_init+0x11a/0x130 [drm]
> > > > Sep 26 19:22:58 fambox kernel: [   11.165295]  [<ffffffffa037c000>] ?
> > > > 0xffffffffa037bfff
> > > > Sep 26 19:22:58 fambox kernel: [   11.166351]  [<ffffffffa037c066>]
> > > > i915_init+0x66/0x68 [i915]
> > > > Sep 26 19:22:58 fambox kernel: [   11.167360]  [<ffffffff8100203f>]
> > > > do_one_initcall+0x3f/0x170
> > > > Sep 26 19:22:58 fambox kernel: [   11.168332]  [<ffffffff810bc9be>]
> > > > sys_init_module+0xbe/0x220
> > > > Sep 26 19:22:58 fambox kernel: [   11.169276]  [<ffffffff8164a0bd>]
> > > > system_call_fastpath+0x1a/0x1f
> > > > Sep 26 19:22:58 fambox kernel: [   11.170200] Code: 1b 7e 00 48 3d c0
> > > > cb c9 81 4c 8d a8 b0 fc ff ff 0f 84 bf 00 00 00 0f 1f 44 00 00 4d 8b
> > > > bd f0 02 00 00 4d 85 ff 0f 84 c0 00 00 00 <49> 8b 77 18 48 85 f6 0f 84
> > > > d3 fe ff ff 41 8b 47 14 85 c0 7e 7b
> > > > Sep 26 19:22:58 fambox kernel: [   11.172467] RIP
> > > > [<ffffffff814bb058>] thermal_cooling_device_register+0x2c8/0x3d0
> > > > Sep 26 19:22:58 fambox kernel: [   11.173542]  RSP <ffff88010f23d838>
> > > > Sep 26 19:22:58 fambox kernel: [   11.174603] CR2: 0000000000000018
> > > > Sep 26 19:22:58 fambox kernel: [   11.175675] ---[ end trace
> > > > 0f2bc437662fc097 ]---
> > > >
> > > > I have CCed some maintainers, hope they might have a look at it
> > > > (sorry, didnt check any MLs).
> > > >
> > > > My kern.log and kernel-config are attached.
> > >
> > > I get oops in bind_cdev() called from thermal_cooling_device_register()
> > > on mmotm, I expect yours is the same (but bind_cdev inlined so it doesn't
> > > appear in the backtrace).  This patch gets me booting (note it also fixes
> > > return to break to unlock the mutex), does it help you?  Whether the root
> > > problem is elsewhere or not, I've no idea; but I see Dan already spotted
> > > other errors hereabouts - probably needs more thorough review.
> > >
> > 
> > 
> > > Hugh
> > >
> > > --- mmotm/drivers/thermal/thermal_sys.c	2012-09-26
> > 10:15:28.652071362 -0700
> > > +++ linux/drivers/thermal/thermal_sys.c	2012-09-26
> > 11:41:01.549684983 -0700
> > > @@ -252,8 +252,8 @@ static void bind_cdev(struct thermal_coo
> > >  		}
> > >
> > >  		tzp = pos->tzp;
> > > -		if (!tzp->tbp)
> > > -			return;
> > > +		if (!tzp || !tzp->tbp)
> > > +			break;
> > >
> > >  		for (i = 0; i < tzp->num_tbps; i++) {
> > >  			if (tzp->tbp[i].cdev || !tzp->tbp[i].match)
> > 
> > thanks for the fix, this patch looks good to me.
> > could you please resend it in a proper format, say, with changelog and
> > Singed-off-by, so that I can apply to my -next tree?
> > 
> 
> Shouldn't this be a 'continue' instead of the 'break' here ?

yes, you're right.

thanks,
rui

