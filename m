Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab2GROuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 10:50:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47756 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008Ab2GROuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 10:50:35 -0400
Date: Wed, 18 Jul 2012 15:50:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>, Bryan Wu <bryan.wu@canonical.com>
Subject: Re: [PATCH 1/6] mfd: add lp8788 mfd driver
Message-ID: <20120718145032.GB4495@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998FD79B@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FD79B@DQHE02.ent.ti.com>
X-Cookie: Beware of low-flying butterflies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 18, 2012 at 02:32:40PM +0000, Kim, Milo wrote:

> +struct lp8788_irq_data {
> +	struct lp8788 *lp;
> +	struct irq_domain *irqdm;
> +	struct mutex irq_lock;
> +	struct delayed_work work;
> +	struct workqueue_struct *thread;
> +	int enabled[LP8788_INT_MAX];
> +	int irq;
> +	int irq_base;
> +};

Can you use regmap-irq?  If not can we fix things so that's possible?

> +static irqreturn_t lp8788_irq_handler(int irq, void *ptr)
> +{
> +	struct lp8788_irq_data *irqd = ptr;
> +	unsigned long delay = msecs_to_jiffies(DEBOUNCE_MSEC);
> +
> +	queue_delayed_work(irqd->thread, &irqd->work, delay);
> +
> +	return IRQ_HANDLED;
> +}

Why a delayed work?  That's *very* unusual.

> +	if (!lp->pdata) {
> +		dev_warn(lp->dev, "no platform data for irq\n");
> +		goto no_err;
> +	}

Given that you're using irq domains why does the device need platform
data?

> +	if (irq_base) {
> +		irq_base = irq_alloc_descs(irq_base, 0, LP8788_INT_MAX, 0);
> +		if (irq_base < 0) {
> +			dev_warn(lp->dev, "no allocated irq: %d\n", irq_base);
> +			goto no_err;
> +		}
> +	}

This shouldn't be needed with irq domains.

> +EXPORT_SYMBOL(lp8788_read_byte);

You're reexporting regmap functionality with looser licensing
requirements...

> +unsigned int lp8788_get_adc(struct lp8788 *lp, enum lp8788_adc_id id,
> +			enum lp8788_adc_resolution res)

For new drivers the ADC should probably be integrated into IIO.

> +static int lp8788_add_devices(struct lp8788 *lp)
> +{
> +	int ret;
> +	int irq_base = lp->pdata ? lp->pdata->irq_base : 0;
> +
> +	ret = mfd_add_devices(lp->dev, -1, lp8788_devs, ARRAY_SIZE(lp8788_devs),
> +			NULL, irq_base);

Since you're using an irq domains you shouldn't need an irq base
specifying in order to use interrupts.

> +	if (!i2c_check_functionality(cl->adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
> +		return -EIO;

I'd expect that's going to give some false negatives...

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBs0xAAoJEBus8iNuMP3dyYsQAIZpjSfUh3SPj+wszoyZubt1
HaAXn19AYEIkTD7KhpLWKBfuUcAEzVrH25TpXhgsEyhTJ2wq9MUWatf4PGU7Nvn+
aVN6WNe2vUmlOhFXnaU03dq3p8B9Wajp1f97xcLf9TgPcXchMo19XECaw+2ZLJwS
J3PH4wFZA3i/lZsv4PFORnOoCd86dsu17PGdDVQ3yCKmNc53Ktd8TnjlaEmsM8zB
C+ILB2shjNyH9esMnAArVAmglMpPGe/K/m7apkq0uVin1GHA3o3RoFQXFSULQC0K
tniUrDiYWdEaQ23+h6kVUb8V3yH5f3dkJZOFcuolui07xHgr+L4RC6q0oOz+wBQW
K1XtgRxsIi/k0AlA9upNqz42npgE2BlMi6mv7WiSfLxjeY9zv1l0hYMPYSzG0lpX
Ql28VNPdQlaFAez0577e6bu8u1tEhwvsDZ6eprJM+qhkp9mZJAkH33cHxgAuJtjZ
jlDLv1HAKpBrNIY9t8KRnoONRJx7N8eI8NYc5AXQxmsouhaFj2g6Mjs96BkLLIWQ
71DID3BrxRYGiTo1f8z2lLMXC+5lHvSLKPwx6dyXBGdfjgLO7CmzpS5EqAECvWFk
hR1jTGCapgNRn5RyhPzdu4z8Whyr1SjYCyUYY14u/+hqeFRAACeoGjtLudjbzrv7
tHyMdfY3rVDBV7I6wGf6
=PtLg
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
