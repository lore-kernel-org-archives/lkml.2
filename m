Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab1LHPTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 10:19:35 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:47302 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab1LHPTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 10:19:32 -0500
Date: Thu, 8 Dec 2011 10:19:30 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Avi Kivity <avi@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, arnd@arndb.de, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, mtosatti@redhat.com,
        jeremy.fitzhardinge@citrix.com, levinsasha928@gmail.com,
        Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5 V5] Avoid soft lockup message when KVM is stopped by
 host
Message-ID: <20111208151929.GA6301@mgebm.net>
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
 <4EDF7B0D.4060001@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <4EDF7B0D.4060001@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 07 Dec 2011, Avi Kivity wrote:

> On 12/05/2011 10:18 PM, Eric B Munson wrote:
> > Changes from V4:
> > Rename KVM_GUEST_PAUSED to KVMCLOCK_GUEST_PAUSED
> > Add description of KVMCLOCK_GUEST_PAUSED ioctl to api.txt
> >
> > Changes from V3:
> > Include CC's on patch 3
> > Drop clear flag ioctl and have the watchdog clear the flag when it is r=
eset
> >
> > Changes from V2:
> > A new kvm functions defined in kvm_para.h, the only change to pvclock i=
s the
> > initial flag definition
> >
> > Changes from V1:
> > (Thanks Marcelo)
> > Host code has all been moved to arch/x86/kvm/x86.c
> > KVM_PAUSE_GUEST was renamed to KVM_GUEST_PAUSED
> >
> > When a guest kernel is stopped by the host hypervisor it can look like =
a soft
> > lockup to the guest kernel.  This false warning can mask later soft loc=
kup
> > warnings which may be real.  This patch series adds a method for a host
> > hypervisor to communicate to a guest kernel that it is being stopped.  =
The
> > final patch in the series has the watchdog check this flag when it goes=
 to
> > issue a soft lockup warning and skip the warning if the guest knows it =
was
> > stopped.
> >
> > It was attempted to solve this in Qemu, but the side effects of saving =
and
> > restoring the clock and tsc for each vcpu put the wall clock of the gue=
st behind
> > by the amount of time of the pause.  This forces a guest to have ntp ru=
nning
> > in order to keep the wall clock accurate.
>=20
> Having this controlled from userspace means it doesn't work for SIGSTOP
> or for long scheduling delays.  What about doing this automatically
> based on preempt notifiers?
>=20
>=20
> --=20
> error compiling committee.c: too many arguments to function
>=20
My concern for preempt notifiers is masking real soft lockup warnings.  If =
the
flag is set every time the vm is preempted, it becomes more likely that we =
will
mask real warnings.  The ioctl was choosen because it sets the flag only wh=
en
the guest is being paused deliberately.

AFAIK, SIGSTOP is not a supported way to stop a qemu vm so a soft lockup
warning would be working as designed there.  If that isn't the case, or if =
it
ever changes, we could always install a signal handler for SIGCONT that set=
 the
flag before resuming the vm.

Scheduling delays are also beyond the scope of this problem and I see the s=
oft
lockup warning as appropriate in that case.

Eric

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO4NWBAAoJEKhG9nGc1bpJYPsP/2QzM1Ob9cU60lZkXO81ZtX3
FMKGoBaUQvFsdzO4P7hGkoX80dSMO6GroQRFTsoriabcm2L2FTHSvqschSOgvv50
kwwJHJgR5jnnblPvtbgyfw5zyxx4v5x2ET4zxhA9ShXBD4Ka0ua/OpUPGSoj8JnA
h69D4eNz+EkJMyM3ZznlHtuNEgF1ajewBPCWNls9P840blA07u1RZGOXlEt9ZRCz
1CnKDyhuSoRuZpwVIYY7UnvZ+A5eMvf/mTblIzuBgBISAVeXJBwhOEIpz+cF5TrY
VK3g2pYaTnUTEVRUb2896z9AphhtLydbbSNoTT4nYYB5SViFFg0zfpVHKoFYhtjX
x6MSMuoMFh+4Nf2MAncRcZ6ZFExm5sVuO71VsqxYLM87+l6/Zo+TB7z0U5BKvGqO
ubKa2SjaGS3opVsK1u4BOU+yuz8i8nC0kNGEQ8E7qViaVjPX8GldmRqWaSQt3n39
L5TtaMedur+OyMmtUbda1tCuv/A7ULbbcYZ6BnmpOWRs4AMUrWbc6GkAIJNwAvf4
sRexuJfLfzyjz6eSHgHERr1du0t7N4KH+2b3ISYTJK0LHPCxD2guyd5D8PTg8eeG
K3dFees43Gl2SZkrYfd5ocVALQS5bFpNP4un9AdlhFYXxvoKO2kqeW7yXHEgRLen
BMxV3H096hv7ff87YYvY
=wxU+
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
