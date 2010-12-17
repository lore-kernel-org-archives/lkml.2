Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab0LQG1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 01:27:51 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35277 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab0LQG1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 01:27:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vhA/QLKZvP/YAmkzvlENFoQPmiilohY4gPGpLwd4/Ofh6Ut8fEjqus5Yz6LkW2pbYm
         Sg6lPMdLg/QGgtRtJwLs2mySgGk5E1nOCuESEOBBvH1pxaa6BCuJYdblTzFfRHJX3v3i
         ZA5kKUtYxXuAtfrTN5iunc1frkOGcTyZMrras=
MIME-Version: 1.0
In-Reply-To: <b9dded$hd6gpd@orsmga002.jf.intel.com>
References: <AANLkTimOOmFqxU=r+-RphdfPJ54Qr+6LHU60Grzpnerr@mail.gmail.com>
 <b9dded$hcr3k7@orsmga002.jf.intel.com> <AANLkTim=k601vg+sJJH3bvdfAmrCbCEouL78XoVxuDwy@mail.gmail.com>
 <5b55a1$iv0t6h@fmsmga002.fm.intel.com> <AANLkTi=6HOsAg1mvoZ4GBy-vw2cH-bGUsQVGtCseWvy4@mail.gmail.com>
 <b9dded$hd6gpd@orsmga002.jf.intel.com>
From: Hui Zhu <teawater@gmail.com>
Date: Fri, 17 Dec 2010 14:27:28 +0800
Message-ID: <AANLkTimcUH4kvXu3DBk1PqPDjyzVYqZ1iT=eTTmF=DVi@mail.gmail.com>
Subject: Re: [BUG] i915 boot got black screen with 2.6.37-rc5+
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, keithp@keithp.com, ak@linux.intel.com,
        gregkh@suse.de, stable@kernel.org, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still black screen.

Cannot get the log from /var/log and cannot connect the pc through
net.   So I didn't get the log.  Sorry for that.

Thanks,
Hui

On Thu, Dec 16, 2010 at 18:10, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Thu, 16 Dec 2010 10:20:57 +0800, Hui Zhu <teawater@gmail.com> wrote:
>> On Wed, Dec 15, 2010 at 18:20, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> > On Wed, 15 Dec 2010 17:28:45 +0800, Hui Zhu <teawater@gmail.com> wrote:
>> >> lspci | grep Display
>> >> 00:02.1 Display controller: Intel Corporation 82Q35 Express Integrated
>> >> Graphics Controller (rev 02)
>> >
>> > Q35. I wasn't expecting that. Can you please add drm.debug=0xe to your
>> > boot line and attach the dmesg from rc3 and rc5? Thanks.
>> > -Chris
>> >
>> > --
>> > Chris Wilson, Intel Open Source Technology Centre
>> >
>>
>> Thanks Chris.
>>
>> I post the logs of rc3+, rc4+ and rc5+ in attchement.  Wish they can
>> be more helpful.
>
> The hotplug probe was failing. The only change along that path I could see
> was to setting some hotplug flags in the analag adapter register. Can you
> try this patch to see if it fixes things for you? Meanwhile I'll check the
> docs for the validity of those flags for the various gen.
>
> diff --git a/drivers/gpu/drm/i915/intel_crt.c
> b/drivers/gpu/drm/i915/intel_crt.c
> index 8df5743..14c276e 100644
> --- a/drivers/gpu/drm/i915/intel_crt.c
> +++ b/drivers/gpu/drm/i915/intel_crt.c
> @@ -148,7 +148,9 @@ static void intel_crt_mode_set(struct drm_encoder *encoder,
>                           dpll_md & ~DPLL_MD_UDI_MULTIPLIER_MASK);
>        }
>
> -       adpa = ADPA_HOTPLUG_BITS;
> +       adpa = 0;
> +       if (INTEL_INFO(dev)->gen >= 4)
> +               adpa |= ADPA_HOTPLUG_BITS;
>        if (adjusted_mode->flags & DRM_MODE_FLAG_PHSYNC)
>                adpa |= ADPA_HSYNC_ACTIVE_HIGH;
>        if (adjusted_mode->flags & DRM_MODE_FLAG_PVSYNC)
>
> --
> Chris Wilson, Intel Open Source Technology Centre
>
