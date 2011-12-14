Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab1LNT5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 14:57:11 -0500
Received: from eazy.amigager.de ([213.239.192.238]:44851 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab1LNT5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 14:57:08 -0500
Date: Wed, 14 Dec 2011 20:57:51 +0100
From: tino.keitel+xorg@tikei.de
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rocko Requin <rockorequin@hotmail.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at drivers/gpu/drm/i915/i915_gem
Message-ID: <20111214195751.GA31690@mac.home>
Mail-Followup-To: Daniel Vetter <daniel.vetter@ffwll.ch>,
	Rocko Requin <rockorequin@hotmail.com>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <BAY151-W65C39B54A590BCA4E3AEBDA1B80@phx.gbl>
 <CAKMK7uEm8=bGWxDSbLtOEM3CBmbMSH+gWrUy0Od327ozvjOd5g@mail.gmail.com>
 <BAY151-W537E90462ED274C21FDA4CA1BE0@phx.gbl>
 <CAKMK7uH-_VzaeTsNJYL_wMfUHqMkvG-BSCxicfQ--RQ-_O5jsg@mail.gmail.com>
 <BAY151-W53C3AD24F2938042D0F733A1BC0@phx.gbl>
 <CAKMK7uGpn6AJGtbMCYWW1ziR=Zs+E9LB=aiB5aUu0unfVW=2oA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <CAKMK7uGpn6AJGtbMCYWW1ziR=Zs+E9LB=aiB5aUu0unfVW=2oA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 14, 2011 at 02:47:33 +0100, Daniel Vetter wrote:
> On Mon, Dec 12, 2011 at 10:16, Rocko Requin <rockorequin@hotmail.com> wrote:
> >> If you can wire up netconsole you should be able to gather the full
> >> backtrace and that would be really useful. Otherwise can you please
> >> confirm by reverting that commit from your current tree that it is
> >> indeed the culprit? Otherwise please bisect the issue.
> >
> > I built 3.2-rc5 with the patch from commit
> > eb1711bb94991e93669c5a1b5f84f11be2d51ea1 reversed, and have been using it
> > now for a day and a half without any i915_gem issues. So at this stage it
> > does seem likely it is the culprit, based on the fact that I had at least 2
> > and probably 3 i915_gem crashes in around 12 hours with the commit applied.
> > When I get some free time I'll reapply the patch and see if I can reproduce
> > the crash and get a netconsole dump.
> 
> Backtraces from another reporter seriously look like we're hitting
> some ugly use-after free. Can you please test whether the patch
> "drm/i915: Only clear the GPU domains upon a successful finish" by
> Chris Wilson fixes anything for you? You can grab it from
> http://cgit.freedesktop.org/~danvet/drm/patch/?id=389a55581e30607af0fcde6cdb4e54f189cf46cf

Hi,

it looks I stumbled over the same:

[88399.844150] kernel BUG at drivers/gpu/drm/i915/i915_gem.c:1952!
2011-12-14_19:28:56.93083 <0>[88399.844182] invalid opcode: 0000 [#1]
SMP 

While doing this I was running a 32 bit photo software (Bibble 5 pro)
in fullscreen on an otherwise 64 bit system.

The full log including the trace is attached.

I'll try with the patch applied.

Regards,
Tino

--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=intel-kernel-hang

[88399.844150] kernel BUG at drivers/gpu/drm/i915/i915_gem.c:1952!
2011-12-14_19:28:56.93083 <0>[88399.844182] invalid opcode: 0000 [#1] SMP 
[88399.844210] CPU 3 
[88399.844222] Modules linked in: bluetooth cpufreq_stats fuse ipv6 loop snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm dvb_usb_vp7045 dvb_usb dvb_core rc_core snd_timer xhci_hcd snd_page_alloc evdev
[88399.844368] 
[88399.844380] Pid: 8959, comm: Xorg Not tainted 3.2.0-rc5-00001-g3aae701 #24                  /DH67BL
[88399.844439] RIP: 0010:[<ffffffff813804d6>]  [<ffffffff813804d6>] i915_wait_request+0x516/0x530
[88399.844491] RSP: 0018:ffff88020b3cbbe8  EFLAGS: 00010246
[88399.844519] RAX: ffff88021661e800 RBX: ffff880216692038 RCX: 0000000000005250
[88399.844555] RDX: ffff8802166923f8 RSI: 0000000000000000 RDI: ffff880216692038
[88399.844591] RBP: ffff880216692000 R08: 0000000000000010 R09: 0000000000000002
[88399.844627] R10: ffff88021661e800 R11: 000000000000005a R12: 0000000000000000
[88399.844664] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88021661e800
[88399.844700] FS:  00007fbef0355880(0000) GS:ffff88021fb80000(0000) knlGS:0000000000000000
[88399.844741] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[88399.844770] CR2: 00007f2c5ed0200c CR3: 0000000216748000 CR4: 00000000000406e0
[88399.844806] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[88399.844842] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[88399.844879] Process Xorg (pid: 8959, threadinfo ffff88020b3ca000, task ffff8801f0eee110)
2011-12-14_19:28:56.93093 <0>[88399.844919] Stack:
[88399.844932]  ffff88021661e800 ffffffff813ac08c 0000000000000042 0000000000000042
[88399.844977]  ffff8802166922f8 ffffffff8138056e ffff8802166923f8 0000004200000000
[88399.845023]  ffff88020b3cbd10 ffffffff81385c01 0000000000000000 ffff880216692038
2011-12-14_19:28:56.93094 <0>[88399.845068] Call Trace:
[88399.845087]  [<ffffffff813ac08c>] ? blt_ring_flush+0xdc/0x110
[88399.845120]  [<ffffffff8138056e>] ? i915_gem_flush_ring+0x4e/0x210
[88399.845154]  [<ffffffff81385c01>] ? i915_gem_execbuffer_relocate_entry+0x171/0x300
[88399.845193]  [<ffffffff81386d0c>] ? i915_gem_do_execbuffer.isra.8+0xb3c/0x13d0
[88399.845233]  [<ffffffff81381ed8>] ? i915_gem_object_set_to_gtt_domain+0xd8/0x1d0
[88399.845272]  [<ffffffff81387a4e>] ? i915_gem_execbuffer2+0x9e/0x260
[88399.845307]  [<ffffffff8135883c>] ? drm_ioctl+0x3ec/0x4a0
[88399.845336]  [<ffffffff813879b0>] ? i915_gem_execbuffer+0x410/0x410
[88399.845371]  [<ffffffff8110c9a6>] ? do_vfs_ioctl+0x96/0x550
[88399.845402]  [<ffffffff810fc50d>] ? vfs_read+0x14d/0x170
[88399.845430]  [<ffffffff8110cea9>] ? sys_ioctl+0x49/0x80
[88399.845460]  [<ffffffff8156327b>] ? system_call_fastpath+0x16/0x1b
2011-12-14_19:28:56.93100 <0>[88399.845491] Code: ff ff 0f 1f 00 45 31 e4 e9 de fc ff ff 0f 1f 84 00 00 00 00 00 41 bc f0 ff ff ff e9 cb fc ff ff 41 bc f4 ff ff ff e9 8a fb ff ff <0f> 0b 41 bc 00 fe ff ff eb 91 45 85 e4 0f 84 5e fb ff ff e9 a8 
2011-12-14_19:28:56.93101 kern.alert: [88399.845744] RIP  [<ffffffff813804d6>] i915_wait_request+0x516/0x530
[88399.845781]  RSP <ffff88020b3cbbe8>

--sdtB3X0nJg68CQEu--
