Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab2IFSnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 14:43:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34233 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab2IFSnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 14:43:05 -0400
Date: Thu, 6 Sep 2012 20:42:56 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: =?iso-8859-15?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau@advansee.com>
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>,
        shawn guo <shawn.guo@linaro.org>,
        thierry reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 7/9] pwm i.MX: fix clock lookup
Message-ID: <20120906184256.GJ26594@pengutronix.de>
References: <1346935695-25179-8-git-send-email-s.hauer@pengutronix.de>
 <996111492.3799131.1346956318651.JavaMail.root@advansee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <996111492.3799131.1346956318651.JavaMail.root@advansee.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 20:41:35 up 75 days,  9:53, 37 users,  load average: 3.98, 7.97,
 9.20
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 08:31:58PM +0200, Benoît Thébaudeau wrote:
> On Thursday, September 6, 2012 2:48:13 PM, Sascha Hauer wrote:
> > 
> > +	int ret;
> > +
> > +	ret = clk_prepare_enable(imx->clk_ipg);
> > +	if (ret)
> > +		return ret;
> >  
> > -	return imx->config(chip, pwm, duty_ns, period_ns);
> > +	ret = imx->config(chip, pwm, duty_ns, period_ns);
> > +
> > +	clk_disable_unprepare(imx->clk_ipg);
> > +
> > +	return ret;
> >  }
> >  
> >  static int imx_pwm_enable(struct pwm_chip *chip, struct pwm_device
> >  *pwm)
> > @@ -169,7 +179,7 @@ static int imx_pwm_enable(struct pwm_chip *chip,
> > struct pwm_device *pwm)
> >  	struct imx_chip *imx = to_imx_chip(chip);
> >  	int ret;
> >  
> > -	ret = clk_prepare_enable(imx->clk);
> > +	ret = clk_prepare_enable(imx->clk_per);
> >  	if (ret)
> >  		return ret;
> 
> Have you tested that this actually works on i.MX53?
> 
> I have tested it successfully on i.MX35 (with a few additions to platform code).
> But i.MX35 has a single bit controlling both PWM IPG and PER clock gates.
> 
> On i.MX53, there are 2 separate control bits for these. So, if ipg clk is
> strictly required to access PWM registers, even if per clk is enabled, this code
> should not work without adding

I tested this on i.MX53, but you're right, this seems to be wrong. I'll
recheck tomorrow.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
