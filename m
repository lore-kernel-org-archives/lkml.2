Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab1LARWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 12:22:47 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:49176 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab1LARWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 12:22:46 -0500
Date: Thu, 1 Dec 2011 12:22:44 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: qemu-devel@nongnu.org, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        kvm@vger.kernel.org, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        avi@redhat.com
Subject: Re: [PATCH] Guest stop notification
Message-ID: <20111201172244.GB8803@mgebm.net>
References: <1322602574-27072-1-git-send-email-emunson@mgebm.net>
 <4ED79138.60603@siemens.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline
In-Reply-To: <4ED79138.60603@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vGgW1X5XWziG23Ko
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
>=20
> More general:
>=20
> Why is this x86-only? If the kernel interface is x86-only, what prevents
> making it generic right from the beginning?

Sorry, missed this question on the first pass, this is x86 only because the
flag used lives in the pvclock structure.  AFAICT, there aren't any other
architectures out there that implement paravirtualized clocks yet.

>=20
> Why do we need a new IOCTL for this? Was there no space left in the
> kvm_run structure e.g. to pass this flag down on next vcpu execution? No
> big deal, just wondering.
>=20
> Jan
>=20
> --=20
> Siemens AG, Corporate Technology, CT T DE IT 1
> Corporate Competence Center Embedded Linux
>=20

--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO17fkAAoJEKhG9nGc1bpJ1+wP/3iKJJ9MhmlT+3Rf6RjWfvZw
nGR7f279ONebTdoQBkqg5Qcm/eW6W2Edm3i7cjezHLi8SHgSjXAKIjFr2yT9pt5o
8rkYpXWIyfKXKcJV9bJ/kkZg3tkadPUOytS2q+INjQqSULleDffSmWApeEdMPaGA
aejK0xQt3GCjevOMDUwpKp7v9SYYpj2z9dJzz7Cyu7mtU4blLcvABNiw9BWM470W
eb8dTSVAzFQHLBLS75ulW9ymPrIc+G95RxTjANxg65K2hl03UOgP8WoWHJ1szAKn
i5M9Yf0R80uMeBNPlj5GftIi0ENR4XqHyf0NM5/+a3dbcJ8aYDgBJtXtKeo6iTEN
aHVMStSE55UFniqlnguBIqWAHtxg3jnfRwGbWIzuabvhiLqF9J5kAkAjYvi9odtl
WItrqwf/PGH8m+FgPQyhKVm2EXD+CvNX0j2edC5MLygozCkYqB7iY5TUxMLhj12m
J9xjWO49xGqvj2EGHqBFG3An10qtyzXqYVsrLb9m6W47rvwNnJnvfiOJp/mirX6Z
i3pIDVQJSnQWPNoY/BUy+4gTdfawaLc4jJP91+8wtPqbRAku7nK9l64zq3jPvwbr
D92ytsvhfueDZo3du6wKtp0T3wfy/50Hf5UZMXDLGOaZBc4ELc+kHwO//L7i4evR
gtI+iycU/r9QiMNRi+U0
=7w4R
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--
