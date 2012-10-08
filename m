Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab2JHNcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 09:32:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52992 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab2JHNcd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:32:33 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: RE: [PATCH 2/2] pwm: pwm-tiehrpwm: Add device-tree binding support
 for EHRPWM driver
Thread-Topic: [PATCH 2/2] pwm: pwm-tiehrpwm: Add device-tree binding support
 for EHRPWM driver
Thread-Index: AQHNm9yz8RT5nbmXvEiTkdtZk0kYE5elNamAgAo/QhA=
Date: Mon, 8 Oct 2012 13:31:20 +0000
Deferred-Delivery: Mon, 8 Oct 2012 13:31:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9CA1ED@DBDE01.ent.ti.com>
References: <1348658863-29428-1-git-send-email-avinashphilip@ti.com>
 <1348658863-29428-3-git-send-email-avinashphilip@ti.com>
 <20121002061143.GB4298@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121002061143.GB4298@avionic-0098.mockup.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 11:41:43, Thierry Reding wrote:
> On Wed, Sep 26, 2012 at 04:57:43PM +0530, Philip, Avinash wrote:
> > Add support for device-tree binding and of_xlate for EHRWPM driver.
> > of_xlate provides EHRPWM polarity configuration from client driver
> > device-tree.
> > Also size of pwm-cells set to 3 to support pwm channel number, pwm
> > period & polarity configuration from device tree.
> 
> Oh, I forgot to mention this in my reply to the previous patch, but you
> should consistently use PWM to refer to PWM devices, so the above should
> be "PWM channel number" and "PWM period & polarity". And the property is
> named "#pwm-cells".

I will correct it.

> 
> > Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> > ---
> > :000000 100644 0000000... 05d9d63... A	Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
> > :100644 100644 caf00fe... ae23c2b... M	drivers/pwm/pwm-tiehrpwm.c
> >  .../devicetree/bindings/pwm/pwm-tiehrpwm.txt       |   26 +++++
> >  drivers/pwm/pwm-tiehrpwm.c                         |  107 ++++++++++++++++++++
> >  2 files changed, 133 insertions(+), 0 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt b/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
> > new file mode 100644
> > index 0000000..05d9d63
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
> > @@ -0,0 +1,26 @@
> > +TI SOC EHRPWM based PWM controller
> > +
> > +Required properties:
> > +- compatible : Must be "ti,am33xx-ehrpwm"
> > +- #pwm-cells: Should be 3. Number of cells being used to specify PWM property.
> > +  First cell specifies the per-chip index of the PWM to use, the second
> > +  cell is the period cycle in nanoseconds and the third cell is the
> 
> "period cycle" doesn't make much sense. It should be "period" only. This
> also applies to the previous patch.

I will correct it.

> 
> > +  polarity of PWM output. Polarity 0 gives normal polarity and 1 gives
> > +  inversed polarity (inverse duty cycle)
> 
> I don't think "inversed" exists. It should be either "inverted polarity"
> or "inverse polarity".
> 
> > +- reg: physical base address and size of the registers map. For am33xx,
> > +  2 register maps are present (EHRPWM register space & PWM subsystem common
> > +  config space). Order should be maintained with EHRPWM register map as first
> > +  entry & PWM subsystem common config space as second entry.
> > +
> > +Optional properties:
> > +- ti,hwmods: Name of the hwmod associated to the EHRPWM:
> > +  "ehrpwm<x>", <x> being the 0-based instance number from the HW spec
> 
> I don't see where this property is used. There is no code in this patch
> that parses it.

This data used by omap_hwmod layer to create platform devices. This is part
of omap hwmod implementation.

> 
> > +static struct pwm_device *of_ehrpwm_xlate(struct pwm_chip *chip,
> > +		const struct of_phandle_args *args)
> > +{
> > +	struct pwm_device *pwm;
> > +
> > +	if (chip->of_pwm_n_cells < PWM_CELL_SIZE)
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	if (args->args[0] >= chip->npwm)
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	pwm = pwm_request_from_chip(chip, args->args[0], NULL);
> > +	if (IS_ERR(pwm))
> > +		return pwm;
> > +
> > +	pwm_set_period(pwm, args->args[1]);
> > +	pwm_set_polarity(pwm, args->args[2]);
> > +	return pwm;
> > +}
> 
> This is an exact duplicate of the ECAP's of_xlate(). Maybe we should
> make this part of the PWM core. If so it is probably safer to define the
> values for the third cell as flags, where the polarity is encoded in bit
> 0, and make the function handle this accordingly to allow other bits to
> be added in the future.

Custom of_xlate support is provided as suggested while the discussion of
"Adding support for configuring polarity in PWM framework".
https://lkml.org/lkml/2012/7/16/177

without custom of_xlate() support, PWM drivers has to populate
chip->of_pwm_n_cells = x;
as this is hard coded to 2 in pwm/core.c.

if (!chip->of_xlate) {
	chip->of_xlate = of_pwm_simple_xlate;
	chip->of_pwm_n_cells = 2;


Thanks
Avinash
 
> 
> The same comments as for patch 1 apply to the rest of this patch as
> well.
> 
> Thierry
> 

