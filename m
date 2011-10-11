Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab1JKNeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 09:34:12 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:33930 "EHLO
	ozymandias.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752888Ab1JKNeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 09:34:11 -0400
Date: Tue, 11 Oct 2011 09:34:09 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu, anton@samba.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, hbabu@us.ibm.com
Subject: Re: Oprofile Regression Caused by commit
 e5d1367f17ba6a6fed5fd8b74e4d5720923e0c25 on PPC
Message-ID: <20111011133409.GC8151@mgebm.net>
References: <20111007204247.GA5444@mgebm.net>
 <20111010233842.GC24583@mgebm.net>
 <1318319095.14400.54.camel@laptop>
 <CABPqkBRs7iZr8pQB19Q2Gw45ntKUumE76v4K=nmXf_+wbBDY6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HG+GLK89HZ1zG0kk"
Content-Disposition: inline
In-Reply-To: <CABPqkBRs7iZr8pQB19Q2Gw45ntKUumE76v4K=nmXf_+wbBDY6Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HG+GLK89HZ1zG0kk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Oct 2011, Stephane Eranian wrote:

> On Tue, Oct 11, 2011 at 9:44 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> =
wrote:
> > On Mon, 2011-10-10 at 19:38 -0400, Eric B Munson wrote:
> >> On Fri, 07 Oct 2011, Eric B Munson wrote:
> >>
> >> > This commit seems to have caused a regression with oprofile. =A0It i=
s fairly easy
> >> > to trigger, simply run oprofile monitoring an event that will fire (=
something
> >> > frequent like CPU cycles) causes oprofile to fail saying that the PM=
U is in use.
> >> > If I disable CONFIG_CGROUP_PERF, everything goes back to working. =
=A0I suspect the
> >> > problem is that the PMU is being initialized without being reserved =
for perf. =A0I
> >> > am not yet sure of the right fix yet so if you have any suggestions =
I would
> >> > appreciate them.
> >> >
> >> > Eric
> >>
> >> This isn't the best description of the behavior we see, what happens i=
s at some
> >> point in the profiling session the MMCR register is clobbered by
> >> perf_cgroup_switch() which calls perf_pmu_enable() without reserving t=
he PMC
> >> hardware. =A0When this happens oprofile stops counting. =A0It doesn't =
happen each
> >> time so some runs show event counts that are reasonable, but it can al=
so lead to
> >> event counts that are smaller than expected, or completely missing.
> >
> > What kernel are you testing?
> >
> Looking at 3.1-rc9, I doubt it's coming from perf_cgroup_switch(). The fu=
nction
> is checking for perf context with at least of cgroup event before
> calling perf_pmu_disable().
> If there is no active perf context, there is no cgroup event, thus the
> function is a nop.
> Even if you have a competing perf session, it would have to have at
> least one cgroup
> event for this code to touch HW. The problem must come from somewhere els=
e.
>=20
> >
>=20

Does activating any cgroup setup a cgroup event?

Eric

--HG+GLK89HZ1zG0kk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOlEXRAAoJEKhG9nGc1bpJfYUP/0Fr0XUUn78Q/spg9b70Ks4f
EmsKjGgtPEeg+OneGa2RrLnVoROiyDgy+gpmnhrO41SlSbh/SxOktBL1PNEqSgq/
NyjIAgfVz9dZYpOPWAXdeD7CbcKwEgLwes8tQMuKxuQSQVi46vi6gX4dmF5IgzFM
ilUTlCgnUqYa6FY7yunRf6Fvxoce32tI7Yi0SttWAEHBQxU4DHBEcPjr1Wos/S8C
mCeVnh5Us8cUE2kzz2TFGpmq3DTveomYWPSdOBMDOQ3KtE4e3madajv8eRMl437S
8Fqv+qSTRFuATqVXhyj5EbMv7Xka/iQw8cxDRL/aqpQLuvKC+iA8hZrUxBPfp0aQ
Nfzh9INvs5QEwKdcm1pyTDYHwydmdq8DeyS4H4LcpSTWA4Wxm9WHP6lhgbIZsp/M
WfX20eUFB4MulZlBgZXQxWsy6nMAA1pCHt/D4w7QbmBRLJbbJVbDgmiS0K9/rg0H
X7PgvTR5Ass0PiglfUGO0hsks+QLzY8r7W6I3RG4jWwskdU3FqxBDI+HwCFZnRmG
eCD3CpAmOhD0K1ScZ8g809oRvKD1S9QXCryvEUfqAOMRxdDYw8e52fIXBRxokSpC
bBy1emWK+5VTwpDP5KS7BZJWHwjllKgzXznBx/Flt62WtWKj19CN4sUg/lcrzBuD
uzsX4gnDoq+TW0cyGrck
=GmrY
-----END PGP SIGNATURE-----

--HG+GLK89HZ1zG0kk--
