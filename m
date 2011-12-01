Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab1LARTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 12:19:43 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:49147 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab1LARTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 12:19:41 -0500
Date: Thu, 1 Dec 2011 12:19:38 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: qemu-devel@nongnu.org, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        kvm@vger.kernel.org, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        avi@redhat.com
Subject: Re: [PATCH] Guest stop notification
Message-ID: <20111201171938.GA8803@mgebm.net>
References: <1322602574-27072-1-git-send-email-emunson@mgebm.net>
 <4ED79138.60603@siemens.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <4ED79138.60603@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 01 Dec 2011, Jan Kiszka wrote:

> On 2011-11-29 22:36, Eric B Munson wrote:
> > Often when a guest is stopped from the qemu console, it will report spu=
rious
> > soft lockup warnings on resume.  There are kernel patches being discuss=
ed that
> > will give the host the ability to tell the guest that it is being stopp=
ed and
> > should ignore the soft lockup warning that generates.
> >=20
> > Signed-off-by: Eric B Munson <emunson@mgebm.net>
> > Cc: ryanh@linux.vnet.ibm.com
> > Cc: aliguori@us.ibm.com
> > Cc: mtosatti@redhat.com
> > Cc: avi@redhat.com
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  target-i386/kvm.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/target-i386/kvm.c b/target-i386/kvm.c
> > index 5bfc21f..defd364 100644
> > --- a/target-i386/kvm.c
> > +++ b/target-i386/kvm.c
> > @@ -336,12 +336,18 @@ static int kvm_inject_mce_oldstyle(CPUState *env)
> >      return 0;
> >  }
> > =20
> > +static void kvm_put_guest_paused(CPUState *penv)
> > +{
> > +    kvm_vcpu_ioctl(penv, KVM_GUEST_PAUSED, 0);
> > +}
>=20
> I see no need in encapsulating this in a separate function.
>=20

The encapsulated function was from a previous idea, I will remove it for V2.

> > +
> >  static void cpu_update_state(void *opaque, int running, RunState state)
> >  {
> >      CPUState *env =3D opaque;
> > =20
> >      if (running) {
> >          env->tsc_valid =3D false;
> > +	kvm_put_guest_paused(env);
>=20
> checkpatch.pl would have asked you to remove this tab.

Will change to spaces for V2.

>=20
> More general:
>=20
> Why is this x86-only? If the kernel interface is x86-only, what prevents
> making it generic right from the beginning?
>=20
> Why do we need a new IOCTL for this? Was there no space left in the
> kvm_run structure e.g. to pass this flag down on next vcpu execution? No
> big deal, just wondering.

Thanks for your review/feedback.

When I started looking into this problem, the ioctl was the first suggestio=
n I
got for how to communicate from qemu to guest kernel.  I don't see a techni=
cal
reason that this could not be added to the kvm_run structure in one of the
bytes currently used as padding.  I would prefer to keep the ioctl because I
have the corresponding kernel patches out to work with this, however, if th=
ere
is a strong preference for using kvm_run, I can rework both sets.

Eric


--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO17cqAAoJEKhG9nGc1bpJ6/EP/1IZKXqpXvLpTSWc4blTkiYs
DEBfoe8k0JrlXT+k4bKdU/IkJdWjNf33X5ntTZnmV8/4MZ3u4XXLFeOqG/WFofjp
+7dmvam7zzskZTgOM5BCDO1s+SvTJrmXuu4x4wJpfXsJ6GxrAXk/2LK7IfGqF9S0
ebVA2VnzOIVbIUH4s6xM8y4TjIOrsdWRRh9Aeznayz/TyemDhf3IYnl5uqyqeDMY
/R1OraKAiS9WKOMquoyMXTBAPbNBAzFJka/VqozoKK/mh1mEipbFeD/EOvPq3TAH
MXkDbCg/O9REhxwqActHOoWmSW1wi9+Gpt028uB/kf+KNSFi2mrh7v8M1icdpcrI
ToVsIM2yILpviY/00XlT8/XXWPPcG4dzqbUcR/cf3N0f56pzDhDdzmnJZsTV9IDe
RYNEIxhoiYCS18PtRLXHS40cJoEh2a807P8Bl5e4Hw3Mf3uytL6E/63VrY58zV4V
DwQSv+snmye4wYI5g5FFqHzRsWSOq4CTY9u5cJDXAOXYHJ5v4wusbCIW+pvFHuXU
B6nyJNdPu7bBvAnhL1NKRMRWTX55LeVdcaflrdDjFmR4y9YjGRCDemWbEeVlcGtE
6y7N+ChPERHaemnvVDL5U+RCkzM4aBeX1OFv/16fP8y6TIdPTgYxH1ebHQ65clzM
KED2j8LY6IKV0D/luiv6
=E6Dy
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
