Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750976Ab2JVHJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 03:09:06 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:59555 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2JVHJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 03:09:03 -0400
Message-ID: <1350889747.3592.17.camel@gitbox>
Subject: Re: [PATCH 2/3] PWM: vt8500: Update vt8500 PWM driver support
From: Tony Prisk <linux@prisktech.co.nz>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: devicetree-discuss@lists.ozlabs.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Mon, 22 Oct 2012 20:09:07 +1300
In-Reply-To: <1350888712.3592.11.camel@gitbox>
References: <1350643135-13197-1-git-send-email-linux@prisktech.co.nz>
	 <1350643135-13197-2-git-send-email-linux@prisktech.co.nz>
	 <20121022063423.GA17181@avionic-0098.mockup.avionic-design.de>
	 <1350888712.3592.11.camel@gitbox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-22 at 19:51 +1300, Tony Prisk wrote:
> > 
> > >  	chip = devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
> > >  	if (chip == NULL) {
> > >  		dev_err(&pdev->dev, "failed to allocate memory\n");
> > > @@ -123,26 +144,32 @@ static int __devinit pwm_probe(struct platform_device *pdev)
> > >  	chip->chip.ops = &vt8500_pwm_ops;
> > >  	chip->chip.base = -1;
> > >  	chip->chip.npwm = VT8500_NR_PWMS;
> > > +	chip->clk = of_clk_get(np, 0);
> > 
> > I thought this was supposed to work transparently across OF and !OF
> > configurations by using just clk_get() or devm_clk_get()? I guess that
> > if the driver depends on OF, then this would be moot, but we should
> > probably stick to the standard usage anyway.
> > 
> > Furthermore, of_clk_get() doesn't seem to be managed, so you'd need to
> > add explicit clk_put() in the error cleanup paths. One more argument in
> > favour of using devm_clk_get() instead.
> 
> Hmm good point. I stuck with of_ functions because its an OF only driver
> and it seemed 'backward' to mix old code with new. It does pose the
> question of 'why have of_clk_get() if existing functions work better'.

Was about to fix this but noticed why it wasn't like this to start
with :)

struct clk *devm_clk_get(struct device *dev, const char *id);
struct clk *of_clk_get(struct device_node *np, int index);

devm_clk_get requires me to 'get' the clock by name. arch-vt8500 (and I
believe a lot of other arch's) don't enforce names for clocks defined in
devicetree, therefore there is no way for me to know what name the clk
has unless I include in the binding that the clock must be named 'xxx'.

of_clk_get retrieves it by the dt-node + index, so it doesn't care as
long as its the 1st clock listed.


Welcome your feedback.

Regards
Tony P

