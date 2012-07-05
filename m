Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab2GENU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:20:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57978 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932339Ab2GENUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:20:25 -0400
Date: Thu, 5 Jul 2012 14:20:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
Message-ID: <20120705132021.GJ4111@opensource.wolfsonmicro.com>
References: <20120705094541.GK4111@opensource.wolfsonmicro.com>
 <4FF57EA9.7060107@linaro.org>
 <20120705120600.GT4111@opensource.wolfsonmicro.com>
 <4FF58571.2090807@linaro.org>
 <20120705122947.GY4111@opensource.wolfsonmicro.com>
 <4FF58B68.5000703@linaro.org>
 <20120705124549.GD4111@opensource.wolfsonmicro.com>
 <4FF58ED6.40106@linaro.org>
 <20120705130306.GI4111@opensource.wolfsonmicro.com>
 <4FF592A9.5050706@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U4Pv8ouM+6WX/UB7"
Content-Disposition: inline
In-Reply-To: <4FF592A9.5050706@linaro.org>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U4Pv8ouM+6WX/UB7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 05, 2012 at 02:12:09PM +0100, Lee Jones wrote:
> On 05/07/12 14:03, Mark Brown wrote:
> >On Thu, Jul 05, 2012 at 01:55:50PM +0100, Lee Jones wrote:

> >>Then were would you register it, if not here?

> >Same place as for DT.

> That is a possibility, but the idea is to reduce code in the
> platform area, not add to it. We'd also need a completely separate

But surely this would, if anything, remove code?  You already have the
code to do the registration in the MFD so all you're going to be doing
here is removing the code from=20

> platform_data structure to the one we use for platform registration,
> as much of it has now been moved into Device Tree. The regulators
> are a good example of this, but there's also GPIO information which
> is no longer relevant etc.

Hrm, the usual pattern for this stuff is that the DT is parsed into
platform data so the DT code is isolated to the parser.  It sounds like
you've got a very different structure here?

> I do believe that registering the AB8500 from the DB8500 is
> appropriate though, for the simple reason that the AB8500 is a
> sub-device to the DB8500. I think this is the correct thing to do.
> But anyway, as I said before, that ship has sailed. We _already_ do
> this. All this patch does is prevent the AB8500 from being
> registered twice when DT is not enabled.

Well, it also introduces code into mainline which is likely to be used
as a template by other people - I'd be especially worried about the next
ST platform ending up repeating the same mistakes.  If the code is so
separate perhaps it's better to just remove the non-DT support?

--U4Pv8ouM+6WX/UB7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9ZSOAAoJEBus8iNuMP3dFwIQAJX263+rimANPTEOjpkdJJaE
+47cGuv9r/NbTPrIY3g0G45jVGENY3iQYKUdR6iP51E8qfzM63cu9CbTHTdOSJEd
oyG215Ryhmza2SONWih9ySwnO8AqxX3kE60z/qkeKCkTWpyxnj8BWBaHHGtnCx9f
vNoqoW7lz1gaJggU9RPiv4ORxIajr5RdHCda+51r96xKJtcJBhDFe7xIxdInO929
3Gg1pq2QhdEZvef9JNABuaAJYNAp8wFPUQeYveLZIXyKnNCy9F3FQ/HjQnHi/Tpd
NllWcENZ+A3WCmX/dwJohldJW/Wvj8P35AoYaK1WRi9PA6aiZiet+NZIl8RxrShB
nXF7dV/wTlFhxzHU7a3A5px68zobo5xhGb49ca1defmB2DFKpmJuOm4pMc0KcYDD
JrM5QpPFE1lI0jhI+5bI3F6qG89Aa/5CZ648mV7MO49VWrABwXsCAFQbErDqm0BD
g/2WzxpbSp0wf69iaBYfLSTnPr64d3mt7IBn+tqljTvaVFPeB7xJe3qmcO528uV0
p59sNVdI+pxC/KNgix1NaxLNKxe0AmIfWVaBlz34Oz4xVPCmHxWWOLErJGZqjlXI
kfup8U+4msQrFrDT7K3tpclPhmhVqPqoEwqphFTa8JViSvd3ZNt34etq++n+zEpB
Z6sykU56IrYTxaW4whIq
=ne6A
-----END PGP SIGNATURE-----

--U4Pv8ouM+6WX/UB7--
