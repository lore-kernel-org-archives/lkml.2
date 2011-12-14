Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab1LNRLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:11:10 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:40534 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757395Ab1LNRLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:11:08 -0500
Date: Wed, 14 Dec 2011 12:11:05 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        jeremy.fitzhardinge@citrix.com, levinsasha928@gmail.com,
        Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5 V5] Add functions to check if the host has stopped
 the vm
Message-ID: <20111214171105.GB4075@mgebm.net>
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
 <1323116344-17911-3-git-send-email-emunson@mgebm.net>
 <4EDF78C5.8060908@redhat.com>
 <20111208152310.GB6301@mgebm.net>
 <20111214121124.GA18317@amt.cnet>
 <4EE8B4AD.2060101@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s/l3CgOIzMHHjg/5"
Content-Disposition: inline
In-Reply-To: <4EE8B4AD.2060101@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s/l3CgOIzMHHjg/5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Dec 2011, Avi Kivity wrote:

> On 12/14/2011 02:11 PM, Marcelo Tosatti wrote:
> > On Thu, Dec 08, 2011 at 10:23:10AM -0500, Eric B Munson wrote:
> > > On Wed, 07 Dec 2011, Avi Kivity wrote:
> > >=20
> > > > On 12/05/2011 10:19 PM, Eric B Munson wrote:
> > > > > When a host stops or suspends a VM it will set a flag to show thi=
s.  The
> > > > > watchdog will use these functions to determine if a softlockup is=
 real, or the
> > > > > result of a suspended VM.
> > > > > =20
> > > > > +bool kvm_check_and_clear_guest_paused(int cpu)
> > > > > +{
> > > > > +	bool ret =3D false;
> > > > > +	struct pvclock_vcpu_time_info *src;
> > > > > +
> > > > > +	/*
> > > > > +	 * per_cpu() is safe here because this function is only called =
=66rom
> > > > > +	 * timer functions where preemption is already disabled.
> > > > > +	 */
> > > > > +	WARN_ON(!in_atomic());
> > > > > +	src =3D &per_cpu(hv_clock, cpu);
> > > >=20
> > > > __get_cpu_var(); drop the cpu argument
> > > >=20
> > >=20
> > > Will change for V6.
> > >=20
> > > > > +	if ((src->flags & PVCLOCK_GUEST_STOPPED) !=3D 0) {
> > > > > +		src->flags =3D src->flags & (~PVCLOCK_GUEST_STOPPED);
> > > >=20
> > > > Isn't this racy?  Between reading and writing src->flags, we can ex=
it to
> > > > the hypervisor and add/remove new flags.  The write then overrides =
those
> > > > new flags.
> > > >=20
> > >=20
> > > If I understand (please correct me if this is wrong) because this is =
only
> > > called from the watchdog, which disables preemption, we should be pro=
tected
> > > from something else writing to these flags.
> >
> > The host can write, but in that case race is harmless.
>=20
> Why is it harmless?  You don't know what's in those other flags.
>=20
> --=20
> error compiling committee.c: too many arguments to function
>=20

Currently there is only one other flag in this byte (PVCLOCK_TSC_STABLE_BIT)
and it isset once in kvmclock_init().  It is highly unlikely that the vm wi=
ll
be stopped during this init and have the flag clobbered.  After the tsc sta=
ble
bit is written in the init, the field is read only outside of the guest pau=
sed
code.

Eric

--s/l3CgOIzMHHjg/5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO6NipAAoJEKhG9nGc1bpJqNsP/jdDO/wp0M2MLVuz4FxMRO2E
08KCSXMjAv13SOi6ti+xtjeFnhiuoXstr8qr0vR2/mO0KAUtpzVKXS2EEr2Y8x9j
pJI6h5ByJol03UxTCb0jKSpJ0oeJdy/n9DFoPUuLlFGHdDuAcssuYgfouAYu8sAp
JU5a6bYkjOccplQMe71OBod0F5KEb9grVU2lJN/KtOhsl3K0jXJ93a6/2PTNe91T
nMbZlUj8mBs4aaFfpmRjAnElK+sYMMD13h6TNOrggHYZZ7DpxCysfeqhoOelKyCJ
RT+b6XUP4vPATGO0TfRGTcFULGmtLLj2s9PNlWG/ix9n+LZEu2Mvfm86XP2lCPgp
Unk44x4C6D7za9NoBhpFFtNXAbZ7uwXpZD4SIMW+5vrO2NdWt9fIZV5FaY1UBBYH
nOHp+wrYQgwQrDzewpG1vLvE8+e1JimLUVpbId9ErprdntPN+Z5f3xTisCIq2Gkf
syxzeOi+PcmFUPYloCGt6D57WN5A4GcalPoKQzLnN9EkGXeeSS8QDPi9dBuhfyJ9
+5RRhXCHr2D1INS4971/AfQ8oPFZVA+fMNb3b0HIeixY0m7LttxAHOqFul7uMYzd
KxGp7M5jtCBlhUHX6lM4K7nIKbaBb96L2dDNvzcGyP6WPOf/LRriJU+znB7EI2ml
br6qaS9kIjYcP8D8mKmV
=YGgE
-----END PGP SIGNATURE-----

--s/l3CgOIzMHHjg/5--
