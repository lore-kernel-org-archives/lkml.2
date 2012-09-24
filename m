Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2IXFCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 01:02:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab2IXFCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 01:02:50 -0400
Date: Mon, 24 Sep 2012 15:02:39 +1000
From: NeilBrown <neilb@suse.de>
To: "Fox, Kevin M" <kevin.fox@pnnl.gov>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Conditional Unlink
Message-ID: <20120924150239.1d87b868@notabene.brown>
In-Reply-To: <81A22C12505EF7419E792D791BC28B3C0104E178E598@EMAIL05.pnl.gov>
References: <81A22C12505EF7419E792D791BC28B3C0104E178E598@EMAIL05.pnl.gov>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/noc17H=cdryD=ApYgwTchi5"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/noc17H=cdryD=ApYgwTchi5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Sep 2012 10:32:36 -0700 "Fox, Kevin M" <kevin.fox@pnnl.gov> wrot=
e:

> Quick question:
> Is there a syscall or some algorithm that would allow an unlink that woul=
d only happen if no writes to the file have occurred between a stat and an =
unlink, race free?
>=20
> Background:
> I'm writing a program that sync's files up to a server. I would like to u=
nlink the files that have successfully been uploaded. There is a race thoug=
h. If the file changed after uploading but before the unlink (I do not cont=
rol who can write to the files), the next upload should take care of things=
 and the unlink should fail. Otherwise, data could be lost!

Probably your best bet is to rename the file in there.
 mv file file.tmp
 sleep 5
 cp file.tmp $server/file
 rm file.tmp

The "sleep 5" might not work for you, one would need to know more about tot=
al
context.

Is any locking done when writing to the file, or will there only ever be one
writer?

NeilBrown

--Sig_/noc17H=cdryD=ApYgwTchi5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUF/pbznsnt1WYoG5AQL1Rg//TTKEnVaEI8JemFiCEEUMGiC/4V1m7gmw
QTk74KNVt84wrN+fjyiR/gkdx7/0/In1C5KmTUqh10zMpwmzWKEkO81HgSN95w9A
LG7V+EkrPTwkJjrqSIRoul7YS4myfa1zD+lptnuyAUdXpr6WYhP/SPi0KQbTAZgL
moU6btrUuHa/nuJhgYsn9NWB9tmZNavV8ouIDCxysbsmNIQk6yU7cKlMhPgYb2hY
Vh3/V3yA2RVB2m0ujwI1OUJivPaJfTBXkPJ4Kjj1BB93ITY7bv0iltP5FkDu6eJ+
RV7l1N+jy6smj7A8XmMyq6vSJDsHB2CtqKb9ovuyav3gfP+OsrNMj9UCvY2z3XOD
Z19QXB9IfaGVXsDmoYh4Sln0NyP0Iy2wGw5Bz8v9f57fsgb1t/h5oLMNqfbvJDtj
03oOlDI7gE0JQh0tXYSmrWFf714cWTJLBJ8PqgUhT+yT7VTCLZZG2kKflVGLUS8s
1vr9qqjhd6NRT+1NH28m4KyPQ54NQGUfvkUdfZnLeKB8Q0TIeJnxLVF262Yk0mex
dBUcy1yC3e+jPegy9T5UHfggiFiLoO/hWJATYX5lPod1HxSAUiip4nu0QfriV4WF
OKw4NAr4KBeYjKkhqyOlUHwz3dFkfEReLEtpjpQoQEBKT5jTINPrpjMGhBCPUjON
HQ261yVRJBM=
=/a1N
-----END PGP SIGNATURE-----

--Sig_/noc17H=cdryD=ApYgwTchi5--
