Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab0EHN1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 09:27:19 -0400
Received: from cable-static-49-187.intergga.ch ([157.161.49.187]:35245 "EHLO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab0EHN1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 09:27:17 -0400
X-Spam-ASN: 
X-Spam-Hammy: 0.000-+--H*Ad:U*dri-devel, 0.000-+--dri-devel, 0.000-+--dridevel
X-Spam-Spammy: 
Date: Sat, 8 May 2010 15:27:50 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nils Radtke <lkml@Think-Future.de>, dri-devel@lists.freedesktop.org,
       linux-kernel@vger.kernel.org,
       "Jan Evert van Grootheest (SDG)" <j.e.van.grootheest@caiway.nl>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference,
 i915_gem_object_move_to_active
Message-ID: <20100508132750.GA17682@viiv.ffwll.ch>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Nils Radtke <lkml@Think-Future.de>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	"Jan Evert van Grootheest (SDG)" <j.e.van.grootheest@caiway.nl>
References: <20100504222216.GW3479@localhost>
 <20100506150708.4baa4b70.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506150708.4baa4b70.akpm@linux-foundation.org>
X-Operating-System: Linux viiv 2.6.34-rc5-00127-g3008a73 
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe-Duplicate-of: https://bugzilla.kernel.org/show_bug.cgi?id=15664

There's a test patch in that bz entry (the one that adds two BUG_ONs).
If you're hitting these, is rather likely that it's the same bug.

Yours, Daniel

On Thu, May 06, 2010 at 03:07:08PM -0700, Andrew Morton wrote:
> (cc dri-devel)
> 
> On Wed, 5 May 2010 00:22:16 +0200
> Nils Radtke <lkml@Think-Future.de> wrote:
> 
> >   Hi,
> > 
> > It happens quite often that X crashes for unknown reasons but this time 
> > there it's left us a note, this BUG:
> > 
> > BUG: unable to handle kernel NULL pointer dereference at 000001e4
> > IP: [<c134ddbc>] i915_gem_object_move_to_active+0x1c/0xa0
> > *pde = 00000000 
> > Oops: 0000 [#4] PREEMPT 
> > last sysfs file: /sys/devices/pci0000:00/0000:00:1c.1/0000:04:00.0/net/wlan0/wireless/link
> > Modules linked in: wlan_scan_sta ath_rate_sample ath_pci ath_hal option usbserial usb_storage snd_usb_audio snd_usb_lib snd_seq_midi snd_rawmidi uvcvideo wlan_ccmp video1394 raw1394 dv1394 firewire_ohci firewire_core wlan ohci1394 tg3 libphy ieee1394 [last unloaded: ath_hal]
> > 
> > Pid: 3328, comm: Xorg Tainted: G      D    2.6.33 #1 Columbia                       /Extensa 5220                   
> > EIP: 0060:[<c134ddbc>] EFLAGS: 00213282 CPU: 0
> > EIP is at i915_gem_object_move_to_active+0x1c/0xa0
> > EAX: 00000000 EBX: c6679450 ECX: c679fd50 EDX: 00b10a13
> > ESI: 00000000 EDI: 00000000 EBP: 00b10a13 ESP: f51c1cb0
> >  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> > Process Xorg (pid: 3328, ti=f51c0000 task=f6be5bf0 task.ti=f51c0000)
> > Stack:
> >  c6679450 00000004 00000000 c679fd50 c134e83f 00000002 c17d42ab c16e3b29
> > <0> c17d71ee 00b10a13 00000004 f7395800 f7318000 f7318e10 c1326450 f7318df8
> > <0> f6baff20 00b10a13 f7318de8 f7318e10 f7318000 00000004 00000001 f7395800
> > Call Trace:
> >  [<c134e83f>] ? i915_add_request+0x25f/0x370
> >  [<c1326450>] ? agp_flush_chipset+0x10/0x20
> >  [<c1352d55>] ? i915_gem_do_execbuffer+0x1325/0x13a0
> >  [<c102e087>] ? check_preempt_wakeup+0x87/0x160
> >  [<c13530ae>] ? i915_gem_execbuffer+0xee/0x4b0
> >  [<c13531fb>] ? i915_gem_execbuffer+0x23b/0x4b0
> >  [<c1334056>] ? drm_ioctl+0x186/0x380
> >  [<c1352fc0>] ? i915_gem_execbuffer+0x0/0x4b0
> >  [<c10d79dd>] ? do_sync_read+0xad/0xf0
> >  [<c1333ed0>] ? drm_ioctl+0x0/0x380
> >  [<c10e5fcb>] ? vfs_ioctl+0x2b/0xa0
> >  [<c10e61a3>] ? do_vfs_ioctl+0x73/0x5f0
> >  [<c1038229>] ? do_setitimer+0xd9/0x220
> >  [<c1058a93>] ? ktime_get_ts+0xe3/0x100
> >  [<c104e1e0>] ? posix_ktime_get_ts+0x0/0x10
> >  [<c10e6786>] ? sys_ioctl+0x66/0x70
> >  [<c1002c8c>] ? sysenter_do_call+0x12/0x22
> > Code: 8a 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 83 ec 10 89 c1 89 6c 24 0c 89 d5 89 1c 24 89 74 24 04 89 7c 24 08 8b 40 08 8b 71 50 <8b> b8 e4 01 00 00 8b 46 20 85 c0 74 5f 89 e1 81 e1 00 e0 ff ff 
> > EIP: [<c134ddbc>] i915_gem_object_move_to_active+0x1c/0xa0 SS:ESP 0068:f51c1cb0
> > CR2: 00000000000001e4
> > ---[ end trace 13931f32db9a26c3 ]---
> > 
> > 
> > - Is there any particular meaning for "last sysfs file" shown? I mean, could there
> >   be some link between the crash and "last sysfs file"?
> > 
> > - X crashing happens actually a lot on this specific notebook. If it's not X crashing, 
> >   then unmotivated kde log-offs or frequent firefox crashes contribute their share.
> >   It's most probably not faulty RAM, it's new, it's been tested thoroughly.
> > 
> > 
> > Thanks for some answers,
> > 
> >   Nils
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
