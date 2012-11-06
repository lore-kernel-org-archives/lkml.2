Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab2KFIQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:16:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54522 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754201Ab2KFIQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:16:50 -0500
Date: Tue, 6 Nov 2012 09:16:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>, "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] regulator: tps80031: add regulator driver for
 tps80031
Message-ID: <20121106081647.GC3283@opensource.wolfsonmicro.com>
References: <1352108658-14289-1-git-send-email-ldewangan@nvidia.com>
 <1352108658-14289-3-git-send-email-ldewangan@nvidia.com>
 <20121105104246.GC1385@opensource.wolfsonmicro.com>
 <5097AA42.8090407@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
Content-Disposition: inline
In-Reply-To: <5097AA42.8090407@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 05, 2012 at 05:30:02PM +0530, Laxman Dewangan wrote:
> On Monday 05 November 2012 04:12 PM, Mark Brown wrote:

> >Should we be using different versions of the ops depending on the device
> >flags rather than having these switches?  It seems like we can't change
> >at runtime and it would make the code a lot simpler.

> I have single dcdc ops for all DCDC VIO, SMPS1 to 3.
> There is different configuration bit for selecting any DCDC to
> normal, extended or offset. As this ops are share, I can not change
> the callbacks.

You can change your code so that it changes the ops it registers
depending on the configuration.

> >Why the + 1 (and - 1 in the get()).  I'd expect we can just use the
> >register value directly as a selector.

> The device sets vout = 0 if vsel = 0 and then equation talk about
> the Vmin + vsel * step.
> I exported the Vout minimum as Vmin for sel = 0 and hence this is there.

> I will export this in true equation in my next patch.

You can just have list_voltage() return 0 for this voltage - it's OK to
have missing selector values.

--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQmMdoAAoJELSic+t+oim9qoEQAJq0IOLJlInTo4zO/rA4W5mh
JkriHMe+CrMVgwpVOMq/22GRsB62iD79rfirZEP6zAgXqsE50IFMq4UQ4AkDaoWJ
w6tfW8I7rHs0+ZZRlZHeriP2oHinnPPOZCEWvXs3nQ8tm4y9tcmyjF6X0Y1w61Dd
HaFNhV7uAQffuruK+fIDgBRFUZ1WWG8dfrO7G0yfb5UTHzRS255NbK1naEQQ3kgI
hwURo3mW9VYpmKn19Ztm1wwRPi3KM6E/leL0WnjtzUIs6egh9uCli/tNfgah65Ru
ob9/pKinXJijP6PPQjhyMbOTupmR8NLaQ61quybwdAeDMNYkQeX32s9MJ6z32AkA
oDoNZYQ8QMXkWo8vw1+bxUCCCanDaXzobPgAvoW8V6IKgcNO7+KiJQut/k6RbP/5
/ZRTK15NCov2gJWkbKNaWwhogd9Vqvk8Hk+o7TLrI/H/6cRpT4lrN5Oes7+Rr9FH
eovkjfxyao4eZbHATYzyOfTrL7GAsvXcSidnVBpXdd8Re90uI/2eTUWJ0+E7KRzG
4LFBWSby2OqNjPNPFBv6/CpG8sKxynGvS9P5RHBVBN2Y/OzKsO7g3nk53vGFaH6S
VIlWRBgqTSMg/gN1G+xvDnHyi6iYbtlAgp8XPu9rpDZ2y6qkgFRbQ9oAC4IJPksN
NhvQNoW7SyNdvgyGz668
=TKuT
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--
