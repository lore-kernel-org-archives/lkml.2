Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab2A3Pd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:33:29 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:47651 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab2A3Pd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:33:27 -0500
Date: Mon, 30 Jan 2012 10:33:26 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Avi Kivity <avi@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, mtosatti@redhat.com,
        jeremy.fitzhardinge@citrix.com, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 V10] Add ioctl for KVMCLOCK_GUEST_STOPPED
Message-ID: <20120130153326.GB6875@mgebm.net>
References: <1326825641-15765-1-git-send-email-emunson@mgebm.net>
 <1326825641-15765-4-git-send-email-emunson@mgebm.net>
 <4F26B220.9050101@redhat.com>
 <4F26B31D.3070407@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <4F26B31D.3070407@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Jan 2012, Avi Kivity wrote:

> On 01/30/2012 05:07 PM, Avi Kivity wrote:
> > > +Parameters: None
> > > +Returns: 0 on success, -1 on error
> > > +
> > > +This signals to the host kernel that the specified guest is being pa=
used by
> > > +userspace.  The host will set a flag in the pvclock structure that i=
s checked
> > > +from the soft lockup watchdog.  This ioctl can be called during paus=
e or
> > > +unpause.
> > > +
> > >  5. The kvm_run structure
> > > =20
> > > =20
> > > +/*
> > > + * kvm_set_guest_paused() indicates to the guest kernel that it has =
been
> > > + * stopped by the hypervisor.  This function will be called from the=
 host only.
> > > + */
> > > +static int kvm_set_guest_paused(struct kvm *kvm)
> > > +{
> > > +	struct kvm_vcpu *vcpu;
> > > +	struct pvclock_vcpu_time_info *src;
> > > +	int i;
> > > +
> > > +	kvm_for_each_vcpu(i, vcpu, kvm) {
> > > +		if (!vcpu->arch.time_page)
> > > +			continue;
> > > +		src =3D &vcpu->arch.hv_clock;
> > > +		src->flags |=3D PVCLOCK_GUEST_STOPPED;
> >
> > This looks racy.  The vcpu can remove its kvmclock concurrently with
> > this access, and src will be NULL.
> >
> > Can you point me to the discussion that moved this to be a vm ioctl?  In
> > general vm ioctls that do things for all vcpus are racy, like here.=20
> > You're accessing variables that are protected by the vcpu mutex, and not
> > taking the mutex (nor can you, since it is held while the guest is
> > running, unlike most kernel mutexes).
> >
>=20
> Note, the standard way to fix this race is to
> kvm_make_request(KVM_REQ_KVMCLOCK_STOP) and kvm_vcpu_kick(vcpu), and do
> the update in vcpu_enter_guest().  But I think this is needless
> complexity and want to understand what motivated the move to a vm ioctl.
>=20

I will hold off on fixing this race until we settle the vm or vcpu ioctl
question.

Eric

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJrhGAAoJEKhG9nGc1bpJ49oP/RTLEFs85+ZLSHExFscpKSZa
/ulPzlXAVmLXP38bnre9K0PrR2PdbTColBeGpzEfPovfM74hGk357S2PvVdG/FkW
Nmiwg7HdsWXbNlwInmh9ObzFBGj9mq9DTcdkoiKmMiZLoiGZNmRe9JVc4l6r2qDQ
2pfisLQiSwI+M4COxTORUlKNVmaV1Ts5DtnRCyfhrzA1rKFBbtH/JF6A42HvC3IU
ErMR/0TO+HA5zKRpikz691pYOEa8S8eeFlnJHH30FOgYIfqi7quGiHmWefEI1ltC
TybvHT0C0ez9E7b6Hokiwdua359dCNBX4Do76GmLU7xXxvsaIgkPFjCxpO33/u9S
jJbeGQVU5rk2TdVs4pYuTx8NeekvWjrQvkmdtBDzdL/zSawELBs3gz5GBjTfuqqi
GIBmdLRK79NTn3nyqMjAvbqCGYdyU1kl2JAXYj43Yg/sIRo4szcwofHCMtevexmP
ywnZQ62z7SinILue4E184StsOc/8g31peXjam+Q/TcsHCD4RqtG+Q6+Ml1MkYerl
+KS5PBkTye/yW/730uFgNTn7Cm3FZav+Tb/cazMx0hV69OJyR3DBWVtaU5juabW+
CqSi+fmMp5rqj/vonps1SQRwgcYVT85vSbEE0Z5yzeYf5CkEOxgIiknbM5dbII9E
h9YqoiZHVw2oy5wRSG9+
=2nBb
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
