Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab2HQW7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 18:59:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755934Ab2HQW6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 18:58:55 -0400
Date: Sat, 18 Aug 2012 08:58:43 +1000
From: NeilBrown <neilb@suse.de>
To: John Drescher <drescherjm@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
Subject: Re: mdraid6 problem post 3.5.0
Message-ID: <20120818085843.54b231ed@notabene.brown>
In-Reply-To: <CAEhu1-4gv=uAu7K=O6DqeXr05frD4_Yp+0VnRuF_n8mnbaqF6w@mail.gmail.com>
References: <CAEhu1-4gv=uAu7K=O6DqeXr05frD4_Yp+0VnRuF_n8mnbaqF6w@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2eMa55FtH7IYkFk5wD9BzL6"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2eMa55FtH7IYkFk5wD9BzL6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Aug 2012 18:30:11 -0400 John Drescher <drescherjm@gmail.com> wro=
te:

> For the last few weeks I have been doing some reliability testing on a
>  mdraid6 array. One of my test was to physically hot remove a raid
> member disk. This worked flawlessly with gentoo-sources-3.5.0 for the
> 5 or so times I tried it with my 12 disk + 1 spare mdraid6 array.
> After pulling a disk a few seconds later the array automatically
> rebuilds with a spare and after finishing all data checks out via
> btrfs a scrub. However trying this with gentoo-sources-3.5.2 or the
> latest kernel.org git sources the machine does not start the rebuild
> and any access to /proc/mdstat or and disk access that is not in cache
> for that array just leads to an a long (possibly infinite) wait
> eventually forcing me to have to use the reset button when the sysrq
> key combinations fail to shut down the machine. I do see some kernel
> debug message in the console alt-ctrl-f12 but I was unable to save
> that to copy.
>=20
> Is this a known problem? If not it may be possible that I could bisect
> this next week to the patch that causes this behavior.
>=20

Thanks for the report.

The problem is not known to me..  There are no changes to raid6 between 3.5=
.0
and 3.5.2, so unless gentoo broke something (unlikely) this is very strange.

A digital-photo of the debug messages might be useful if you can catch that.
Setting up a network console to capture messages isn't too hard if you have
another machine with a wired network connection.
See Documentation/networking/netconsole.txt
If you can set that us, then alt-sysrq-T might provide useful info.


NeilBrown

--Sig_/2eMa55FtH7IYkFk5wD9BzL6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUC7Moznsnt1WYoG5AQLSGQ/+PwJEnpw10Aw9Hhmk1GSchdNWeAIvt6sE
ivCXZJEZOVGFBwXKTPSjPvyhtO4KRT0sezgjYvxhRj69CVErkVV5Ynri/ruFgYlD
iJjIaqdRkbIQU2r+iNUIUOOM6rECvDdDu8ONHYibrZloDWsfALxjBqBJ+XSLvy92
hi0WfBsC2xXu8+/+qqwmlWSRvhU0jhmpbc6/gDYjhvvmd6/idxoLd2lINFWVdhez
0RhGH1Cr7fi87fTBmXEadfTCXsJYuZ1NFv5TQt3kM0F4cNWopL2ld6v+UXK76os/
SuS92i1D6F34BdV6R2QQjezAbIawnVYd40Ut2m2FoblUCAL5VSZG47Lbo0wEONKm
jvAq8EQBgFxspkkU2+93G1zRVpTJZEnqo3M52K0jM54bKuP+cVcndVQa8bvBTNfa
cEyCXEdgI2xyIJvHjI/k168Nrjri5FLOMk4hYz9meNGS2eEUOQVXVV6qDNAp9/zq
oi2bOy1ShoGt9g22zSkaRLp2Mj7gZQ7sMT29AOv9bsoQHAwj45N+OBsoE978p3Qt
x1V9wklV0qLB20kHfv+iLUjRPok5cBIZkjfcuoMO3K4NJ7lzx/zCNj5CWyYAlpAz
3KNIcGpqJYt0rTl7DLcK3q9/0DoI9qpg9WuTSP+rZo5ul9Ge93XXPgLol9d62p19
/Zo4ZLdrnnw=
=qQMs
-----END PGP SIGNATURE-----

--Sig_/2eMa55FtH7IYkFk5wD9BzL6--
