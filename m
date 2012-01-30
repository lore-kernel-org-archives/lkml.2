Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab2A3Pct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:32:49 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:47631 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916Ab2A3Pcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:32:46 -0500
Date: Mon, 30 Jan 2012 10:32:44 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Avi Kivity <avi@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, mtosatti@redhat.com,
        jeremy.fitzhardinge@citrix.com, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 V10] Add ioctl for KVMCLOCK_GUEST_STOPPED
Message-ID: <20120130153244.GA6875@mgebm.net>
References: <1326825641-15765-1-git-send-email-emunson@mgebm.net>
 <1326825641-15765-4-git-send-email-emunson@mgebm.net>
 <4F26B220.9050101@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <4F26B220.9050101@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Jan 2012, Avi Kivity wrote:

> On 01/17/2012 08:40 PM, Eric B Munson wrote:
> > Now that we have a flag that will tell the guest it was suspended, crea=
te an
> > interface for that communication using a KVM ioctl.
> >
> >
> > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/=
kvm/api.txt
> > index e1d94bf..1931e5c 100644
> > --- a/Documentation/virtual/kvm/api.txt
> > +++ b/Documentation/virtual/kvm/api.txt
> > @@ -1491,6 +1491,19 @@ following algorithm:
> >  Some guests configure the LINT1 NMI input to cause a panic, aiding in
> >  debugging.
> > =20
> > +4.65 KVMCLOCK_GUEST_PAUSED
> > +
> > +Capability: KVM_CAP_GUEST_PAUSED
> > +Architechtures: Any that implement pvclocks (currently x86 only)
> > +Type: vcpu ioctl
>=20
> vm ioctl.
>=20
> > +Parameters: None
> > +Returns: 0 on success, -1 on error
> > +
> > +This signals to the host kernel that the specified guest is being paus=
ed by
> > +userspace.  The host will set a flag in the pvclock structure that is =
checked
> > +from the soft lockup watchdog.  This ioctl can be called during pause =
or
> > +unpause.
> > +
> >  5. The kvm_run structure
> > =20
> > =20
> > +/*
> > + * kvm_set_guest_paused() indicates to the guest kernel that it has be=
en
> > + * stopped by the hypervisor.  This function will be called from the h=
ost only.
> > + */
> > +static int kvm_set_guest_paused(struct kvm *kvm)
> > +{
> > +	struct kvm_vcpu *vcpu;
> > +	struct pvclock_vcpu_time_info *src;
> > +	int i;
> > +
> > +	kvm_for_each_vcpu(i, vcpu, kvm) {
> > +		if (!vcpu->arch.time_page)
> > +			continue;
> > +		src =3D &vcpu->arch.hv_clock;
> > +		src->flags |=3D PVCLOCK_GUEST_STOPPED;
>=20
> This looks racy.  The vcpu can remove its kvmclock concurrently with
> this access, and src will be NULL.
>=20
> Can you point me to the discussion that moved this to be a vm ioctl?  In
> general vm ioctls that do things for all vcpus are racy, like here.=20
> You're accessing variables that are protected by the vcpu mutex, and not
> taking the mutex (nor can you, since it is held while the guest is
> running, unlike most kernel mutexes).
>=20

Jan Kiszka suggested that becuase there isn't a use case for notifying
individual vcpus (can vcpu's be paused individually?) that it makes more se=
nse
to have a vm ioctl.

http://thread.gmane.org/gmane.comp.emulators.qemu/131624

If the per vcpu ioctl is the right choice I can resend those patches.

Eric

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJrgcAAoJEKhG9nGc1bpJyVEQAJHHn57M5QSSstQ7A9UrMeHQ
DmnLzGLhT08AbkD0oWi8TH9b0jFXI4WYqzwCGVQc/IcpqRlliWrEa8/bc4Wti4Fk
lP57iRE0ZtZNxOdIfM6rPjeqo1o1sWWs91phNs6R2OVLqHwp5Kh2gQ/c8oQv9XNm
nxK24PgoiudBEZ19TXp9X9X6GM24rLOmd22RqI2ROGPFoqC0H63LMNhZ/lFZwy3S
dTkKGLObPGzta6oKGxdOFG+2wAnd60qdk0My22inxOSqryU8RDpKxfnAOSdb35uP
XkVkxC2E7sBDXqu+/V76ap47NhuP8sZy8Vuo7Cvq6XkadOwwbR8sgZL5SijeoeiL
21ERrwD0SHae3dnoik2npXHGrfp25TYwxHjKllJEJ8g6nVuviq6ttFXMWzrwETNl
f9HFimzP9QoWAZS8XTH5NAvOWWbwBgVRrQwviCJAUDBB1u/7xhb46JiWoWlVg5Ok
o4lT+U3JDBtVVFYUeqlvWVOYmH0bFNAtoUN3MzhiLGBCzteUDRd5K2buM004InT5
bbSLPEkpo4ksRWKnCJA00RBa04GmcUqe5M3MSqHTaHws1jNZ0G4JW5tELCrFAAEM
2ilR2xgYytcxLVBq86EMOy6u2sS1Ywve06xh2qfgqs/rebKQ4r36+PDzqXSkFh+M
m9VzBTjwzEWbNp2LQfEM
=JGIh
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
