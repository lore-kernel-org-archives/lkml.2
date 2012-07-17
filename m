Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab2GQQxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 12:53:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60090 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284Ab2GQQxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 12:53:48 -0400
Date: Tue, 17 Jul 2012 17:53:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2 1/6] mfd: tps6586x:use devm managed resources
Message-ID: <20120717165346.GH4477@opensource.wolfsonmicro.com>
References: <1342421510-10638-1-git-send-email-ldewangan@nvidia.com>
 <1342421510-10638-2-git-send-email-ldewangan@nvidia.com>
 <20120716200110.GD10774@opensource.wolfsonmicro.com>
 <5004ED3F.4080601@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B8ONY/mu/bqBak9m"
Content-Disposition: inline
In-Reply-To: <5004ED3F.4080601@nvidia.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B8ONY/mu/bqBak9m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 17, 2012 at 10:12:39AM +0530, Laxman Dewangan wrote:
> On Tuesday 17 July 2012 01:31 AM, Mark Brown wrote:
> >On Mon, Jul 16, 2012 at 12:21:45PM +0530, Laxman Dewangan wrote:

> >>-	ret = request_threaded_irq(irq, NULL, tps6586x_irq, IRQF_ONESHOT,
> >>-				   "tps6586x", tps6586x);
> >>+	ret = devm_request_threaded_irq(tps6586x->dev, irq, NULL, tps6586x_irq,
> >>+			IRQF_ONESHOT, "tps6586x", tps6586x);

> >Are you sure this is safe - what guarantees that we can't get an
> >interrupt while tearing the device down?

> I think device_remove will get called before the managed resource
> get freed.
> So do we need to call disable_irq() in remove() to avoid any interrupts?

That would be very rude if the IRQ happened to get shared, though that's
not possible at the moment.  In general it's pretty hard to use devm_
IRQs safely, it's normally safest to avoid them due to the issues with
ensuring that the interrupt handler is safe to be called even while the
device is being torn down.

--B8ONY/mu/bqBak9m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBZiSAAoJEBus8iNuMP3dVdIQAJW+4UGrvFGbs+d9obByjgjQ
XJTajFDIgM6L2jxzHMF2NmhIHMev1s7aUk3P0fkXGLCSjL7tNBlupB2oGAVtLqnM
UawYTKBl4M3EepvkHDkH/rf7ZwgrGKfRlVf5w969tHAdywCAXuGeWmVwwcGltN+d
kG3zmHjC0qISoo5b0UFJ5gKbty9XWOSh8Cc/4P2OdGenu3iEo1uxbnhSVxRlUTAN
NC7xYu59mwPvvrX2BkDkwDlKqUkOKcbayIhR4JAGDVN5KWhnFryIBtUNkL5ZpQVy
ZoKlYKsQtF+kfNdoNHJPdFM4EZweerKisVC+tBCIz32ICr3tnsa7svaRCTMjk1/w
bQrxyNo3Lcj8ga/MhLzWEDlAop+VzHkrRcbQXFmlnruDZJLm3wrfYXMdUDhRzqe8
fcw7OTiygGywwl9SrkZn0yFBvj3mefMd6lTQ5xc6yCmHXiJeDFZH2qRTW5yT1S2j
w9hopgXOmFasZKWxVy23dBsQdgBHzhlDup5ZFuQmm0ZZUzP91q6xarQIiViL/+4U
IKj/sPDqyNdLy6ywsR7ihoi7oOgDFoEpr6ZkoJpRb0EM8mBGJ8oxPZqjfuP1S6f+
uSaRdc7o7MpyQyE9Myu6+gDchePU+chBSTNdjCeAsyWF02e3L9Q53c9VJEz20TR8
YmF9UghHbJndN9ZVgiOM
=ExjE
-----END PGP SIGNATURE-----

--B8ONY/mu/bqBak9m--
