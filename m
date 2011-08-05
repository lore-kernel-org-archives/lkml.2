Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab1HEAwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 20:52:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43821 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287Ab1HEAwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 20:52:41 -0400
Date: Fri, 5 Aug 2011 10:52:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: Stephen Warren <swarren@nvidia.com>, Len Brown <len.brown@intel.com>,
        "Mark Brown (broonie@opensource.wolfsonmicro.com)" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: next-200110804 ARM build break (cpuidle_call_idle)
Message-Id: <20110805105231.7f8abe91210c30580ff40d52@canb.auug.org.au>
In-Reply-To: <20110805092941.136089871cddff926cf1dbb7@canb.auug.org.au>
References: <74CDBE0F657A3D45AFBB94109FB122FF049EEAB704@HQMAIL01.nvidia.com>
	<20110805092941.136089871cddff926cf1dbb7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__5_Aug_2011_10_52_31_+1000_=1_8qFe_O50ChKB3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Aug_2011_10_52_31_+1000_=1_8qFe_O50ChKB3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Fri, 5 Aug 2011 09:29:41 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> On Thu, 4 Aug 2011 13:35:59 -0700 Stephen Warren <swarren@nvidia.com> wro=
te:
> >
> > With next-20110804, I'm seeing the following on ARM:
> >=20
> > arch/arm/kernel/process.c: In function 'cpu_idle':
> > arch/arm/kernel/process.c:200: error: implicit declaration of function =
'cpuidle_call_idle'
> >=20
> > This was previously fixed with:
> >=20
> > https://lkml.org/lkml/2011/4/4/109
> >=20
> > Commit 5f8cf82 (cpuidle: stop using pm_idle) converted arches to use
> > cpuidle_idle_call() but contained typos on ARM and SH transposing the
> > function name into cpuidle_call_idle().
> >=20
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> >=20
> > (which I think was included directly in linux-next according to that
> > email thread)
>=20
> Yeah, briefly by the looks of things.
>=20
> > However, commit 5f8cf82 isn't in linux-next any more, but instead,
> > a0bfa13 "cpuidle: stop depending on pm_idle" has replaced it, and has
> > the same issue.
>=20
> It was included first on April 4 and removed after I apllied tha bove fix
> on April 15.  From April 18 on, it was not in the tree at all.  I don't
> know why it has come back :-(
>=20
> > Applying Mark's previous fix solves the build problem.
>=20
> Hi Len.  This patch was wrong the first time around ...

More fun!

The last three commits in the idle tree that you took from Len were in
linux-next until April 15 and then disappeared until yesterday.  The last
of these was broken back then and has been committed exactly the same now
and still breaks arm and sh.

I have reverted that commit from your tree for today ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__5_Aug_2011_10_52_31_+1000_=1_8qFe_O50ChKB3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOOz7PAAoJEDMEi1NhKgbsQG0H/iBunWME/v5OL1jd0OPeqhoR
CYZdl8VR8bvg/2O6bXLmvybUyaiKpQOuzK3IdLSAZ8/7eqi+EqLQCb9SvCMSZfY5
5G73XAEB9NDY+PivmGzaj6u4YzE2C0KQJMOHP6bQGSbvyp5yzBlxqE2oAJ57gbig
ej1199Af8/EdCJqci5pleAUrMTY0uOAhvDAgThB+xBnjyjewEsBEgOOT8UxjDEvy
OPMYsQ05a37OlmyVHMdO7T9oQeVxQRthMK+NdktT/aE90Nrzxe4OZoCk583Jaqt5
1LR70UDAjkj/56STQFY8hOrU9QFaXLdTIsaUG4v7K/SXpHjx7qVLPDu2N8eTz1A=
=871T
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Aug_2011_10_52_31_+1000_=1_8qFe_O50ChKB3--
