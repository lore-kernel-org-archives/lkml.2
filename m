Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805Ab0ECMsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 08:48:41 -0400
Received: from mk-outboundfilter-6-a-2.mail.uk.tiscali.com ([212.74.114.16]:29674
	"EHLO mk-outboundfilter-6-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758565Ab0ECMsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 08:48:39 -0400
X-Trace: 204485032/mk-outboundfilter-6.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/83.67.12.31/None/tvrtko@ursulin.net
X-SBRS: None
X-RemoteIP: 83.67.12.31
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: KMail/1.12.4 (Linux/2.6.34-rc6; KDE/4.3.5; x86_64; ; )
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAGZi3ktTQwwf/2dsb2JhbACdIXK6WoUSBA
X-IronPort-AV: E=Sophos;i="4.52,319,1270422000"; 
   d="scan'208";a="204485032"
X-IP-Direction: IN
From: Tvrtko Ursulin <tvrtko@ursulin.net>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: Ooops when working with USB MIDI (2.6.33.1)
Date: Mon, 3 May 2010 13:48:35 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6; KDE/4.3.5; x86_64; ; )
Cc: Clemens Ladisch <clemens@ladisch.de>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
References: <201004051433.47171.tvrtko@ursulin.net> <201004091836.51023.tvrtko@ursulin.net> <s5hfx32bhbj.wl%tiwai@suse.de>
In-Reply-To: <s5hfx32bhbj.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005031348.35582.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 Apr 2010 08:04:48 Takashi Iwai wrote:
> At Fri, 9 Apr 2010 18:36:50 +0100,
> 
> Tvrtko Ursulin wrote:
> > On Friday 09 Apr 2010 08:29:33 Takashi Iwai wrote:
> > > At Fri, 9 Apr 2010 07:51:35 +0100,
> > >
> > > Tvrtko Ursulin wrote:
> > > > On Thursday 08 Apr 2010 13:22:36 Takashi Iwai wrote:
> > > > > > Takashi, do you remember what the original problem was?
> > > > >
> > > > > Well, I have only a vague memory -- it's a similar scenario that
> > > > > some app still accessing after disconnection.  The URB can't be
> > > > > handled after the disconnection is finished.
> > > > >
> > > > > I think the patch below might fix in this case.  You can try it
> > > > > instead of reverting the commit above.
> >
> > A very quick test and it looks good  - did not crash in the disconnect
> > and then exit TuxGuitar scenario. Thank you!
> 
> OK, now I merged thte patch.  Let me know if you see any regressions.

Just saw possibly the same oops on 2.6.34-rc6, which seems to have this patch applied:

[185589.243713] BUG: unable to handle kernel paging request at 000000000040c840
[185589.243732] IP: [<ffffffff810685c8>] module_put+0x18/0x60
[185589.243752] PGD c4616067 PUD b741a067 PMD c47c0067 PTE 0
[185589.243768] Oops: 0000 [#1] PREEMPT SMP
[185589.243779] last sysfs file: /sys/devices/platform/it87.656/temp1_input
[185589.243790] CPU 0
[185589.243795] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat it87 hwmon_vid snd_pcm_oss snd_mixer_oss snd_seq ppp_deflate 
zlib_deflate bsd_comp ppp_async crc_ccitt ppp_generic slhc radeon i2c_algo_bit nls_utf8 cifs cpufreq_conservative cpufreq_userspace 
cpufreq_powersave powernow_k8 fuse sha256_generic ansi_cprng krng eseqiv rng cryptd crypto_wq aes_x86_64 aes_generic cbc cryptomgr 
crypto_hash aead pcompress edd dm_crypt crypto_blkcipher crypto_algapi xfs exportfs loop raid0 dm_mod snd_hda_codec_atihdmi 
snd_hda_codec_via snd_usb_audio snd_hda_intel snd_hda_codec snd_usb_lib snd_hwdep snd_pcm snd_rawmidi kvm_amd snd_timer 
snd_seq_device kvm ipaq i2c_piix4 uvcvideo sr_mod snd psmouse snd_page_alloc usbserial pcspkr r8169 joydev videodev v4l1_compat 
v4l2_compat_ioctl32 wmi k10temp serio_raw button sg firewire_ohci cdrom firewire_core crc_itu_t ext4 jbd2 crc16 drm_kms_helper ttm drm fan 
processor ata_generic pata_atiixp thermal thermal_sys
[185589.244003]
[185589.244007] Pid: 21953, comm: java Not tainted 2.6.34-rc6 #2 M4A785TD-M EVO/System Product Name
[185589.244007] RIP: 0010:[<ffffffff810685c8>]  [<ffffffff810685c8>] module_put+0x18/0x60
[185589.244007] RSP: 0018:ffff8800cec7fec8  EFLAGS: 00010202
[185589.244007] RAX: ffff8800cec7ffd8 RBX: ffff88011e0d4000 RCX: 1000000000000081
[185589.244007] RDX: 000000000000003e RSI: ffffea00016e0248 RDI: 000000000040c668
[185589.244007] RBP: ffff88011d99cc20 R08: dead000000100100 R09: dead000000200200
[185589.244007] R10: dead000000100100 R11: dead000000200200 R12: 0000000000000008
[185589.244007] R13: ffff8800c1255678 R14: ffff88011d549700 R15: 00000000023cb800
[185589.244007] FS:  00007f1c265fa910(0000) GS:ffff880001800000(0000) knlGS:00000000f6959a80
[185589.244007] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[185589.244007] CR2: 000000000040c840 CR3: 0000000093488000 CR4: 00000000000006f0
[185589.244007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[185589.244007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[185589.244007] Process java (pid: 21953, threadinfo ffff8800cec7e000, task ffff8800cedd3480)
[185589.244007] Stack:
[185589.244007]  ffff88011d549700 ffffffffa02017da ffff880058621600 ffff8800c1006f00
[185589.244007] <0> ffff8800c1006f00 ffff8800c1006f00 ffff880058621600 ffffffff810d2071
[185589.244007] <0> ffff8800c1006f00 ffff8800b76c6100 0000000000000000 ffff8800b76c6180
[185589.244007] Call Trace:
[185589.244007]  [<ffffffffa02017da>] ? snd_rawmidi_release+0x4a/0x60 [snd_rawmidi]
[185589.244007]  [<ffffffff810d2071>] ? __fput+0xd1/0x1f0
[185589.244007]  [<ffffffff810ce8bb>] ? filp_close+0x4b/0x80
[185589.244007]  [<ffffffff810ce9a4>] ? sys_close+0xb4/0x110
[185589.244007]  [<ffffffff8100256b>] ? system_call_fastpath+0x16/0x1b
[185589.244007] Code: 89 44 24 08 e8 7a b6 31 00 48 8b 44 24 08 eb a6 0f 1f 00 48 83 ec 08 48 85 ff 74 37 65 48 8b 04 25 48 b5 00 00 ff 80 
44 e0 ff ff <48> 8b 87 d8 01 00 00 65 ff 40 04 83 3f 02 74 1d 65 48 8b 04 25
[185589.244007] RIP  [<ffffffff810685c8>] module_put+0x18/0x60
[185589.244007]  RSP <ffff8800cec7fec8>
[185589.244007] CR2: 000000000040c840
[185589.244432] ---[ end trace 9fdd48a93090f3c0 ]---
[185589.244442] note: java[21953] exited with preempt_count 1
[185590.711963] hda-intel: IRQ timing workaround is activated for card #1. Suggest a bigger bdl_pos_adj.
