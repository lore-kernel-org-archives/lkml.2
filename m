Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab2GZWQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 18:16:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49798 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642Ab2GZWQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 18:16:30 -0400
Date: Thu, 26 Jul 2012 23:16:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] mfd: add MAX8907 core driver
Message-ID: <20120726221604.GL4560@opensource.wolfsonmicro.com>
References: <1343331630-27126-1-git-send-email-swarren@wwwdotorg.org>
 <20120726203526.GD4560@opensource.wolfsonmicro.com>
 <5011BF90.5030708@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OGLMwEELQbPC02lM"
Content-Disposition: inline
In-Reply-To: <5011BF90.5030708@wwwdotorg.org>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OGLMwEELQbPC02lM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 26, 2012 at 04:07:12PM -0600, Stephen Warren wrote:
> On 07/26/2012 02:35 PM, Mark Brown wrote:
> > On Thu, Jul 26, 2012 at 01:40:30PM -0600, Stephen Warren wrote:

> >> +		if (irqd_is_wakeup_set(d)) {
> >> +			/* 1 -- disable, 0 -- enable */
> >> +			switch (irq_data->mask_reg) {

> > This loop we should just port over into the regmap code.

> I assume the best way of doing this is to add new functions
> regmap_irq_suspend()/regmap_irq_resume() (which would mask any enabled
> interrupts that were not wake enabled); that way, the regmap_irq code
> can loop over each register and just write it once. An alternative might
> be to implement struct irq_chip's .irq_suspend/.irq_resume ops, but that
> might worst-case end up with an I2C write per interrupt.

irq_suspend() and irq_resume() are only supposed to be called once per
irq_chip so there should be no concern with using them.  Even if they
weren't it's probably not that performance critical really.

> I see that the MAX8907 IRQ code does this in suspend:

> 	if (device_may_wakeup(chip->dev))
> 		enable_irq_wake(i2c->irq);
> 	else
> 		disable_irq(i2c->irq);

> and this in resume:

> 	if (device_may_wakeup(chip->dev))
> 		disable_irq_wake(i2c->irq);
> 	else
> 		enable_irq(i2c->irq);

> neither of which are done in regmap_irq, since it doesn't explicitly do
> anything for suspend/resume at the moment. Are those code blocks
> necessary? I see that regmap_irq_sync_unlock() is already calling
> irq_set_irq_wake(), which implies that suspend/resume may have already
> been completely taken care of?

Yes, it should already be taken care of.  What the calls here are doing
is mostly allowing userspace to explicitly override the wake state on a
per chip basis.  I'm not convinced it's terribly clever to implement
explicit wake support on an interrupt controller, it seems prone to
confusion.  We could do that though.

--OGLMwEELQbPC02lM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQEcGeAAoJEBus8iNuMP3dyVwQAI9czs/UnQwsOhkJFLYSHFOE
zVAQNjZaNghtTKOS3UgTV+0cJuY9TVaMX/6MFIT2IkH8ieXrohCIBHDVOky7xAFY
H/FQ2pdVmv8/Y0IJU91gpMlhauJOhaSBWQYjSlTvP9ADC4ilnvpyBCQn8/3VQi9j
UJj8KjIWttXyf0KHan3e0wj+agUsf3u12R6Jy4ib8cONCnIMt7AqaNeL1G4JcD+y
DpeSn8n10aRYaauHSZ3gR75SI5ZUtIcA09KsC2KVTPAPWbSlqE4OZ2KbEZET4h7/
omOKoDonki5tOfIQ3tQrjicBFW3e2BiaYDIB3LEXJ3T4Zsx43PDqm3uIAXuy671p
k/L85K6jPAH0jN+wOlnxoUFY8kFlcoiJ/tR/sgfTIV9CZzCWkLwZ/VvFTVsVs/Vj
deHgMuWJ/fi3lbwr2lFjvRscDedJzguixG3pUaXKojYBTUh9aHt7Vza3TZGzE50U
vhkPrDlB5wD+7QySZofW9b1J+hKOOdlkIfIfFVlmvX+hCsE6lPAvw3L8vAIyxxOy
W65FQ7NTqKnZaGwAJtJi8OI1bscfLG0ixxLhofVDH9dfPJ8F044uxfK/qiY4bZJ8
43wGTnWFSDGYl8T57wLhQTHzesbHZ6KF5sLkMzdUiDtCLXDTz3TQo8HLRxJmWJEs
32B5ewW6Qad4cdGgLoFu
=5v6h
-----END PGP SIGNATURE-----

--OGLMwEELQbPC02lM--
