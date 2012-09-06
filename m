Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab2IFHPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 03:15:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44268 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab2IFHPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 03:15:20 -0400
Date: Thu, 6 Sep 2012 09:15:14 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: =?iso-8859-15?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau@advansee.com>
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>,
        shawn guo <shawn.guo@linaro.org>,
        thierry reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 7/8] pwm i.MX: fix clock lookup
Message-ID: <20120906071514.GM26594@pengutronix.de>
References: <1346852127-25226-8-git-send-email-s.hauer@pengutronix.de>
 <1698432111.3713458.1346881731396.JavaMail.root@advansee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1698432111.3713458.1346881731396.JavaMail.root@advansee.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:58:37 up 74 days, 22:10, 50 users,  load average: 0.17, 0.21,
 0.28
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 11:48:51PM +0200, Benoît Thébaudeau wrote:
> >  
> > -	c = clk_get_rate(imx->clk);
> > +	c = clk_get_rate(imx->clk_per);
> >  	c = c * period_ns;
> >  	do_div(c, 1000000000);
> >  	period_cycles = c;
> > @@ -160,8 +161,15 @@ static int imx_pwm_config(struct pwm_chip *chip,
> >  		struct pwm_device *pwm, int duty_ns, int period_ns)
> >  {
> >  	struct imx_chip *imx = to_imx_chip(chip);
> > +	int ret;
> >  
> > -	return imx->config(chip, pwm, duty_ns, period_ns);
> > +	clk_prepare_enable(imx->clk_ipg);
> 
> Why don't you test the return value like in imx_pwm_enable()?

Will do next time.

Sascha

> 
> I have reviewed the whole series. Apart from the comments I made, it looks good
> to me.

Thanks. I can take this as a reviewed-by, right?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
