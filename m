Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab2JYERx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 00:17:53 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:45320 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871Ab2JYERt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 00:17:49 -0400
Date: Thu, 25 Oct 2012 09:39:09 +0530
From: Shiraz Hashim <shiraz.hashim@st.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: <linux-kernel@vger.kernel.org>, <spear-devel@list.st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH V4] PWM: Add SPEAr PWM chip driver support
Message-ID: <20121025040909.GE3900@localhost.localdomain>
References: <1350904001-7621-1-git-send-email-shiraz.hashim@st.com>
 <20121024055137.GC9787@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121024055137.GC9787@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 07:51:37AM +0200, Thierry Reding wrote:
> On Mon, Oct 22, 2012 at 04:36:41PM +0530, Shiraz Hashim wrote:
> [...]
> > +struct spear_pwm_chip {
> > +	void __iomem *mmio_base;
> > +	struct clk *clk;
> > +	struct pwm_chip	chip;
> 
> My editor shows a tab between pwm_chip and chip. This should really be a
> space.
> 
> > +	ret = pwmchip_add(&pc->chip);
> > +	if (ret < 0) {
> > +		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	ret = clk_prepare_enable(pc->clk);
> > +	if (ret < 0)
> > +		return pwmchip_remove(&pc->chip);
> 
> I think in order to fix the potential race condition that Viresh
> mentioned we should move the clk_prepare_enable() before the
> pwmchip_add(), but don't forget to disable and unprepare the clock if
> pwmchip_add() fails.
> 
> Actually, can't we make it a clk_prepare() only at this point and move
> the clk_enable() and clk_disable() into the if block below? In case the
> compatible value is not "st,spear1340-pwm" we don't need the clock
> enabled.
> 
> > +
> > +	if (of_device_is_compatible(np, "st,spear1340-pwm")) {
> > +		/*
> > +		 * Following enables PWM chip, channels would still be
> > +		 * enabled individually through their control register
> > +		 */
> > +		val = readl_relaxed(pc->mmio_base + PWMMCR);
> > +		val |= PWMMCR_PWM_ENABLE;
> > +		writel_relaxed(val, pc->mmio_base + PWMMCR);
> > +
> 
> Oh, and a spurious newline here... =)
> 
> > +	}
> > +
> > +	/* only disable the clk and leave it prepared */
> > +	clk_disable(pc->clk);
> 
> This can go into the if block to match the clk_enable().

All suggestions would be included in V5. I hope this would be the
last one :).

--
regards
Shiraz
