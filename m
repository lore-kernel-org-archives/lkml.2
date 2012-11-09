Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab2KILBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:01:09 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41864 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab2KILBC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:01:02 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "paul@pwsan.com" <paul@pwsan.com>, "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: RE: [PATCH v2 04/10] pwm: pwm-tiecap: Add device-tree binding
 support for APWM driver
Thread-Topic: [PATCH v2 04/10] pwm: pwm-tiecap: Add device-tree binding
 support for APWM driver
Thread-Index: AQHNvYbEpZAuPtw1HkarY+rCEvUvxZfgxwiAgACGfGA=
Date: Fri, 9 Nov 2012 10:59:30 +0000
Deferred-Delivery: Fri, 9 Nov 2012 10:48:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9E44FC@DBDE01.ent.ti.com>
References: <1352361197-27442-1-git-send-email-avinashphilip@ti.com>
 <1352361197-27442-5-git-send-email-avinashphilip@ti.com>
 <20121109075219.GA22224@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121109075219.GA22224@avionic-0098.mockup.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 13:22:19, Thierry Reding wrote:
> On Thu, Nov 08, 2012 at 01:23:11PM +0530, Philip, Avinash wrote:
> > This patch
> > 1. Add support for device-tree binding for ECAP APWM driver.
> > 2. Set size of pwm-cells set to 3 to support PWM channel number, PWM
> >    period & polarity configuration from device tree.
> > 3. Add enable/disable clock gating in PWM subsystem common config space.
> > 4. When here set .owner member in platform_driver structure to
> >    THIS_MODULE.
> > 
> > Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> > Cc:	Grant Likely <grant.likely@secretlab.ca>
> > Cc: Rob Herring <rob.herring@calxeda.com>
> > Cc: Rob Landley <rob@landley.net>
> > ---
> > Changes since v1:
> > 	- Add separate patch for pinctrl support
> > 	- Add conditional check for PWM subsystem clock enable.
> > 	- Combined with HWMOD changes & DT bindings.
> > 	- Remove the custom of xlate support.
> > 
> > :000000 100644 0000000... fe24cac... A	Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
> > :100644 100644 d6d4cf0... 0d43266... M	drivers/pwm/pwm-tiecap.c
> >  .../devicetree/bindings/pwm/pwm-tiecap.txt         |   22 +++++++++
> >  drivers/pwm/pwm-tiecap.c                           |   48 +++++++++++++++++++-
> >  2 files changed, 69 insertions(+), 1 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt b/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
> > new file mode 100644
> > index 0000000..fe24cac
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
> > @@ -0,0 +1,22 @@
> > +TI SOC ECAP based APWM controller
> > +
> > +Required properties:
> > +- compatible: Must be "ti,am33xx-ecap"
> > +- #pwm-cells: Should be 3. Number of cells being used to specify PWM property.
> > +  First cell specifies the per-chip index of the PWM to use, the second
> > +  cell is the period cycle in nanoseconds and bit 0 in the third cell is
> 
> I think this should be "period in nanoseconds". I haven't heard "period
> cycle" before.

Ok

> 
> > +  used to encode the polarity of PWM output.
> 
> Maybe you should explicitly say how this is encoded.

Ok I will add details

> 
...
> >  
> > +#define ECAPCLK_EN			BIT(0)
> > +#define ECAPCLK_STOP_REQ	BIT(1)
> 
> This one doesn't seem to align with the rest. Also, why is bit 0 called
> _EN and bit 1 _STOP_REQ? Couldn't they be made more consistent, i.e.
> _START and _STOP? Or _ENABLE and _DISABLE?

Ok I will change to PWMSS_ECAPCLK_EN & PWMSS_ECAPCLK_STPO_REQ

> 
> > +
> > +#define ECAPCLK_EN_ACK		BIT(0)
> > +
> > +#define PWM_CELL_SIZE		3
> 
> You don't need a define for this.

I remove.

> 
> > +
> >  struct ecap_pwm_chip {
> >  	struct pwm_chip	chip;
> >  	unsigned int	clk_rate;
> > @@ -184,6 +194,16 @@ static const struct pwm_ops ecap_pwm_ops = {
> >  	.owner		= THIS_MODULE,
> >  };
> >  
> > +#ifdef CONFIG_OF
> > +static const struct of_device_id ecap_of_match[] = {
> > +	{
> > +		.compatible	= "ti,am33xx-ecap",
> > +	},
> > +	{},
> > +};
> > +MODULE_DEVICE_TABLE(of, ecap_of_match);
> > +#endif
> > +
> 
> I'm not sure if I remember correctly, but wasn't AM33xx support supposed
> to be DT only? In that case you don't need the CONFIG_OF guards.

I will remove

> 
...
> >  	pm_runtime_enable(&pdev->dev);
> > +	pm_runtime_get_sync(&pdev->dev);
> 
> Maybe put a blank line after this for readability.

Ok

> 
> > +	if (!(pwmss_submodule_state_change(pdev->dev.parent, ECAPCLK_EN) &
> > +				ECAPCLK_EN_ACK)) {
> 
> This is very hard to read, can you split this up into something like the
> following please?
> 
> 	status = pwmss_submodule_state_change(pdev->dev.parent, ECAPCLK_EN);
> 	if (!(status & ECAPCLK_EN_ACK)) {
> 		...
> 	}
> 

Ok I will correct it.

> > +		dev_err(&pdev->dev, "PWMSS config space clock enable failure\n");
> > +		ret = -EINVAL;
> > +		goto pwmss_clk_failure;
> > +	}
> > +	pm_runtime_put_sync(&pdev->dev);
> 
> Another blank line between the two above would be good.

Ok

> 
...
> > +		.owner	= THIS_MODULE,
> > +		.of_match_table = of_match_ptr(ecap_of_match),
> 
> Here as well, if AM33xx is DT-only, then the of_match_ptr() can be
> dropped.

Ok I will drop.

Thanks
Avinash
> 
> >  	},
> >  	.probe = ecap_pwm_probe,
> >  	.remove = __devexit_p(ecap_pwm_remove),
> 
> No __devexit_p() please.
> 
> Thierry
> 

