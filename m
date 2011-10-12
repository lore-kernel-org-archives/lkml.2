Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab1JLQv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:51:57 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:57148 "EHLO
	ozymandias.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751404Ab1JLQv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:51:56 -0400
Date: Wed, 12 Oct 2011 12:51:54 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: eranian@google.com, mingo@elte.hu, anton@samba.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, hbabu@us.ibm.com
Subject: Re: Oprofile Regression Caused by commit
 e5d1367f17ba6a6fed5fd8b74e4d5720923e0c25 on PPC
Message-ID: <20111012165154.GB6158@mgebm.net>
References: <20111007204247.GA5444@mgebm.net>
 <20111010233842.GC24583@mgebm.net>
 <1318319095.14400.54.camel@laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
In-Reply-To: <1318319095.14400.54.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Oct 2011, Peter Zijlstra wrote:

> On Mon, 2011-10-10 at 19:38 -0400, Eric B Munson wrote:
> > On Fri, 07 Oct 2011, Eric B Munson wrote:
> >=20
> > > This commit seems to have caused a regression with oprofile.  It is f=
airly easy
> > > to trigger, simply run oprofile monitoring an event that will fire (s=
omething
> > > frequent like CPU cycles) causes oprofile to fail saying that the PMU=
 is in use.
> > > If I disable CONFIG_CGROUP_PERF, everything goes back to working.  I =
suspect the
> > > problem is that the PMU is being initialized without being reserved f=
or perf.  I
> > > am not yet sure of the right fix yet so if you have any suggestions I=
 would
> > > appreciate them.
> > >=20
> > > Eric
> >=20
> > This isn't the best description of the behavior we see, what happens is=
 at some
> > point in the profiling session the MMCR register is clobbered by
> > perf_cgroup_switch() which calls perf_pmu_enable() without reserving th=
e PMC
> > hardware.  When this happens oprofile stops counting.  It doesn't happe=
n each
> > time so some runs show event counts that are reasonable, but it can als=
o lead to
> > event counts that are smaller than expected, or completely missing.
>=20
> What kernel are you testing?
>=20

The problem seems to be fixed in 3.1-rc9 so I just need to identify the
patch(es) that fixed it.

Eric

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOlcWqAAoJEKhG9nGc1bpJ1ykP/0fuox+IucRsAPpEs5RH9N5M
M2p7zRZYKs/FyASVm4qxZOG4WsiCusDTO9fsucu4auWaFGkVEv9c5qIcLcZuqLVR
7R97wJRlR5Hc/nV97pCflxBs6Pl+Ot7MkA7OsF6J8nmxvFJnASp2zcE4EPvIO+3q
Fq/l1exWblpyX0KGg4Uq8bRS2spA4la6qqSekK3lYjw5vlVxV6SeNG1uSyyjIKmU
c3kRmoNcUcRf7rlPtEym/QIN/Zt9msCzZBA+9c0CG3Axs3BoLBMT1x0eJPWB3RLk
bZSMlk8b/oZvwSqNuEaMLNwgB5THqSARbX0MzEbSr1RI/zbvrrdhQZKV0GM1J+2h
dMsiqsNw0yqflfaWerhMeUxp5iIYLy8nairuVNi3vmIGgpx9sW2bT/j+n2cyrEIR
V044krOnJv7bTnAGCS7RrzZNwshD8Q5ruOniwLhTZniGZ6xOGgfH1CqFnnAjhv54
A69PmJrWE7kzyu7MgmbpnxQV4ygQzm3yrIOzn5CV0IazO7vX8Cuz0+MhZ1i3X05c
C38iP+VLIkfbwJoYpm4H5YBt9HFdMhg1dnlUqWfcuECPE9NMMlz0IQw+EK/9yFIO
Y89m4FDOQJFZZOACBIeRvjcZifZrrmJFnGZQmxKmhxUeMEzdtBHQgZwmxIwBLaPK
OAqQtGSNCo2bO+fqxiyi
=EYTK
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
