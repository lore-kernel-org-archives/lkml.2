Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab2KGPWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:22:05 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50066 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab2KGPV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:21:59 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "paul@pwsan.com" <paul@pwsan.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>
CC: Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 1/8] PWMSS: Add PWM Subsystem driver for parent<->child
 relationship
Thread-Topic: [PATCH 1/8] PWMSS: Add PWM Subsystem driver for parent<->child
 relationship
Thread-Index: AQHNuzgEnM7NwxpHPky2QVfYn5bPOJfb/ykAgABnE5A=
Date: Wed, 7 Nov 2012 15:20:26 +0000
Deferred-Delivery: Wed, 7 Nov 2012 15:20:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9DE3A0@DBDE01.ent.ti.com>
References: <1352106749-9437-1-git-send-email-avinashphilip@ti.com>
 <1352106749-9437-2-git-send-email-avinashphilip@ti.com>
 <B5906170F1614E41A8A28DE3B8D121433EC0444A@DBDE01.ent.ti.com>
In-Reply-To: <B5906170F1614E41A8A28DE3B8D121433EC0444A@DBDE01.ent.ti.com>
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

On Tue, Nov 06, 2012 at 12:05:24, Bedia, Vaibhav wrote:
> On Mon, Nov 05, 2012 at 14:42:22, Philip, Avinash wrote:
> [...]
> > +pwmss0: pwmss@48300000 {
> > +	compatible = "ti,am33xx-pwmss";
> > +	reg = <0x48300000 0x10
> > +		0x48300100 0x80
> > +		0x48300180 0x80
> > +		0x48300200 0x80>;
> Do you really need the 4 address ranges here? You eventually do add in
> child nodes with other address ranges so isn't the first entry sufficient?
> I haven't really looked at the DT details so it is enforced by that let me
> know.

This is required to define child nodes ranges so that childs reg space
entries are defined in the range.

> 
> [...]
> > +
> > +#define PWMSS_CLKCONFIG		8
> > +
> 
> This #def can use a comment.

Ok I will add.

> 
> > +void pwmss_submodule_state_change(struct device *dev, int pos, bool enable)
> > +{
> > +	struct pwmss_info *info = dev_get_drvdata(dev);
> > +	u16 val;
> > +
> > +	val = readw(info->mmio_base + PWMSS_CLKCONFIG);
> > +	if (enable)
> > +		val |= 1 << pos;
> > +	else
> > +		val &= ~(1 << pos);
> > +	mutex_lock(&info->pwmss_lock);
> > +	writew(val , info->mmio_base + PWMSS_CLKCONFIG);
> > +	mutex_unlock(&info->pwmss_lock);
> > +}
> > +EXPORT_SYMBOL(pwmss_submodule_state_change);
> 
> I see a clk_en_ack field in the clock status register. You should be checking that.

Ok. I will add for check & return status from pwmss_submodule_state_change().

> 
> [...]
> 
> > +
> > +MODULE_DESCRIPTION("pwmss driver");
> > +MODULE_AUTHOR("Texas Instruments");
> > +MODULE_LICENSE("GPL");
> > diff --git a/drivers/pwm/tipwmss.h b/drivers/pwm/tipwmss.h
> > new file mode 100644
> > index 0000000..83fdc29
> > --- /dev/null
> > +++ b/drivers/pwm/tipwmss.h
> > @@ -0,0 +1,8 @@
> 
> License text?

Ok I will add.

Thanks
Avinash
>  
> > +#ifdef CONFIG_PWM_TIPWMSS
> > +extern void pwmss_submodule_state_change(struct device *dev, int pos,
> > +		bool enable);
> > +#else
> > +static inline void pwmss_submodule_state_change(struct device *dev, int pos,
> > +		bool enable)
> > +{}
> > +#endif
> 
> Regards,
> Vaibhav
> 

