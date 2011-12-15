Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248Ab1LORQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:16:53 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40193 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759032Ab1LORQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:16:52 -0500
MIME-Version: 1.0
In-Reply-To: <20111215165248.GG2112@amd.com>
References: <20111215165248.GG2112@amd.com>
Date: Thu, 15 Dec 2011 23:16:52 +0600
Message-ID: <CADZ9YHi4XX4gzPvbqxBndgNGoMMNzdQH9DqjC4fT7bKRpxjcXQ@mail.gmail.com>
Subject: Re: [PATCH] Fix compile error in sound/soc/mid-x86/sst_platform.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 10:52 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> (again with mailing lists on Cc, sorry)
>
> Hi,
>
> I tested current linux-next against my iommu-configs and found a compile
> error in sound/soc/mid-x86/sst_platform.c. The variable ret_val in the
> sst_platform_open() function is used but not declared. Attached patch
> fixes this.
>

While fixing any kind of error/warning, it's nice to have
error/warning message in changelog.

Thanks,
Rakib

> From d4e6d3b9ff8084c02eaf50e8212f77bcde5dec9d Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Thu, 15 Dec 2011 17:39:31 +0100
> Subject: [PATCH] Fix compile error in sound/soc/mid-x86/sst_platform.c
>
> The variable ret_val is used but not declared. Fix this.
>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  sound/soc/mid-x86/sst_platform.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/sound/soc/mid-x86/sst_platform.c b/sound/soc/mid-x86/sst_platform.c
> index 24f9471..11c39c5 100644
> --- a/sound/soc/mid-x86/sst_platform.c
> +++ b/sound/soc/mid-x86/sst_platform.c
> @@ -267,6 +267,7 @@ static int sst_platform_open(struct snd_pcm_substream *substream)
>  {
>        struct snd_pcm_runtime *runtime = substream->runtime;
>        struct sst_runtime_stream *stream;
> +       int ret_val;
>
>        pr_debug("sst_platform_open called\n");
>
> --
> 1.7.5.4
>
> --
> AMD Operating System Research Center
>
> Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
> General Managers: Alberto Bozzo, Andrew Bowd
> Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
