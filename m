Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab1HDXaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 19:30:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59658 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294Ab1HDXaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 19:30:09 -0400
Date: Fri, 5 Aug 2011 09:29:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@nvidia.com>
Cc: Len Brown <len.brown@intel.com>,
        "Mark Brown (broonie@opensource.wolfsonmicro.com)" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: next-200110804 ARM build break (cpuidle_call_idle)
Message-Id: <20110805092941.136089871cddff926cf1dbb7@canb.auug.org.au>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF049EEAB704@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF049EEAB704@HQMAIL01.nvidia.com>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__5_Aug_2011_09_29_41_+1000_WCO2L_eqLY+.2t5T"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Aug_2011_09_29_41_+1000_WCO2L_eqLY+.2t5T
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Thu, 4 Aug 2011 13:35:59 -0700 Stephen Warren <swarren@nvidia.com> wrote:
>
> With next-20110804, I'm seeing the following on ARM:
>=20
> arch/arm/kernel/process.c: In function 'cpu_idle':
> arch/arm/kernel/process.c:200: error: implicit declaration of function 'c=
puidle_call_idle'
>=20
> This was previously fixed with:
>=20
> https://lkml.org/lkml/2011/4/4/109
>=20
> Commit 5f8cf82 (cpuidle: stop using pm_idle) converted arches to use
> cpuidle_idle_call() but contained typos on ARM and SH transposing the
> function name into cpuidle_call_idle().
>=20
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>=20
> (which I think was included directly in linux-next according to that
> email thread)

Yeah, briefly by the looks of things.

> However, commit 5f8cf82 isn't in linux-next any more, but instead,
> a0bfa13 "cpuidle: stop depending on pm_idle" has replaced it, and has
> the same issue.

It was included first on April 4 and removed after I apllied tha bove fix
on April 15.  From April 18 on, it was not in the tree at all.  I don't
know why it has come back :-(

> Applying Mark's previous fix solves the build problem.

Hi Len.  This patch was wrong the first time around ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__5_Aug_2011_09_29_41_+1000_WCO2L_eqLY+.2t5T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOOytlAAoJEDMEi1NhKgbsvXEH/2++LQJEqHMklMya5zX2dAL8
IIpp+PLez1CIPwgUaPbBW3C8BtMctj+Tp9ZtTMjAIEYda6FfipxlNW6fjvA7z9Uq
s4KvPILXncPsi5dhRf90ixPSIWyVCOdexZ4SJaWuz6SaAnf7/2y3yOJLLLxPJ8nk
vW7D46aGAfwpiMuK86s4dZTXEh4sAjLFhW0R74cMdGo35lbovgES8I6NnQWwhINh
sDH/Hr2XQjLZYTFlWGqi1yvzfaDIxKObabeP2ZfgR0DLkdffZ9xIEFwvt0r1KiYN
NB3IiNoIF2HlEOBU0klWyqMm9lJVWs6kYBo3ibNps+cx+On4ILNq9F4LrAVcntI=
=SaTq
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Aug_2011_09_29_41_+1000_WCO2L_eqLY+.2t5T--
