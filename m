Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530Ab1LOB6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 20:58:13 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:14862
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755816Ab1LOB6M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 20:58:12 -0500
X-SpamScore: -9
X-BigFish: VS-9(zzc89bh1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 15 Dec 2011 10:06:49 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>, <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawn.guo@linaro.org>, Alan Cox <alan@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jason Liu <jason.hui@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] serial/imx: propagate error from of_alias_get_id instead
 of using -ENODEV
Message-ID: <20111215020648.GC3259@S2101-09.ap.freescale.net>
References: <1323894411-12294-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1323894411-12294-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 09:26:51PM +0100, Uwe Kleine-König wrote:
> A quick look at of_alias_get_id shows that in the error case it returns
> -ENODEV, too, but still it's better style to propagate the value as is.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
> Cc: Jason Liu <jason.hui@linaro.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> ---

Acked-by: Shawn Guo <shawn.guo@linaro.org>

The only errno that of_alias_get_id could return is also -ENODEV though.

Regards,
Shawn

>  drivers/tty/serial/imx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
> index 163fc90..75c159a 100644
> --- a/drivers/tty/serial/imx.c
> +++ b/drivers/tty/serial/imx.c
> @@ -1301,7 +1301,7 @@ static int serial_imx_probe_dt(struct imx_port *sport,
>  	ret = of_alias_get_id(np, "serial");
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "failed to get alias id, errno %d\n", ret);
> -		return -ENODEV;
> +		return ret;
>  	}
>  	sport->port.line = ret;
>  
> -- 
> 1.7.7.3

