Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab1LHPXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 10:23:14 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:47342 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab1LHPXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 10:23:11 -0500
Date: Thu, 8 Dec 2011 10:23:10 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Avi Kivity <avi@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, arnd@arndb.de, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, mtosatti@redhat.com,
        jeremy.fitzhardinge@citrix.com, levinsasha928@gmail.com,
        Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5 V5] Add functions to check if the host has stopped
 the vm
Message-ID: <20111208152310.GB6301@mgebm.net>
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
 <1323116344-17911-3-git-send-email-emunson@mgebm.net>
 <4EDF78C5.8060908@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Content-Disposition: inline
In-Reply-To: <4EDF78C5.8060908@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 07 Dec 2011, Avi Kivity wrote:

> On 12/05/2011 10:19 PM, Eric B Munson wrote:
> > When a host stops or suspends a VM it will set a flag to show this.  The
> > watchdog will use these functions to determine if a softlockup is real,=
 or the
> > result of a suspended VM.
> > =20
> > +bool kvm_check_and_clear_guest_paused(int cpu)
> > +{
> > +	bool ret =3D false;
> > +	struct pvclock_vcpu_time_info *src;
> > +
> > +	/*
> > +	 * per_cpu() is safe here because this function is only called from
> > +	 * timer functions where preemption is already disabled.
> > +	 */
> > +	WARN_ON(!in_atomic());
> > +	src =3D &per_cpu(hv_clock, cpu);
>=20
> __get_cpu_var(); drop the cpu argument
>=20

Will change for V6.

> > +	if ((src->flags & PVCLOCK_GUEST_STOPPED) !=3D 0) {
> > +		src->flags =3D src->flags & (~PVCLOCK_GUEST_STOPPED);
>=20
> Isn't this racy?  Between reading and writing src->flags, we can exit to
> the hypervisor and add/remove new flags.  The write then overrides those
> new flags.
>=20

If I understand (please correct me if this is wrong) because this is only
called from the watchdog, which disables preemption, we should be protected
=66rom something else writing to these flags.

> > +		ret =3D true;
> > +	}
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_check_and_clear_guest_paused);
> > +
> >  static struct clocksource kvm_clock =3D {
> >  	.name =3D "kvm-clock",
> >  	.read =3D kvm_clock_get_cycles,
>=20
>=20
> --=20
> error compiling committee.c: too many arguments to function
>=20

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO4NZeAAoJEKhG9nGc1bpJ0ncQAKH8Zc3Lu/kJ1AnQ4LnKs8/o
xpPAbifL6fuJjFdlPAkd75oN4F9NToY7RetXxByHFrKsb+V5ut6F+2lMRKj2DMhK
SohZUpjyRLJPf0taZD4tfK97XX407+oeR+NstgwI4PWXcZsiSIwY6FKfcziFrvyy
LPVBbkpYSXEYxe1tsqdBeBjNy76tyJon+kmi9dRumZHG8/sei/jR0rdhou+oSZ/x
0EcLaPX9zHDrizab0ipOiJf4ybGOPLobyaal/dLvSmz0vDPrftH32A5yqOfSSQad
fWxICy1GR4G/p30uIO30QiSTHVI4eZOb2yr7EaasMskm15SJuiSpE1auByb4CQgg
RYbPf0hSEvtrB54hEE0KbWwiRvva1C+Cyz7Pru6mTuBNunhUQublZ+AHBY9VVG6X
y5jOawxv0nTF2dqjYCxuD7cSm7hbLHrO7XNDoTTn53WySgyP7x0452EOOz9PI+gv
ije1tRd5IGhBm6AabftfzFg3HzyBxf23wuNkS80akmnL9RkpLRabL74Yt4o0pUb9
aAbns5YMN9NVR0f22sX8KdgLE37hO+ssR3gENzOnvC6Qt5y2o2Q2phQKqTdpBv45
u28P8FS0j5Cm+lPLSHt4hdAhOHbSiNHdHSnexQ9FOUY3M4cUou6xYzRZr9JJWQ5o
wFL2MDiwQXVCH/24ELz4
=Cbq2
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
