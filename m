Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab0HVG6F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 02:58:05 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:61299 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324Ab0HVG6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 02:58:03 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>
	 <1282391770.29609.1223.camel@localhost.localdomain>
	 <AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-T3Xkvl3QG9a9fEztHUaH"
Date: Sun, 22 Aug 2010 07:57:55 +0100
Message-ID: <1282460275.11348.865.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-SA-Exim-Connect-IP: 192.168.1.7
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [RFC] mlock/stack guard interaction fixup
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=DhNl2YeytwJssBBGe49HJX82LNDFEEVkpVB34RXKaPo= c=1 sm=0 a=zI1UDiXOKOEA:10 a=AZfGcq7nAAAA:8 a=OSpZ0MEeTUaKo3tTqXQA:9 a=xbsxHZFmEnnMtq90GKi7DCV4L1EA:4 a=wPNLvfGTeEIA:10 a=ScVlBsGyvHMgLEs0-ioA:9 a=Yxnqrku4_SOSknXeQIHuHZvez_8A:4 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-T3Xkvl3QG9a9fEztHUaH
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-08-21 at 08:48 -0700, Linus Torvalds wrote:
> On Sat, Aug 21, 2010 at 4:56 AM, Ian Campbell <ijc@hellion.org.uk> wrote:
> >
> > I don't know that they are particularly good tests for this change but =
I
> > also ran allmodconfig kernel build and ltp on 2.6.35.3+fixes without
> > issue. Are there any good mlock heavy workloads?
>=20
> mlock itself isn't very interesting, I think more interesting is
> testing that the doubly linked list handles all the cases correctly.
> Something that splits mappings, unmaps partial ones etc etc. Running
> something like Electric Fence is probably a good idea.

EF_DISABLE_BANNER=3D1 EF_ALLOW_MALLOC_0=3D1 LD_PRELOAD=3Dlibefence.so.0.0 m=
ake

craps out pretty quickly with:

          CC      init/main.o
       =20
        ElectricFence Exiting: mprotect() failed: Cannot allocate memory
        make[1]: *** [init/main.o] Error 255
        make: *** [init] Error 2

but it does that with 2.6.35.3, 2.6.35.2, 2.6.35.1 and 2.6.35 too so it
doesn't seem to be breakage relating to any of the stack guard stuff

>=20
> The happy news is that we really didn't have lots of assignments to
> vma->vm_next - they were all pretty cleanly separated into just a
> couple of cases. So I'm pretty confident in the patches. But...
>=20
> > Out of interest, why is there no guard page for the VM_GROWSUP stack
> > case? Is it just that the memory layout on PA-RISC makes the stack grow=
s
> > into the heap scenario impossible?
>=20
> No, it's just that I can't find it in myself to care about PA-RISC, so
> I never wrote the code. I don't think anything else has a grows-up
> stack. And even if I were to write the code, I couldn't even test it.
>=20
> It should be reasonably easy to do the VM_GROWSUP case too, but
> somebody with a PA-RISC would need to do it.
>=20
>                          Linus
>=20

--=20
Ian Campbell

Everybody is going somewhere!!  It's probably a garage sale or a
disaster Movie!!

--=-T3Xkvl3QG9a9fEztHUaH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkxwynMACgkQM0+0qS9rzVmTrgCglFLSWDpWrynk8VBsaro/exiH
jy8AoIrHTxP2UWWDC3Y7JRLoS+zfygs6
=3R9S
-----END PGP SIGNATURE-----

--=-T3Xkvl3QG9a9fEztHUaH--

