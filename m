Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab0DADnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 23:43:31 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:50654 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab0DADnZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 23:43:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=XDnDEcr+AC0MHI5kw+k+NK17bY2K1pzzHT3Lr4uxWh0QUB3ozWKiM4ne9qetjMkl1t
         BkXIBw62kWpg7gHFppoAAPFkFthHaqMxng8kjofI8bzfpo+RAYZc6/XNy3a+V8hf8FYt
         Z+7AKsXD9I/5qDSnYhyKWD7FMg/vOuXLB2/GE=
MIME-Version: 1.0
In-Reply-To: <20100328112309.GJ5069@bicker>
References: <20100328112309.GJ5069@bicker>
Date: Wed, 31 Mar 2010 23:43:23 -0400
Message-ID: <g2ga728f9f91003312043z40b3dfb4ud6699b468860cb60@mail.gmail.com>
Subject: Re: [patch] radeon: range check issues
From: Alex Deucher <alexdeucher@gmail.com>
To: Dan Carpenter <error27@gmail.com>, Dave Airlie <airlied@redhat.com>,
       Alex Deucher <alexdeucher@gmail.com>,
       Jerome Glisse <jglisse@redhat.com>,
       =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 7:23 AM, Dan Carpenter <error27@gmail.com> wrote:
> This change makes the array larger, "MAX_SUPPORTED_TV_TIMING_V1_2" is 3
> and the original size "MAX_SUPPORTED_TV_TIMING" is 2.
>
> Also there were checks that were off by one.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> Compile tested only.  Changing the array size seemed like the right
> thing to do, in the context, but please review carefully.

That patch is correct and corresponds to the actual table sizes in the vbios.

Alex


>
> diff --git a/drivers/gpu/drm/radeon/atombios.h b/drivers/gpu/drm/radeon/atombios.h
> index 6732b5d..27e2c71 100644
> --- a/drivers/gpu/drm/radeon/atombios.h
> +++ b/drivers/gpu/drm/radeon/atombios.h
> @@ -2912,7 +2912,7 @@ typedef struct _ATOM_ANALOG_TV_INFO_V1_2
>   UCHAR                    ucTV_BootUpDefaultStandard;
>   UCHAR                    ucExt_TV_ASIC_ID;
>   UCHAR                    ucExt_TV_ASIC_SlaveAddr;
> -  ATOM_DTD_FORMAT          aModeTimings[MAX_SUPPORTED_TV_TIMING];
> +  ATOM_DTD_FORMAT          aModeTimings[MAX_SUPPORTED_TV_TIMING_V1_2];
>  }ATOM_ANALOG_TV_INFO_V1_2;
>
>  typedef struct _ATOM_DPCD_INFO
> diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
> index 93783b1..bdc0ab3 100644
> --- a/drivers/gpu/drm/radeon/radeon_atombios.c
> +++ b/drivers/gpu/drm/radeon/radeon_atombios.c
> @@ -1275,7 +1275,7 @@ bool radeon_atom_get_tv_timings(struct radeon_device *rdev, int index,
>        switch (crev) {
>        case 1:
>                tv_info = (ATOM_ANALOG_TV_INFO *)(mode_info->atom_context->bios + data_offset);
> -               if (index > MAX_SUPPORTED_TV_TIMING)
> +               if (index >= MAX_SUPPORTED_TV_TIMING)
>                        return false;
>
>                mode->crtc_htotal = le16_to_cpu(tv_info->aModeTimings[index].usCRTC_H_Total);
> @@ -1313,7 +1313,7 @@ bool radeon_atom_get_tv_timings(struct radeon_device *rdev, int index,
>                break;
>        case 2:
>                tv_info_v1_2 = (ATOM_ANALOG_TV_INFO_V1_2 *)(mode_info->atom_context->bios + data_offset);
> -               if (index > MAX_SUPPORTED_TV_TIMING_V1_2)
> +               if (index >= MAX_SUPPORTED_TV_TIMING_V1_2)
>                        return false;
>
>                dtd_timings = &tv_info_v1_2->aModeTimings[index];
>
>
