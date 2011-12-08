Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab1LHPZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 10:25:23 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:47364 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab1LHPZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 10:25:22 -0500
Date: Thu, 8 Dec 2011 10:25:20 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Avi Kivity <avi@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, arnd@arndb.de, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, mtosatti@redhat.com,
        jeremy.fitzhardinge@citrix.com, levinsasha928@gmail.com,
        Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5 V5] Add ioctl for KVMCLOCK_GUEST_STOPPED
Message-ID: <20111208152520.GC6301@mgebm.net>
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
 <1323116344-17911-4-git-send-email-emunson@mgebm.net>
 <4EDF7960.4080104@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5G06lTa6Jq83wMTw"
Content-Disposition: inline
In-Reply-To: <4EDF7960.4080104@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5G06lTa6Jq83wMTw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 07 Dec 2011, Avi Kivity wrote:

> On 12/05/2011 10:19 PM, Eric B Munson wrote:
> > Now that we have a flag that will tell the guest it was suspended, crea=
te an
> > interface for that communication using a KVM ioctl.
> >
> > @@ -3295,6 +3295,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> > =20
> >  		goto out;
> >  	}
> > +	case KVMCLOCK_GUEST_PAUSED: {
> > +		r =3D kvm_set_guest_paused(vcpu);
> > +		break;
> > +	}
> >  	default:
> >  		r =3D -EINVAL;
> >  	}
> >
>=20
> You could also do this purely from userspace by reading the kvmclock msr
> and updating it.  However, it's better to do this in the kernel to avoid
> distributing responsibility for kvmclock across too many cooks.
>=20
> --=20
> error compiling committee.c: too many arguments to function
>=20

As stated in the cover letter, per Marcelo's suggestion I already tried this
method and it resulted in the guest wall clock skewing by the amount of time
the guest was suspended.  This places a new burden on the guest to be runni=
ng
ntpd or equivslent to keep the wall clock correct.

Eric

--5G06lTa6Jq83wMTw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO4NbgAAoJEKhG9nGc1bpJTdgP/j0p4hzJlJtn7ONEFj84g3Bk
45Q1j4Q67OgXjC8HVXEqLcQrDJe2wCbLGtHpFa7sd5mYIbN0Ji+jdv4+OiwXgx8B
TTfF80lu4THb1QR2O9Clg+XsC1MX6PN5/iCZ27kFRlTW5LFl0yL36+VbUctCVH6C
qPM+tKHm6bic6f8NV98BSVHft1IB0dRrigxrq9ohRsLC4uDh6FDY1QPUOiO4Rc/S
AUewspKIIdHpWdClWrWlVMytMVt9agjK4UDKsTxwjE95FG1ofUsm4xMxrWE8sN01
uwF/9ApzEfilHQ+DD0AjcdWbICGbd6uMCz3PilY9aBRRfD8JxCXf2qrscOwK5Bkh
izMzoloqsLlE++EUGmXvXRTTuFvUoVf7IDgqhQ7r4ZwhrpNNnv4XSUSsQ2JAoaCx
jZFr6UEq4+52ivbdhITuk6qKZlQ/Pj1AIa3KcrqlvfnnABPYGvkLmTJDLOlrGAkT
SPV2zGsXwekF9ks5/92xLnK2JdGQWNXwGouTsDv4lYIkdTNYGGgrzkZ1pV66bLDk
CiTiuw2FxRI9fXmVKog1mt3rVEYfuIyjkX2MAH5IcwEX3b80uZ5QajyTUiS28Z0A
JmcDzJ2H5eds93WSThuSb5hz5H34aKLW0So9B/WHOwBNAA0uLYtlPQfzH3VNpoBV
AkkE5UHaCd+gmzyr6KD8
=t7mf
-----END PGP SIGNATURE-----

--5G06lTa6Jq83wMTw--
