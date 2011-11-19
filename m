Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab1KSUHR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 15:07:17 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:36687 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303Ab1KSUHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 15:07:15 -0500
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Nov 2011 15:07:15 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AooAAHAJyE64rwEk/2dsb2JhbABDmiQoj3GBBoFyAQEFOBYIBhwBEAsLDQkWDwkDAgECAREOCB4GCAUBBQICBRQEh2qkToZfPYh4g1mGPgSIGoIMihaKU4MFhEs
X-IronPort-AV: E=Sophos;i="4.69,539,1315195200"; 
   d="scan'208";a="148619036"
Message-ID: <4EC80A2F.7030800@gmail.com>
Date: Sat, 19 Nov 2011 14:57:35 -0500
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110928 Firefox/7.0.1 SeaMonkey/2.4.1
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [00/26] 3.1.2-stable review
References: <20111119000336.GA8452@kroah.com>
In-Reply-To: <20111119000336.GA8452@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> This is the start of the stable review cycle for the 3.1.2 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.
>
> Responses should be made by Monday, November 21, 2011, 20:00:00 UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.1.2-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
>
>   Documentation/sound/alsa/HD-Audio-Models.txt     |    1 +
>   Makefile                                         |    4 +-
>   arch/arm/mach-at91/at91cap9_devices.c            |    2 +-
>   arch/arm/mach-at91/at91sam9g45_devices.c         |    2 +-
>   arch/arm/mach-at91/at91sam9rl_devices.c          |    2 +-
>   arch/powerpc/include/asm/sections.h              |    2 +-
>   arch/powerpc/include/asm/synch.h                 |    1 +
>   arch/powerpc/kernel/kvm.c                        |    1 -
>   arch/powerpc/kernel/setup_32.c                   |    2 +
>   arch/powerpc/kernel/setup_64.c                   |    1 +
>   arch/powerpc/kvm/book3s_hv.c                     |    1 +
>   arch/powerpc/lib/feature-fixups.c                |   23 ++++
>   arch/powerpc/platforms/ps3/interrupt.c           |   23 ++++-
>   arch/powerpc/platforms/ps3/platform.h            |    1 +
>   arch/powerpc/platforms/ps3/smp.c                 |    2 +
>   arch/sh/include/asm/page.h                       |    5 +
>   arch/x86/xen/enlighten.c                         |    3 +-
>   block/blk-map.c                                  |    7 +-
>   drivers/gpu/drm/i915/i915_gem.c                  |    2 +-
>   drivers/gpu/drm/nouveau/nouveau_channel.c        |    1 +
>   drivers/gpu/drm/nouveau/nouveau_fence.c          |    2 -
>   drivers/gpu/drm/radeon/atombios_dp.c             |    2 +-
>   drivers/leds/led-class.c                         |    5 +-
>   drivers/mfd/twl-core.c                           |    2 +-
>   drivers/net/wireless/b43/main.c                  |    7 ++
>   drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    9 ++-
>   drivers/staging/brcm80211/brcmsmac/mac80211_if.h |    6 +
>   drivers/staging/brcm80211/brcmsmac/main.c        |    8 ++
>   drivers/virtio/virtio_pci.c                      |   11 +-
>   drivers/xen/gntalloc.c                           |    4 +-
>   fs/hfs/trans.c                                   |    2 +
>   include/drm/drm_pciids.h                         |    2 +
>   mm/backing-dev.c                                 |    8 ++
>   security/keys/user_defined.c                     |    3 +-
>   sound/pci/hda/hda_codec.c                        |   60 +++++++----
>   sound/pci/hda/patch_sigmatel.c                   |   11 ++
>   sound/soc/codecs/wm8994.c                        |    2 +-
>   sound/usb/mixer.c                                |  120 +++++++++++++---------
>   38 files changed, 245 insertions(+), 105 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
Please include also

Takashi Iwai (1):
       drm/i915: Fix inconsistent backlight level during disabled


which is fixing a black-screen regression from 3.0 kernel.

Thanks, Woody


