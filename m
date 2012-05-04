Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab2EDMrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 08:47:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60578 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753834Ab2EDMry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 08:47:54 -0400
Date: Fri, 4 May 2012 13:47:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 2/3] MFD: twl6040: Allocate IRQ numbers dynamically
Message-ID: <20120504124750.GL14230@opensource.wolfsonmicro.com>
References: <20120503145248.GJ3955@opensource.wolfsonmicro.com>
 <4FA2A08C.5000403@ti.com>
 <20120503152643.GM3955@opensource.wolfsonmicro.com>
 <4FA3958A.4080206@ti.com>
 <20120504090856.GA14230@opensource.wolfsonmicro.com>
 <4FA3B182.5060001@ti.com>
 <20120504112204.GE14230@opensource.wolfsonmicro.com>
 <4FA3C3B9.3030009@ti.com>
 <20120504121730.GG14230@opensource.wolfsonmicro.com>
 <4FA3CCAF.3020902@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EEx6GiKZGZ1wKUra"
Content-Disposition: inline
In-Reply-To: <4FA3CCAF.3020902@ti.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EEx6GiKZGZ1wKUra
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 04, 2012 at 03:33:51PM +0300, Peter Ujfalusi wrote:
> On 05/04/2012 03:17 PM, Mark Brown wrote:

> > The latter, and also just any driver that delivers an interrupt via a
> > GPIO on OMAP - if the GPIO IRQ numbers are all dynamically allocated
> > then it gets hard to register an off-chip device and tell it which
> > interrupt to request.

> For GPIO IRQ there's the gpio_to_irq() call which returns the mapped IRQ
> number for the given GPIO.

This doesn't really work for board files, though - you can only call
gpio_to_irq() at runtime so if you're statically registering the devices
on the board you'd need to make the structures non-const, manage to find
the GPIO controller at runtime then do the lookup, update the struct and
finally register the device.

> If there is "irq expander" type of chip I assume it would have similar
> way to get the IRQ number based on either GPIO number or some other
> enumeration value.

No, there's no generic interface for this.

> The twl6040 does not have such a feature. The interrupts are generated
> internally and it has one IRQ line towards the host. We have nested
> interrupts for the childs (plug detect is handled by ASoC codec, Vibra
> overcurrent is handled by the vibra driver, etc).

OK, that's fine then - you should put this in the changelog to make it
clear that there are no external users who could be affected.

--EEx6GiKZGZ1wKUra
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPo8/wAAoJEBus8iNuMP3dYVQP/iPByH/b+LWhDF+13brspMAl
uHVI6lVlGUH7yN3zxQp/yiehW8CI7MHKIi0d6OFh2iQ46ktKYi4aJ61ZZEC/buDb
GDzKtqy6repFQlq1DZnkftUYgIh9KK7k3/kV47sMJMvusLOm/ctEgikCB39zrWE+
RQkDxIWO5AegXnNpOrzaOa59s9S/3pNsuVmuG3X9mFuIrOTdjFouHrVabWVRPL7g
XG2ca9AfhOMnQ33QiiwGVtRgEqIUcp0x903OBWKOo7ZaOZv0m9TsRotSNGK2IyST
C32UvFWLoyupLnS5/YJ8Rf6SBFDAd//WRdo7Em9e75kIi+5Uq/eDb3PIlXEDBRlJ
CjakCS+r6svePTfREP+DVLUlYffj3PjGuNIhqhIF3M+3fmk2qT+XxqeCn+jyUs64
oqjnZ8auIwXIdIjC6Dnrh71i/xd5UKJ22xSXH034R1SnfYbDKaFifsbsxG8V7oFw
tsIFLRWgWYuHB6lHlQIUUzOIdm3mGu2bhceEE7F4eMBZSIN7ZplKWKAjGAdnH8l7
CMAZtnM3IJrpP+Et6kmIuA/qgkjFAjedjgrbLB5syGdLXv5TfHRuwcHGAjT2LnOe
JuV7VhvrGImoYR9KcPFaY+VzIjN/8af4BLxWIgf+MxE3RJIUZtzUCpzFuwLbkfVA
6ouWWmBt+zPZyWHwIn53
=7pJn
-----END PGP SIGNATURE-----

--EEx6GiKZGZ1wKUra--
