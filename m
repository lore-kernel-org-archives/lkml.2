Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab1HYPvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:51:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51685 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab1HYPvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:51:19 -0400
Date: Fri, 26 Aug 2011 01:51:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Timur Tabi <timur@freescale.com>
Cc: Greg KH <greg@kroah.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: build failure after merge of the final tree (tty
 tree related)
Message-Id: <20110826015111.49af16f792d5554fd931d230@canb.auug.org.au>
In-Reply-To: <4E56689D.3080202@freescale.com>
References: <20110825161843.daf46b6b4023926fcfeec387@canb.auug.org.au>
	<20110825140820.GA9126@kroah.com>
	<4E56689D.3080202@freescale.com>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__26_Aug_2011_01_51_11_+1000_JCnHzThTL=VHpIl."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Aug_2011_01_51_11_+1000_JCnHzThTL=VHpIl.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Timur,

On Thu, 25 Aug 2011 10:22:05 -0500 Timur Tabi <timur@freescale.com> wrote:
>
> Is there some trick to building allyesconfig on PowerPC?  When I do try t=
hat, I
> get all sorts of weird build errors, and it dies long before it gets to my
> driver.  I get stuff like:
>=20
>   LD      arch/powerpc/sysdev/xics/built-in.o
> WARNING: arch/powerpc/sysdev/xics/built-in.o(.text+0x1310): Section misma=
tch in
> reference from the function .icp_native_init() to the function
> .init.text:.icp_native_init_one_node()
> The function .icp_native_init() references
> the function __init .icp_native_init_one_node().
> This is often because .icp_native_init lacks a __init
> annotation or the annotation of .icp_native_init_one_node is wrong.

We get lots of those in many builds. :-(  Just a warning.

> and
>=20
>   AS      arch/powerpc/kernel/head_64.o
> arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
> arch/powerpc/kernel/exceptions-64s.S:1151: Error: attempt to move .org ba=
ckwards
> arch/powerpc/kernel/exceptions-64s.S:1160: Error: attempt to move .org ba=
ckwards

There is a patch for that pending with either the kvm guys or the powerpc g=
uys.

> I guess I don't have the right compiler.

Yours seems to be OK.  If you pass -k to make it will get further.  Or
you could configure it and then just try building your driver rather than
the whole tree.

> Anyway, I think I know how to fix the break that Stephen is seeing.  I wi=
ll post
> a v4 patch in a few minutes.

Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__26_Aug_2011_01_51_11_+1000_JCnHzThTL=VHpIl.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVm9vAAoJEDMEi1NhKgbsN8oIAJxnFVWJ8wb9vu2FpTC285fY
uWiY34+ZGH2q61fyhBPTg6wiLfWIvBAkQ/HiQJleqfFD7//lLCO30otTm1xigIm+
d4Mp7+XII/CfZrhhazKgu8YyW+kjwBppTkQiGSOUMlVDSwJxdvq+eVev9blIYf5Y
WXi/t4tbMzgCkzRSiHqg2J+PWCroXRr/EDV2twdmgLgaTn9lyaGPT63M+2yKrbdv
5wvMbYb+x2homC2tACt3VNtwnJkp2KVEpkSEul5ueWV7iAtZlIseI4CzJwH1tL7N
/8EtRQSQ+so/LxaO4SKWNar5xiZ/8hZDMCHZOLTCk4/uySLpXEgLYjJ0CrEM+bY=
=jifr
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Aug_2011_01_51_11_+1000_JCnHzThTL=VHpIl.--
