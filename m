Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab1BXJN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 04:13:27 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36583 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666Ab1BXJNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 04:13:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tCcwxz1gWwdcJRBc1zxuDLEpR0pAdizGuUeqc/fDyPhL5WYdIAVqhI6Xh/cbRVFJpN
         t5yfxtG+bhPTkkxOcDOW6Tmkd3+8Kj853NvWxWc/2o0eliqOJ0arsbF2/Jba6TDckObL
         AriUSK6vX+o3U4tHe9ZDmjBBF+Gp9/nNMRQ7s=
Subject: Re: [PATCH] regulator, mc13xxx: Remove pointless test for unsigned
 less than zero
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Yong Shen <yong.shen@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
In-Reply-To: <alpine.LNX.2.00.1102232341030.28678@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102232341030.28678@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 10:13:07 +0100
Message-ID: <1298538787.2454.24.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 23:45 +0100, Jesper Juhl wrote:
> The variable 'val' is a 'unsigned int', so it can never be less than zero. 
> This fact makes the "val < 0" part of the test done in BUG_ON() in 
> mc13xxx_regulator_get_voltage() rather pointles since it can never have 
> any effect.
> This patch removes the pointless test.


Ok for me, but the next time give also the revision of the kernel
your patch is based on (Linus one, Liam one ..) that is the 
linus-2.6.38-rc6

Acked-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>

> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  mc13xxx-regulator-core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
> index f53d31b..2bb5de1 100644
> --- a/drivers/regulator/mc13xxx-regulator-core.c
> +++ b/drivers/regulator/mc13xxx-regulator-core.c
> @@ -174,7 +174,7 @@ static int mc13xxx_regulator_get_voltage(struct regulator_dev *rdev)
>  
>  	dev_dbg(rdev_get_dev(rdev), "%s id: %d val: %d\n", __func__, id, val);
>  
> -	BUG_ON(val < 0 || val > mc13xxx_regulators[id].desc.n_voltages);
> +	BUG_ON(val > mc13xxx_regulators[id].desc.n_voltages);
>  
>  	return mc13xxx_regulators[id].voltages[val];
>  }
> 
> 

-- 
Alberto!

        Be Persistent!
                - Greg Kroah-Hartman (FOSDEM 2010)

