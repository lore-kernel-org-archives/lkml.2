Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab0HVJzd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 05:55:33 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:12627 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752072Ab0HVJza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 05:55:30 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <1282462386.11348.871.camel@localhost.localdomain>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>
	 <1282391770.29609.1223.camel@localhost.localdomain>
	 <AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>
	 <1282460275.11348.865.camel@localhost.localdomain>
	 <1282462386.11348.871.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tDgZIHsCRsJQ1VJj5MYC"
Date: Sun, 22 Aug 2010 10:55:17 +0100
Message-ID: <1282470917.11348.891.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-SA-Exim-Connect-IP: 192.168.1.7
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [RFC] mlock/stack guard interaction fixup
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=3ENABmdyEd/Fm7fR7+mZIuMDn6+IErAeEhlfWBImZFk= c=1 sm=0 a=zI1UDiXOKOEA:10 a=AZfGcq7nAAAA:8 a=l5kpwdHSGzsEldz0Ns0A:9 a=RINjQzA_XDdnbT0cB98mxFfvVvMA:4 a=wPNLvfGTeEIA:10 a=EjDXTxwXOwrGdlRPU_kA:9 a=XZfkEyxw9pfOT282qbyg7SX6tJsA:4 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tDgZIHsCRsJQ1VJj5MYC
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-08-22 at 08:33 +0100, Ian Campbell wrote:
> On Sun, 2010-08-22 at 07:57 +0100, Ian Campbell wrote:
> > On Sat, 2010-08-21 at 08:48 -0700, Linus Torvalds wrote:
> > > On Sat, Aug 21, 2010 at 4:56 AM, Ian Campbell <ijc@hellion.org.uk> wr=
ote:
> > > >
> > > > I don't know that they are particularly good tests for this change =
but I
> > > > also ran allmodconfig kernel build and ltp on 2.6.35.3+fixes withou=
t
> > > > issue. Are there any good mlock heavy workloads?
> > >=20
> > > mlock itself isn't very interesting, I think more interesting is
> > > testing that the doubly linked list handles all the cases correctly.
> > > Something that splits mappings, unmaps partial ones etc etc. Running
> > > something like Electric Fence is probably a good idea.
> >=20
> > EF_DISABLE_BANNER=3D1 EF_ALLOW_MALLOC_0=3D1 LD_PRELOAD=3Dlibefence.so.0=
.0 make
> >=20
> > craps out pretty quickly with:
> >=20
> >           CC      init/main.o
> >        =20
> >         ElectricFence Exiting: mprotect() failed: Cannot allocate memor=
y
> >         make[1]: *** [init/main.o] Error 255
> >         make: *** [init] Error 2
> >=20
> > but it does that with 2.6.35.3, 2.6.35.2, 2.6.35.1 and 2.6.35 too so it
> > doesn't seem to be breakage relating to any of the stack guard stuff
>=20
> I increased the vm.max_map_count sysctl and now things are rolling
> along. Will let you know how I get on.

So its slow and memory intensive as hell due to efence so my test box is
struggling[0] but it has compiled 270+ .o files successfully so I think
it's OK from that perspective. I think it'll be quite a while before I
can say its passed an allmodconfig under efence though.

In the meantime I notice you've committed the patches. Can we get them
queued up for stable backports at some point? I appreciate you might
want them to bake for a bit longer in 2.6.36-rc first.

Greg, we are talking about:
0e8e50e20c837eeec8323bba7dcd25fe5479194c mm: make stack guard page logic us=
e vm_prev pointer
7798330ac8114c731cfab83e634c6ecedaa233d7 mm: make the mlock() stack guard p=
age checks stricter
297c5eee372478fc32fec5fe8eed711eedb13f3d mm: make the vma list be doubly li=
nked

Cheers,
Ian.

[0] It's a 4G x 4 core box which normally does -j16 builds with no swap.
Now a -j4 will send it deep into the 16G of swap I added this morning,
and even a -j3 is a bit tight. I knew efence was resource intensive but
this still surprised me.

--=20
Ian Campbell

Who does not love wine, women, and song,
Remains a fool his whole life long.
		-- Johann Heinrich Voss

--=-tDgZIHsCRsJQ1VJj5MYC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkxw9AUACgkQM0+0qS9rzVkYmQCdGVqT1Lm42Vk6YcGgljR7Hyp5
b4IAoNyg2ocKo9AH1/YmpJHUOcu2EC5E
=lUdW
-----END PGP SIGNATURE-----

--=-tDgZIHsCRsJQ1VJj5MYC--

