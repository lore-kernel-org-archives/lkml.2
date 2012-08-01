Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab2HAOjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 10:39:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57837 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2HAOjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 10:39:53 -0400
Date: Wed, 1 Aug 2012 16:39:47 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: x86 and I/O APIC IRQ domains
Message-ID: <20120801143947.GA15501@avionic-0098.adnet.avionic-design.de>
References: <20120801135839.GA19957@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <20120801135839.GA19957@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:vw2CYEcrJss6zISYU5OCZivAPAbDQo7OKKLbhXvGRuG
 i5ORBdn3ajt0z5YI9n9W16V1RlBk8g8B3+PpaCH6SpK4Ld8dOO
 M63Aons6AVfjHggFggBz4s3c2j3VNhEGaWT/YpnC0QSI2TgZcH
 apDYYxU5Z1miXQUVohZsIJ/wN7QOzSQV6oFsj0ad0T5EfuX/D0
 KzOEVk7kRK/3qcog0tPM9hjLy1V1U+FFf2qNmKX5RgFWbJSnAy
 b/NFHZXdfnoYCBxctbDnIP76/Y+YUPGK2Jbo1kCxn0yBnuDgHj
 QgO8ehvlyXXYH57z7K/9l7y2c+fumV6mw6syqpZ5ex/XyAEc07
 D8T/3YnUnTcnOwJz9sst9wC6fqviSqlbI9b/IF04b8O3YCacmf
 +q76uKIjpcdIgH6vbAxB5WyO3fppx6TAPhJTonhsyth0/6mScQ
 Ls96C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 01, 2012 at 03:58:39PM +0200, Thierry Reding wrote:
> Hi,
>=20
> I've been working on an x86 platform and want to use DT. However I've
> hit a snag when trying to instantiate the I/O APIC. I've been trying to
> follow what the CE4100 does and most things seem to work fine but when
> I add the DT node for the I/O APIC things start to fail. I've been able
> to trace the issue to x86_add_irq_domains(), which in turn calls
> ioapic_add_ofnode() from which irq_domain_add_legacy() is called.
>=20
> The platform that I use hits the WARN_ON(!irq_data || irq_data->domain).
> Looking further this seems to be caused by all irq_get_irq_data(irq)
> returning NULL for irq >=3D 16. That in turn I think is due to
> init_ISA_irqs() setting up only the first NR_IRQS_LEGACY interrupts.
> However the call to irq_domain_add_legacy() wants 32 interrupts.

So it turns out that this is not due to init_ISA_irqs(). However,
increasing NR_IRQS_LEGACY to 32 allows the code to get past that.

> This was introduced by commit b4e5185 "irq_domain/x86: Convert x86
> (embedded) to use common irq_domain)". I wonder what I'm doing wrong. I
> don't get how this is made to work on CE4100.
>=20
> Later the code crashes, but I can't exactly pinpoint the location
> because the oops doesn't fit on the screen. I don't have a serial port
> that I can use instead, so is there anything else I can do to obtain a
> complete backtrace?

This crash is in irq_domain_add_legacy() which tries to call the IRQ
domain's .map() function, which isn't implemented for the I/O APIC.
Adding an empty function allows the system to boot without any
noticeable errors.

I need to read up on the whole I/O APIC stuff because this is not really
a fix and I don't know any better. Also, the CE4100 should exhibit the
same issue after the above-mentioned commit. Can somebody more
knowledgeable shed some light on this?

Thierry

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQGT+zAAoJEN0jrNd/PrOhPmIQALTVwZhVa49Q4TPVnvE707m/
g8TKtOnrMQfj4Q6Q4DcoyiQbNPbnpKNv3A2uDFS+V/JK6N0HYdwdbZfIEqDyJiEB
Yokmh5k5x8M748YL9ztznaKt63OBbVKFNCI0eY8DYifyyE2ahVJURugZNCU9+8uu
qTxn5/waPRQdCsW4IVo/5/K6yA2od89vxx2EbhiCzTCApJ3Gz1wqthHCsigm7tHg
weKP/Xp8N7bAo+xlx6E+uAPDN/ndlD0hlTkXHuXo7CyBtmN4EltjBzzJk2R1kbPr
Un2WR0jQ78BdBR32+0E4hrzJIzrHg+CZJi71t0bDYd94HzUQqvBCmgpP7q9/U1IC
l3L1EcT4nVOwP7siqL3IEBn/VuIom3UpHzXf0PpqpzVZzOsugKBR3byG/dqhrmrQ
l4dTBJiRxckZBApD4bn/kqsvox6dxRlfor7/YyGZgF2qDrYcbPsmwV4rNge4c8bp
4Td0rD+EtanyrzJzH0lsjAWgDRdsRz1WXZqClg1M9XyxZnO4wWfpN3BuFK2rFGxd
4gmItbAzLo5ttLYPUj8myk9v4v8WlE7Cb4J7poP2ni4rbZmSMbdqhLX2CGYyLTAN
ePIqR8VHWQc7JMSrgZOztzJkRF1l+BvYr/Y2gLRzCUtpW7g6fssgo9cHa3VEfJzn
SwO/CsRLT+1UjoVDtgyt
=VuMI
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
