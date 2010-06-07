Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab0FGQDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 12:03:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53909 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab0FGQDu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 12:03:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GIAvbxIO99DWaSM1V5Iijhfm0m6PghZU/u6KLNVA4Blyt6lKTiGC8jU4z3aQHBI7em
         +1mmLFTWjASn0uqO0WosUKnZRZepPrb8zWYY+XUitoxr2hdPA6T/P7qLmvASztPQxUQc
         FD3jnFhn94mEhA5rFCeZs2BZh/nq2UTgw/8UU=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.01.1006071721310.8380@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1005261303170.19406@obet.zrqbmnf.qr>
	<s5hmxvmzwwd.wl%tiwai@suse.de>
	<alpine.LSU.2.01.1005261413040.23865@obet.zrqbmnf.qr>
	<4BFD2901.20800@ladisch.de>
	<alpine.LSU.2.01.1005271230340.18087@obet.zrqbmnf.qr>
	<4BFE5AA1.7070103@ladisch.de>
	<4BFE66CA.5070400@ladisch.de>
	<alpine.LSU.2.01.1006071404210.11780@obet.zrqbmnf.qr>
	<AANLkTilqmEK7R26DmLg0_LZ4al4F0_bX4asCl1DVA6GH@mail.gmail.com>
	<alpine.LSU.2.01.1006071721310.8380@obet.zrqbmnf.qr>
Date: Mon, 7 Jun 2010 12:03:48 -0400
Message-ID: <AANLkTilGlw3DP6iu6F5famvRTy6WZsglMnEXevqQ9mUJ@mail.gmail.com>
Subject: Re: [alsa-devel] No mixers on ATI RS780 Azalia
From: Alex Deucher <alexdeucher@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
       Dave Airlie <airlied@redhat.com>, alsa-devel@alsa-project.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 7, 2010 at 11:25 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Monday 2010-06-07 17:03, Alex Deucher wrote:
>>> * Why is it that I am only allowed to have sound in graphics mode?
>>
>>HDMI audio is only enabled on active outputs during modeset.
>
> Bleh. If it shows text, that seems pretty active to me.

Do you mean vga console prior to loading radeon or fb console after
loading radeon?  The driver needs to be loaded.  Also, the attached
monitor has to announce itself as hdmi for audio to be enabled.

>
>>> * The radeon.ko module does not have any PCI IDs defined, thus does not
>>> get autoloaded like i915.ko. Is this intentional? It also seems
>>> to default to modeset=0.
>>
>>What kernel are you using?  It definitely has pci ids and autoloads just fine.
>
> 17:20 lxwks:~ > modinfo radeon
> filename:
> /lib/modules/2.6.31.12-jen93-rt/kernel/drivers/gpu/drm/radeon/radeon.ko
> license:        GPL and additional rights
> description:    ATI Radeon
> author:         Gareth Hughes, Keith Whitwell, others.
> srcversion:     D95F7F85D05C72112F277F3
> depends:        drm
> vermagic:       2.6.31.12-jen93-rt SMP preempt mod_unload modversions 686
> parm:           no_wb:Disable AGP writeback for scratch registers (int)
>
> 17:23 samsung:~ # modinfo radeon
> filename:
> /lib/modules/2.6.35-rc2-default+/kernel/drivers/gpu/drm/radeon/radeon.ko
> license:        GPL and additional rights
> description:    ATI Radeon
> author:         Gareth Hughes, Keith Whitwell, others.
> firmware:       radeon/R520_cp.bin
> firmware:       radeon/RS600_cp.bin
> firmware:       radeon/RS690_cp.bin
> firmware:       radeon/R420_cp.bin
> firmware:       radeon/R300_cp.bin
> firmware:       radeon/R200_cp.bin
> firmware:       radeon/R100_cp.bin
> firmware:       radeon/RV710_me.bin
> firmware:       radeon/RV710_pfp.bin
> firmware:       radeon/RV730_me.bin
> firmware:       radeon/RV730_pfp.bin
> firmware:       radeon/RV770_me.bin
> firmware:       radeon/RV770_pfp.bin
> firmware:       radeon/RS780_me.bin
> firmware:       radeon/RS780_pfp.bin
> firmware:       radeon/RV670_me.bin
> firmware:       radeon/RV670_pfp.bin
> firmware:       radeon/RV635_me.bin
> firmware:       radeon/RV635_pfp.bin
> firmware:       radeon/RV620_me.bin
> firmware:       radeon/RV620_pfp.bin
> firmware:       radeon/RV630_me.bin
> firmware:       radeon/RV630_pfp.bin
> firmware:       radeon/RV610_me.bin
> firmware:       radeon/RV610_pfp.bin
> firmware:       radeon/R600_me.bin
> firmware:       radeon/R600_pfp.bin
> firmware:       radeon/R520_cp.bin
> firmware:       radeon/RS600_cp.bin
> firmware:       radeon/RS690_cp.bin
> firmware:       radeon/R420_cp.bin
> firmware:       radeon/R300_cp.bin
> firmware:       radeon/R200_cp.bin
> firmware:       radeon/R100_cp.bin
> firmware:       radeon/CYPRESS_rlc.bin
> firmware:       radeon/CYPRESS_me.bin
> firmware:       radeon/CYPRESS_pfp.bin
> firmware:       radeon/JUNIPER_rlc.bin
> firmware:       radeon/JUNIPER_me.bin
> firmware:       radeon/JUNIPER_pfp.bin
> firmware:       radeon/REDWOOD_rlc.bin
> firmware:       radeon/REDWOOD_me.bin
> firmware:       radeon/REDWOOD_pfp.bin
> firmware:       radeon/CEDAR_rlc.bin
> firmware:       radeon/CEDAR_me.bin
> firmware:       radeon/CEDAR_pfp.bin
> firmware:       radeon/R700_rlc.bin
> firmware:       radeon/R600_rlc.bin
> firmware:       radeon/RV710_me.bin
> firmware:       radeon/RV710_pfp.bin
> firmware:       radeon/RV730_me.bin
> firmware:       radeon/RV730_pfp.bin
> firmware:       radeon/RV770_me.bin
> firmware:       radeon/RV770_pfp.bin
> firmware:       radeon/RS780_me.bin
> firmware:       radeon/RS780_pfp.bin
> firmware:       radeon/RV670_me.bin
> firmware:       radeon/RV670_pfp.bin
> firmware:       radeon/RV635_me.bin
> firmware:       radeon/RV635_pfp.bin
> firmware:       radeon/RV620_me.bin
> firmware:       radeon/RV620_pfp.bin
> firmware:       radeon/RV630_me.bin
> firmware:       radeon/RV630_pfp.bin
> firmware:       radeon/RV610_me.bin
> firmware:       radeon/RV610_pfp.bin
> firmware:       radeon/R600_me.bin
> firmware:       radeon/R600_pfp.bin
> srcversion:     DF143D97DD12F63E6EEAF3F
> depends:        drm,drm_kms_helper,ttm,i2c-core,i2c-algo-bit
> vermagic:       2.6.35-rc2-default+ SMP mod_unload modversions
> parm:           no_wb:Disable AGP writeback for scratch registers (int)
> parm:           modeset:Disable/Enable modesetting (int)
> parm:           dynclks:Disable/Enable dynamic clocks (int)
> parm:           r4xx_atom:Enable ATOMBIOS modesetting for R4xx (int)
> parm:           vramlimit:Restrict VRAM for testing (int)
> parm:           agpmode:AGP Mode (-1 == PCI) (int)
> parm:           gartsize:Size of PCIE/IGP gart to setup in megabytes (32,64,
> etc)
>  (int)
> parm:           benchmark:Run benchmark (int)
> parm:           test:Run tests (int)
> parm:           connector_table:Force connector table (int)
> parm:           tv:TV enable (0 = disable) (int)
> parm:           new_pll:Select new PLL code (int)
> parm:           audio:Audio enable (0 = disable) (int)
> parm:           disp_priority:Display Priority (0 = auto, 1 = normal, 2 = high)
> (int)
> parm:           hw_i2c:hw i2c engine enable (0 = disable) (int)
> 17:24 samsung:~/linux-2.6 # git describe
> v2.6.35-rc2-1-g386f40c
> 17:25 samsung:../gpu/drm # git grep PCI_DEVICE_TABLE radeon/
> 17:25 samsung:../gpu/drm #
>

The pci ids are in include/drm/drm_pciids.h

modinfo radeon
...
srcversion:     0D187768753F1469A0E118E
alias:          pci:v00001002d00009715sv*sd*bc*sc*i*
alias:          pci:v00001002d00009714sv*sd*bc*sc*i*
alias:          pci:v00001002d00009713sv*sd*bc*sc*i*
alias:          pci:v00001002d00009712sv*sd*bc*sc*i*
alias:          pci:v00001002d00009711sv*sd*bc*sc*i*
alias:          pci:v00001002d00009710sv*sd*bc*sc*i*
alias:          pci:v00001002d00009616sv*sd*bc*sc*i*
alias:          pci:v00001002d00009615sv*sd*bc*sc*i*
alias:          pci:v00001002d00009614sv*sd*bc*sc*i*
alias:          pci:v00001002d00009613sv*sd*bc*sc*i*
alias:          pci:v00001002d00009612sv*sd*bc*sc*i*
alias:          pci:v00001002d00009611sv*sd*bc*sc*i*
alias:          pci:v00001002d00009610sv*sd*bc*sc*i*
alias:          pci:v00001002d000095CFsv*sd*bc*sc*i*
alias:          pci:v00001002d000095CEsv*sd*bc*sc*i*
alias:          pci:v00001002d000095CDsv*sd*bc*sc*i*
...

Alex
