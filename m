Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab1DMTxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:53:19 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:59382 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758333Ab1DMTxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:53:17 -0400
Subject: Re: [PATCH v3] rfkill: Regulator consumer driver for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Guiming Zhuo <gmzhuo@gmail.com>
In-Reply-To: <1302723645-5286-1-git-send-email-ospite@studenti.unina.it>
References: <1302686356.3731.1.camel@jlt3.sipsolutions.net>
	 <1302723645-5286-1-git-send-email-ospite@studenti.unina.it>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 21:53:03 +0200
Message-ID: <1302724383.3731.19.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 21:40 +0200, Antonio Ospite wrote:

> +static int __devinit rfkill_regulator_probe(struct platform_device *pdev)

...

> +	platform_set_drvdata(pdev, rfkill_data);

> +static int __devexit rfkill_regulator_remove(struct platform_device *pdev)
> +{
> +	struct rfkill_regulator_data *rfkill_data = platform_get_drvdata(pdev);
> +	struct rfkill *rf_kill = rfkill_data->rf_kill;
> +
> +	rfkill_unregister(rf_kill);
> +	rfkill_destroy(rf_kill);
> +	regulator_put(rfkill_data->vcc);
> +	kfree(rfkill_data);
> +
> +	return 0;
> +}

Should remove do platform_set_drvdata(pdev, NULL)?

In any case, that's the only thing I see now and I did read the code
carefully, so if that's not necessary:

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Otherwise, feel free to include that in v4.

johannes

