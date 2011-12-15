Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758513Ab1LOCCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 21:02:12 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:9839
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755804Ab1LOCCL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 21:02:11 -0500
X-SpamScore: -9
X-BigFish: VS-9(zzc89bh1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Date: Thu, 15 Dec 2011 10:10:47 +0800
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
Message-ID: <20111215021046.GD3259@S2101-09.ap.freescale.net>
References: <1323894411-12294-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20111214203153.GB24496@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20111214203153.GB24496@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 09:31:53PM +0100, Uwe Kleine-König wrote:
> Hello,
> 
> On Wed, Dec 14, 2011 at 09:26:51PM +0100, Uwe Kleine-König wrote:
> > A quick look at of_alias_get_id shows that in the error case it returns
> > -ENODEV, too, but still it's better style to propagate the value as is.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Cc: Shawn Guo <shawn.guo@linaro.org>
> > Cc: Alan Cox <alan@linux.intel.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
> > Cc: Jason Liu <jason.hui@linaro.org>
> > Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> >  drivers/tty/serial/imx.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
> > index 163fc90..75c159a 100644
> > --- a/drivers/tty/serial/imx.c
> > +++ b/drivers/tty/serial/imx.c
> > @@ -1301,7 +1301,7 @@ static int serial_imx_probe_dt(struct imx_port *sport,
> >  	ret = of_alias_get_id(np, "serial");
> >  	if (ret < 0) {
> >  		dev_err(&pdev->dev, "failed to get alias id, errno %d\n", ret);
> > -		return -ENODEV;
> > +		return ret;
> >  	}
> >  	sport->port.line = ret;
> >  
> One more comment on serial_imx_probe_dt:
> 
> It is used as follows:
> 
>         ret = serial_imx_probe_dt(sport, pdev);
> 	if (ret == -ENODEV)
> 		serial_imx_probe_pdata(sport, pdev);
> 
> IMHO you should distinguish here more carefully between the different
> -ENODEV cases. It's OK to call serial_imx_probe_pdata() if
> 
> 	!pdev->dev.of_node
> 
> but if
> 
> 	of_alias_get_id(np, "serial")
> 
> returns an error isn't that something that should make the probing of
> the device fail instead of relying on platform data and the device id
> that are non-existant and more or less random respectively if the device
> is instantiated by dt?
> 
Yes, agreed.  Care to send a fix for that too?

-- 
Regards,
Shawn

