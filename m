Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab1DNUxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:53:10 -0400
Received: from ulysses.noc.ntua.gr ([147.102.222.230]:60185 "EHLO
	ulysses.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1DNUxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:53:08 -0400
Message-ID: <4DA75EA9.4050602@ece.ntua.gr>
Date: Thu, 14 Apr 2011 23:52:57 +0300
From: Stratos Psomadakis <psomas@ece.ntua.gr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110407 Lightning/1.0b3pre Lanikai/3.1.9
MIME-Version: 1.0
To: "guilherme m. schroeder" <guilherme.m.schroeder@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] 2.6.32.36 - Linux Xen DomU doesn't boot anymore
References: <BANLkTim-KC7qfijD5rFNTR98GSs=cTPzJw@mail.gmail.com>
In-Reply-To: <BANLkTim-KC7qfijD5rFNTR98GSs=cTPzJw@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD6D09477AA3CB7C457561A7E"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (ulysses.noc.ntua.gr [147.102.222.230]); Thu, 14 Apr 2011 23:53:04 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD6D09477AA3CB7C457561A7E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/14/2011 11:35 PM, guilherme m. schroeder wrote:
> Hi,
>
> Linux Kernel 2.6.32.36 introduced a regression that prevents Linux Xen
> DomU from booting.
> Linux DomU starts and after a while it shutdown without log messages.
>
> I bisected a vanilla kernel from 2.6.32.36 (bad) to 2.6.32.32 (good)
> and got this commit:
>
> vm:~/linux-2.6.32.y# git bisect bad
> 856460aa905dcc6d11a05a832d487a7b0ce69402 is the first bad commit
> commit 856460aa905dcc6d11a05a832d487a7b0ce69402
> Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Date:   Fri Feb 18 11:32:40 2011 +0000
>
>     xen: set max_pfn_mapped to the last pfn mapped
>
>     commit 14988a4d350ce3b41ecad4f63c4f44c56f5ae34d upstream.
>
>     Do not set max_pfn_mapped to the end of the initial memory mappings=
,
>     that also contain pages that don't belong in pfn space (like the mf=
n
>     list).
>
>     Set max_pfn_mapped to the last real pfn mapped in the initial memor=
y
>     mappings that is the pfn backing _end.
>
>     Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com=
>
>     Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>     LKML-Reference: <alpine.DEB.2.00.1103171739050.3382@kaball-desktop>=

>     Signed-off-by: H. Peter Anvin <hpa@zytor.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> :040000 040000 a679f50b64c290b9a51e3dba8d3d648bca50fdf0
> e7b018c4e0015aae44ed6f9f6323d8b13d032b86 M	arch
>
> I have tested against XCP 1.0, Citrix XenServer 5.6 and 5.6 FP1.
> Without this patch, Linux DomU boots and runs fine.
> If more info is needed, please let me know.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
Can you try 2.6.32.37-rc1?
The patch you're referring to was committed I think along with another
patch which caused some trouble in the -stable trees(I'm not surea bout
that though :/).
And in 2.6.32.37-rc1 it was reverted:
[59/74] [PATCH] Revert "x86: Cleanup highmap after brk is concluded"
Maybe it fixes your problem.

--=20
Stratos Psomadakis
<psomas@ece.ntua.gr>



--------------enigD6D09477AA3CB7C457561A7E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk2nXq8ACgkQid1lVeNDMmC5lACbBo85rIAAENMQhDkKx0WNBUFT
ioAAnA/alVdXqhd5mZc94Vrl1dC0QmuR
=wsb1
-----END PGP SIGNATURE-----

--------------enigD6D09477AA3CB7C457561A7E--
