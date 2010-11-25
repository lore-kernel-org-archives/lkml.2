Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab0KYJzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 04:55:42 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:55478 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab0KYJzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 04:55:40 -0500
X-Spam-ASN: 
Date: Thu, 25 Nov 2010 12:55:28 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, "Nikita V\\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        John Stultz <johnstul@us.ibm.com>, David Howells <dhowells@redhat.com>,
        "H\\. Peter Anvin" <hpa@zytor.com>, Magnus Damm <damm@opensource.se>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv5 14/17] pps: capture MONOTONIC_RAW timestamps as well
Message-ID: <20101125125528.38f84c81@apollo.gnet>
In-Reply-To: <alpine.LFD.2.00.1011241746500.2900@localhost6.localdomain6>
References: <cover.1290599843.git.lasaine@lvk.cs.msu.su>
	<5192d173ed6e6d392a76790b771be94f548d8ac8.1290599845.git.lasaine@lvk.cs.msu.su>
	<alpine.LFD.2.00.1011241746500.2900@localhost6.localdomain6>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/bDOJTmb.DA0jV6YTa0MVgJR"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/bDOJTmb.DA0jV6YTa0MVgJR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Wed, 24 Nov 2010 17:49:44 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Wed, 24 Nov 2010, Alexander Gordeev wrote:
> >  /**
> > + * getnstime_raw_and_real - Returns both the time of day an raw
> > + * monotonic time in a timespec format
>=20
> IIRC then kerneldoc does not handle multiline comments for the
> function name

Ah, I see, fixed that.

> > + * @ts_mono_raw:	pointer to the timespec to be set to raw
> > + *			monotonic time
> > + * @ts_real:		pointer to the timespec to be set to the time
> > + *			of day
> > + */
> > +void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *=
ts_real)
> > +{
> > +	unsigned long seq;
> > +	s64 nsecs_raw, nsecs_real;
> > +
> > +	WARN_ON_ONCE(timekeeping_suspended);
>=20
>   Shouldn't this just return an error code instead of reading some
>   stale or random value ?

Sorry, I don't know if it should, just copied it from getnstimofday().
BTW what is the bad value for timespec or you mean returning int
instead of void? I think this function should be handled the same way as
getnstimeofday() and no one currently expects that the latter can return
some bad value.

> > +	do {
> > +		u32 arch_offset;
> > +
> > +		seq =3D read_seqbegin(&xtime_lock);
> > +
> > +		*ts_raw =3D raw_time;
> > +		*ts_real =3D xtime;
> > +
> > +		nsecs_raw =3D timekeeping_get_ns_raw();
> > +		nsecs_real =3D timekeeping_get_ns();
> > +
> > +		/* If arch requires, add in gettimeoffset() */
> > +		arch_offset =3D arch_gettimeoffset();
> > +		nsecs_raw +=3D arch_offset;
> > +		nsecs_real +=3D arch_offset;
> > +
> > +	} while (read_seqretry(&xtime_lock, seq));
> > +
> > +	timespec_add_ns(ts_raw, nsecs_raw);
> > +	timespec_add_ns(ts_real, nsecs_real);
> > +}
> > +EXPORT_SYMBOL(getnstime_raw_and_real);
>=20
> Otherwise, I'm fine with that.
>=20
> Thanks,
>=20
> 	tglx


--=20
  Alexander

--Sig_/bDOJTmb.DA0jV6YTa0MVgJR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJM7jKQAAoJEElrwznyooJbUOYIAIdPeEnPgPH51K934Wl16ey7
xmwfwiQOxyCvOOSs/ogbJFLvqNTyk6KMX9kIMlG2dtoh++C65jRjKXqQe+BUzZHZ
mw3AjL0gC8NrtOK2CFnFMEGmHnfPKtGOuQmZDyUDLl31G/Vw6SVHOqv8u2juJqfg
UH9pFjnjNUKgHwQRnvz7J3/tYymcECPBx5qzffjT0dlRCuzoFGiuLiRYgzBDyRJH
4J8YhiC/wL60QnX+I0z1/whOCbOXCQ+A80o07rFT97A9mi7xaIr0GCLo5E3NLSl2
61QT2orSUQZu3gEYAr5yrMbOLnLQakQRf776pab6/MHT7obn2v4WiCd0FVU6+3Q=
=+nqU
-----END PGP SIGNATURE-----

--Sig_/bDOJTmb.DA0jV6YTa0MVgJR--
