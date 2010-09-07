Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab0IGNDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:03:06 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:22629 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747Ab0IGNDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:03:00 -0400
Date: Tue, 7 Sep 2010 15:02:38 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 11/14] drivers/video: Removing undead ifdef 
 CONFIG_FB_MATROX_G
Message-ID: <20100907150238.669778ac@hyperion.delvare>
In-Reply-To: <28eb44049d7ab968bd9c820f65595af79dee5688.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
	<28eb44049d7ab968bd9c820f65595af79dee5688.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Sep 2010 16:36:53 +0200, Christian Dietrich wrote:
> The CONFIG_FB_MATROX_G ifdef isn't necessary at this point, because it
> is checked in an outer ifdef level already and has no effect here.
> 
> Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
> ---
>  drivers/video/matrox/matroxfb_DAC1064.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/video/matrox/matroxfb_DAC1064.c b/drivers/video/matrox/matroxfb_DAC1064.c
> index f9fa0fd..1717623 100644
> --- a/drivers/video/matrox/matroxfb_DAC1064.c
> +++ b/drivers/video/matrox/matroxfb_DAC1064.c
> @@ -869,12 +869,9 @@ static int MGAG100_preinit(struct matrox_fb_info *minfo)
>  	minfo->capable.plnwt = minfo->devflags.accelerator == FB_ACCEL_MATROX_MGAG100
>  			? minfo->devflags.sgram : 1;
>  
> -#ifdef CONFIG_FB_MATROX_G
>  	if (minfo->devflags.g450dac) {
>  		minfo->outputs[0].output = &g450out;
> -	} else
> -#endif
> -	{
> +	} else {
>  		minfo->outputs[0].output = &m1064;
>  	}
>  	minfo->outputs[0].src = minfo->outputs[0].default_src;

Indeed.

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
