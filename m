Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab1JKNcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 09:32:16 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:33904 "EHLO
	ozymandias.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752888Ab1JKNcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 09:32:14 -0400
Date: Tue, 11 Oct 2011 09:32:13 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: eranian@google.com, mingo@elte.hu, anton@samba.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, hbabu@us.ibm.com
Subject: Re: Oprofile Regression Caused by commit
 e5d1367f17ba6a6fed5fd8b74e4d5720923e0c25 on PPC
Message-ID: <20111011133213.GB8151@mgebm.net>
References: <20111007204247.GA5444@mgebm.net>
 <20111010233842.GC24583@mgebm.net>
 <1318319095.14400.54.camel@laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline
In-Reply-To: <1318319095.14400.54.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vGgW1X5XWziG23Ko
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

The tests first showed in Beta testing the new RHEL and SLES kernels, but t=
he
perf cgroup code looks relatively unchanged since.  I have asked that the t=
ests
be re-run with Linus' HEAD.

Eric

--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOlEVdAAoJEKhG9nGc1bpJ2HIP/j+KKuFO+EZL/4vKxq/Ouroq
cR0UfqzqB2THmX1szLbX26g62Pum2w01XRVw9iQ3qAKtxVadh8bPzOokQt/A5MR8
OsUhEBniAz6umRBXtNEu2+d+iXMbvRmHR77JBrDjBFXi4L6M7TyTco9v7gm6+Z38
JQ9I8YUeufNPNFEg0MWHVAT05QGz4a0h4J0raxAQAvdQGviPTZ/iNMtQT0Fpi7Us
DPj6cR5enCfpHz3z06fy7OhIGK10dPh1/coPe2MWjH5w+NGm8u5fQPA/cW7iGVzi
A4D2wsrqo6fx4ICBviXnxLU9oginPQh+9v/y8b2EijqIwaOuHltpCM+Jyvo+JZtc
e3gpy5AmuWLZqLyxIhjFcf0kZOK222O59JO/WgunWk8usj3/d4oScPLnZTJwoniT
/22gbR4uLOdtUCdVAWx1pjMIStmTBAQL9DSCKsLQLSm27AArzTkS2U+Lt3Q6Hcao
yyxT/VUMspYGg+RnfC3ziS6eVUXgOlMUrLoBzihfBMpmSvbxw3eGJ5ZBPuK5iICO
o4q7FvNKTrBv0ztHWM+6DEvQIS4uTUNWY5Z7/TQSgAwKqloobAhs/aNTRWhiFNdw
NEGktp35pvIohOniryqP3vGZfe8Y9rBRTZLLwTuEOpCgp8OHyX1eI5w7gz7tRmyF
VSnkT48NidoeqnXud5ze
=WKP0
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--
