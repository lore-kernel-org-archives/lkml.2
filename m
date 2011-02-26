Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab1BZMTt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 07:19:49 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51880 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab1BZMTr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 07:19:47 -0500
From: "Janorkar, Mayuresh" <mayur@ti.com>
To: Carl Vanderlip <carlv@codeaurora.org>,
        "davidb@codeaurora.org" <davidb@codeaurora.org>
CC: Dima Zavin <dima@android.com>,
        "open list:ARM/QUALCOMM MSM..." <linux-arm-msm@vger.kernel.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Sat, 26 Feb 2011 17:49:38 +0530
Subject: RE: [PATCH] video: msmfb: Put the partial update magic value into
 the fix_screen struct.
Thread-Topic: [PATCH] video: msmfb: Put the partial update magic value into
 the fix_screen struct.
Thread-Index: AcvVL+Sq/p7aF6FsQOC6M+O164eMnQAfxdaA
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB033CD9E831@dbde02.ent.ti.com>
References: <1298667947-22123-1-git-send-email-carlv@codeaurora.org>
In-Reply-To: <1298667947-22123-1-git-send-email-carlv@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: linux-fbdev-owner@vger.kernel.org [mailto:linux-fbdev-
> owner@vger.kernel.org] On Behalf Of Carl Vanderlip
> Sent: Saturday, February 26, 2011 2:36 AM
> To: davidb@codeaurora.org
> Cc: Dima Zavin; open list:ARM/QUALCOMM MSM...; open list:FRAMEBUFFER
> LAYER; open list
> Subject: [PATCH] video: msmfb: Put the partial update magic value into the
> fix_screen struct.
> 
> From: Dima Zavin <dima@android.com>
> 
> This can then be tested by userspace to see if the capability is
> supported.
> Userspace cannot rely on that value being left in var_screen, since
> userspace
> itself can change it.
> 
Missing Signed-off-by:
checkpatch would give error for this.
> ---
>  drivers/video/msm/msm_fb.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/msm/msm_fb.c b/drivers/video/msm/msm_fb.c
> index 5436aeb..bbf841e 100644
> --- a/drivers/video/msm/msm_fb.c
> +++ b/drivers/video/msm/msm_fb.c
> @@ -469,6 +469,14 @@ static void setup_fb_info(struct msmfb_info *msmfb)
>  	fb_info->var.yoffset = 0;
> 
>  	if (msmfb->panel->caps & MSMFB_CAP_PARTIAL_UPDATES) {
> +		/* set the param in the fixed screen, so userspace can't
> +		 * change it. This will be used to check for the
> +		 * capability. */
Multi-line comments?
> +		fb_info->fix.reserved[0] = 0x5444;
> +		fb_info->fix.reserved[1] = 0x5055;
> +
> +		/* This preloads the value so that if userspace doesn't
> +		 * change it, it will be a full update */
Multi-line comments?
>  		fb_info->var.reserved[0] = 0x54445055;
>  		fb_info->var.reserved[1] = 0;
>  		fb_info->var.reserved[2] = (uint16_t)msmfb->xres |
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
