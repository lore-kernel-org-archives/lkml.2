Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab1KBPJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:09:51 -0400
Received: from nm24.bullet.mail.bf1.yahoo.com ([98.139.212.183]:24247 "HELO
	nm24.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932280Ab1KBPJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:09:50 -0400
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Nov 2011 11:09:50 EDT
X-Yahoo-Newman-Id: 614040.45964.bm@smtp209.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: _QjYwXoVM1kZ8s7d1tCUYS6P0eth6GY3K8.s9xOkAH2AqUm
 hshoVhaeAYRHeOcbAZqzoJR9hd.WzNB1AygDgw0Iovis_HB9ngZqoYX7zMHO
 Hijy4_.z.D7K.YNltBZff9sgAJo0GbZSQDhBPaOXrRjIPXCaTrQ96WKVWvMR
 UGyTl8k_qdLO1hlItY2HUe6CzCvQIFim5BiITnZK5e54kDdydC6ZI4qfNB9y
 jKNsk_5JMTvoebenf69Rtxi.9wOd.6L9tdhquG41HcieM.S7YvP3eL7udEkH
 .YU6fKzXu1QQ8z_ls87jjl8kFv.y1vsAK9hNOtBlrrH6pnEfWa87ftI0nmde
 K0WeDVHqUhGHxg9TFXAISlZ2_5hz8ifSANdVITrtGEELW2VTPae36U7.9oDG
 ESq9W6.zBodCqgtMipUV7WT0mdWDjQWWiaCsMam2GluSQJLhhzNuTBmSvMhX
 eeeKZ30OelgSoP4ZO
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Wed, 2 Nov 2011 10:04:13 -0500
From: Andrew Watts <akwatts@ymail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        tj@kernel.org, rjw@sisk.pl, airlied@linux.ie
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
Message-ID: <20111102150411.GA5457@zeus>
References: <20111101124759.GA1326@zeus>
 <20111102054658.GA29035@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102054658.GA29035@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 10:46:58PM -0700, Dmitry Torokhov wrote:
> 
> I am not sure how this commit could cause your "no video" issue...
> Are you hibernating from text console or X? Can you try plugging in USB
> keyboard and see if you are getting input? What about ssh into the box?
> 
> Thanks.
> 
> -- 
> Dmitry

Hi Dmitry et al.

Yes, I was hibernating from X. I do not have problems when I hibernate from
console.

I conducted the following exercise: a script runs a 20-hibernate loop that
saves dmesg output to individual files and pings my httpd server (on lo)
after every resume.

>From X, with the vanilla 2.6.39.4 kernel, I had 5 bad resumes out of 20
(the script continues though). My httpd server is pinged after all 20 
resumes and my dmesg is saved to a file. So, even after the bad resumes,
loopback networking and HD IO are functional.

The five problem resumes all have a similar warning in dmesg (see below).
I am copying Rafael Wysocki (since I can't seem to post to linux-pm@) 
and David Airlie (given the 'GPU lockup CP stall' message). [Please see 
thread https://lkml.org/lkml/2011/11/1/126 for complete history]

The same loop test conducted either a) from console or b) from X after
reversing commits 8ee294cd9def000 & 1d64b655dc083df encounters no problems
(all 20 resumes succeed) and there are no GPU lockup messages in my saved
dmesg output.

System specs:
P4 + ATI 9100IGP

~ Andy

PS. My messages do not arrive to linux-pm@lists.linux-foundation.org. Does
    posting require subscription?

-----------------------------

[  243.626231] radeon 0000:01:05.0: GPU lockup CP stall for more than 82318msec
[  243.626236] ------------[ cut here ]------------
[  243.626252] WARNING: at drivers/gpu/drm/radeon/radeon_fence.c:246 radeon_fence_wait+0x2c3/0x311()
[  243.626256] Hardware name: Pavilion zv5000
[  243.626259] GPU lockup (waiting for 0x00000F8C last fence id 0x00000F8A)
[  243.626262] Modules linked in: fan snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss fuse pl2303 snd_atiixp snd_ac97_codec ac97_bus snd_pcm pcmcia snd_timer snd ohci_hcd shpchp processor yenta_socket pcmcia_rsrc ssb video thermal wmi battery button ac ehci_hcd thermal_sys pcmcia_core firewire_ohci snd_page_alloc
[  243.626311] Pid: 1646, comm: X Tainted: G   M        2.6.39.4 #19
[  243.626314] Call Trace:
[  243.626325]  [<c1033164>] warn_slowpath_common+0x67/0x8e
[  243.626331]  [<c12c082a>] ? radeon_fence_wait+0x2c3/0x311
[  243.626335]  [<c12c082a>] ? radeon_fence_wait+0x2c3/0x311
[  243.626339]  [<c1033207>] warn_slowpath_fmt+0x2e/0x30
[  243.626344]  [<c12c082a>] radeon_fence_wait+0x2c3/0x311
[  243.626352]  [<c104b12a>] ? wake_up_bit+0x62/0x62
[  243.626358]  [<c12c0e37>] radeon_sync_obj_wait+0xc/0xe
[  243.626363]  [<c12908be>] ttm_bo_wait+0xa1/0x108
[  243.626371]  [<c12d6e7b>] radeon_gem_wait_idle_ioctl+0x76/0xc4
[  243.626378]  [<c127e62e>] drm_ioctl+0x1c2/0x42c
[  243.626383]  [<c12d6e05>] ? radeon_gem_set_tiling_ioctl+0x8e/0x8e
[  243.626389]  [<c109ad9a>] ? perf_pmu_enable+0x1a/0x21
[  243.626395]  [<c1026eed>] ? update_curr+0x164/0x24d
[  243.626403]  [<c11f5171>] ? rb_erase+0x16e/0x27a
[  243.626411]  [<c1007ba8>] ? __switch_to_xtra+0xf7/0x11d
[  243.626417]  [<c103015e>] ? set_next_entity+0xad/0xc1
[  243.626422]  [<c127e46c>] ? drm_version+0x8a/0x8a
[  243.626428]  [<c10e288e>] do_vfs_ioctl+0x79/0x54b
[  243.626436]  [<c158c95a>] ? schedule+0x29a/0x614
[  243.626441]  [<c10e2dcb>] sys_ioctl+0x6b/0x70
[  243.626446]  [<c1593813>] sysenter_do_call+0x12/0x22
[  243.626449] ---[ end trace 17a119d9361222c9 ]---
[  243.633615] radeon 0000:01:05.0: GPU reset succeed
[  243.671128] radeon 0000:01:05.0: WB disabled
[  243.671170] [drm] radeon: ring at 0x00000000D2001000
[  243.671189] [drm] ring test succeeded in 0 usecs
[  243.671200] [drm] ib test succeeded in 1 usecs
[  243.704033] ohci_hcd 0000:00:13.1: auto-stop root hub
[  243.704048] ohci_hcd 0000:00:13.0: auto-stop root hub

-----------------------------


