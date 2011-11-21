Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab1KUNK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 08:10:26 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35162 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1KUNKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 08:10:23 -0500
Date: Mon, 21 Nov 2011 14:10:22 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Dave Martin <dave.martin@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Subject: Re: [PATCH 2/2] ARM: amba: Auto-generate AMBA driver module aliases
 during modpost
Message-ID: <20111121131022.GE30612@pengutronix.de>
References: <1321872510-2562-1-git-send-email-dave.martin@linaro.org>
 <1321872510-2562-3-git-send-email-dave.martin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1321872510-2562-3-git-send-email-dave.martin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dave,

On Mon, Nov 21, 2011 at 10:48:30AM +0000, Dave Martin wrote:
> --- a/drivers/amba/bus.c
> +++ b/drivers/amba/bus.c
> @@ -52,7 +52,14 @@ static int amba_uevent(struct device *dev, struct kobj_uevent_env *env)
>  	int retval = 0;
>  
>  	retval = add_uevent_var(env, "AMBA_ID=%08x", pcdev->periphid);
> -	return retval;
> +	if (retval)
> +		return retval;
> +
> +	retval = add_uevent_var(env, "MODALIAS=amba:d%08X", pcdev->periphid);
> +	if (retval)
> +		return retval;
> +
> +	return 0;
Just return retval here?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
