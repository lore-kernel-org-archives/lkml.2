Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab2FOSDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:03:52 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55767 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751554Ab2FOSDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:03:51 -0400
Message-ID: <1339783430.26435.2.camel@joe2Laptop>
Subject: Re: [PATCH] regulator: Fix double free in devm_regulator_put()
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Fri, 15 Jun 2012 11:03:50 -0700
In-Reply-To: <1339782943-16652-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1339782943-16652-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 18:55 +0100, Mark Brown wrote:
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
[]
> @@ -1461,9 +1461,7 @@ void devm_regulator_put(struct regulator *regulator)
>  
>  	rc = devres_release(regulator->dev, devm_regulator_release,
>  			    devm_regulator_match, regulator);
> -	if (rc == 0)
> -		regulator_put(regulator);
> -	else
> +	if (rc != 0)
>  		WARN_ON(rc);

Seems an odd style choice.  Perhaps:

	rc = devres_release(regulator->dev, devm_regulator_release,
			    devm_regulator_match, regulator);
	WARN_ON(rc);


