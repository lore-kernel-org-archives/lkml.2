Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1GZN7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 09:59:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:40742 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab1GZN7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 09:59:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,269,1309762800"; 
   d="scan'208";a="34627059"
Subject: Re: [PATCH] iwlagn: check for !priv->txq in
 iwlagn_wait_tx_queue_empty
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <yunvcup35gx.fsf@aiko.keithp.com>
References: <1311622702-4807-1-git-send-email-keithp@keithp.com>
	 <1311621715.5579.138.camel@wwguy-huron>  <yunvcuqunzd.fsf@aiko.keithp.com>
	 <1311627547.13973.2.camel@wwguy-ubuntu>  <yunvcup35gx.fsf@aiko.keithp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jul 2011 06:22:08 -0700
Message-ID: <1311686528.5579.145.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 23:45 -0700, Keith Packard wrote:
> On Mon, 25 Jul 2011 13:59:07 -0700, wwguy <wey-yi.w.guy@intel.com> wrote:
> > On Mon, 2011-07-25 at 13:03 -0700, Keith Packard wrote:
> > > On Mon, 25 Jul 2011 12:21:55 -0700, "Guy, Wey-Yi" <wey-yi.w.guy@intel.com> wrote:
> > > 
> > > > but why you need it?, "start device" call will fail if can not allocate
> > > > priv->txq
> > > 
> > > The device is down, so start_device was never called. At least, that's
> > > my assumption -- I've got the wireless device 'disabled' in
> > > NetworkManager.
> > > 
> 
> > the iwlagn_wait_tx_queue_empty() function only can be call from either
> > "flush" operation or from debugfs. I agree it is a problem if call from
> > debugfs. did you actually see the problem when it is not from
> > debugfs().
> 
> Yes. Here's the stack trace, which is from a suspend operation:
> 
> [  503.649555] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
> [  503.649713] IP: [<ffffffffa025d83b>] iwlagn_wait_tx_queue_empty+0x4b/0xe0 [iwlagn]
> [  503.649824] PGD 21ded3067 PUD 223bc9067 PMD 0 
> [  503.649906] Oops: 0000 [#1] SMP 
> [  503.649969] CPU 0 
> [  503.649997] Modules linked in: netconsole configfs cpufreq_stats rfcomm bnep binfmt_misc decnet uinput fuse nfsd expo
> rtfs nfs lockd fscache auth_rpcgss nfs_acl sunrpc firewire_sbp2 firewire_core crc_itu_t loop acpi_cpufreq mperf usbhid h
> id snd_hda_codec_hdmi snd_hda_codec_conexant btusb bluetooth snd_hda_intel snd_hda_codec snd_hwdep arc4 snd_pcm_oss snd_
> mixer_oss snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event battery snd_seq thinkpad_acpi nvram ac snd_timer power_sup
> ply snd_seq_device tpm_tis tpm tpm_bios iwlagn psmouse snd evdev i915 mac80211 serio_raw i2c_i801 cfg80211 drm_kms_helpe
> r drm rfkill ehci_hcd sdhci_pci sdhci i2c_algo_bit soundcore i2c_core usbcore mmc_core snd_page_alloc e1000e button vide
> o thermal processor thermal_sys
> [  503.651329] 
> [  503.651357] Pid: 3122, comm: bash Not tainted 3.0.0-00141-g2bb84e0 #110 LENOVO 4286CTO/4286CTO
> [  503.651478] RIP: 0010:[<ffffffffa025d83b>]  [<ffffffffa025d83b>] iwlagn_wait_tx_queue_empty+0x4b/0xe0 [iwlagn]
> [  503.651603] RSP: 0018:ffff88022388dce8  EFLAGS: 00010202
> [  503.651666] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [  503.651744] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88022f741ce0
> [  503.651823] RBP: 0000000100031d64 R08: dead000000200200 R09: 0000000000000001
> [  503.651900] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
> [  503.651977] R13: ffff88022f741ce0 R14: 0000000000000000 R15: ffff88022f740768
> [  503.652056] FS:  0000000000000000(0000) GS:ffff88023e200000(0063) knlGS:00000000f757c6c0
> [  503.652144] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> [  503.652208] CR2: 0000000000000004 CR3: 000000021ddf0000 CR4: 00000000000406f0
> [  503.652285] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  503.652362] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  503.652441] Process bash (pid: 3122, threadinfo ffff88022388c000, task ffff88021ddae770)
> [  503.652526] Stack:
> [  503.652557]  ffffffff81885740 ffff88022f741ce0 ffff88022f742718 0000000000000000
> [  503.652671]  ffff88022f740798 ffffffffa0250772 ffff88022f740798 ffff88022f740520
> [  503.652784]  0000000000000000 ffffffffa0230521 ffffffff81983e40 ffff88022f740288
> [  503.652895] Call Trace:
> [  503.652941]  [<ffffffffa0250772>] ? iwlagn_mac_flush+0x72/0xb0 [iwlagn]
> [  503.653028]  [<ffffffffa0230521>] ? __ieee80211_suspend+0x51/0x300 [mac80211]
> [  503.653119]  [<ffffffffa014dd78>] ? wiphy_suspend+0x48/0x60 [cfg80211]
> [  503.653198]  [<ffffffff8131a570>] ? device_pm_wait_for_dev+0x30/0x30
> [  503.653278]  [<ffffffffa014dd30>] ? index_show+0x30/0x30 [cfg80211]
> [  503.653351]  [<ffffffff8131aa61>] ? legacy_suspend+0x31/0x70
> [  503.653419]  [<ffffffff8131abcf>] ? __device_suspend+0x12f/0x170
> [  503.653489]  [<ffffffff8131b9c8>] ? dpm_suspend+0x48/0x1b0
> [  503.653559]  [<ffffffff8108deef>] ? suspend_devices_and_enter+0x7f/0x2c0
> [  503.653636]  [<ffffffff8108e24d>] ? enter_state+0x11d/0x150
> [  503.656541]  [<ffffffff8108d742>] ? state_store+0xc2/0x100
> [  503.659454]  [<ffffffff811999f1>] ? sysfs_write_file+0xe1/0x170
> [  503.662310]  [<ffffffff8113354e>] ? vfs_write+0xae/0x180
> [  503.665125]  [<ffffffff81133877>] ? sys_write+0x47/0x90
> [  503.667903]  [<ffffffff8146f455>] ? page_fault+0x25/0x30
> [  503.671084]  [<ffffffff81477a00>] ? sysenter_dispatch+0x7/0x2e
> [  503.673924] Code: 31 e4 66 0f 1f 44 00 00 41 0f b6 85 69 0a 00 00 44 39 e0 74 56 49 8b b5 08 3f 00 00 49 63 c4 48 8d 
> 14 80 48 8d 1c 50 48 8d 1c de <8b> 43 04 39 43 08 75 17 eb 36 0f 1f 00 bf 01 00 00 00 e8 be 1e 
> [  503.680651] RIP  [<ffffffffa025d83b>] iwlagn_wait_tx_queue_empty+0x4b/0xe0 [iwlagn]
> [  503.683809]  RSP <ffff88022388dce8>
> [  503.686906] CR2: 0000000000000004
> [  503.690267] ---[ end trace 513210ed9b54a44b ]---
> 
> > there is a recent patch in mac80211 to make sure do not call "flush" is
> > not needed.
> 
> If that avoids calling iwlagn_mac_flush when the interface isn't
> running, that should work. I'd appreciate a pointer to the patch so I
> can test it.

please apply this patch in wireless-next-2.6

commit 94f9b97be5b3bf67392e43fb7f567721b09142c2
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Jul 14 16:48:54 2011 +0200

    mac80211: be more careful in suspend/resume

Thanks
Wey
> 


