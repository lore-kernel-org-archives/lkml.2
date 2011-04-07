Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab1DGQQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 12:16:15 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64125 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab1DGQQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 12:16:14 -0400
Date: Thu, 7 Apr 2011 12:16:11 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, anton@samba.org
Subject: Re: [PATCH] POWER: perf_event: Skip updating kernel counters if
 register value shrinks
Message-ID: <20110407161611.GC3119@mgebm.net>
References: <1301059689-4556-1-git-send-email-emunson@mgebm.net>
 <1301378637.2402.671.camel@pasglop>
 <20110329142519.GA3527@mgebm.net>
 <1301433165.2402.689.camel@pasglop>
 <20110330183656.GA2564@mgebm.net>
 <1301551476.2407.61.camel@pasglop>
 <20110406212733.GB2596@mgebm.net>
 <1302150177.2458.30.camel@pasglop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VV4b6MQE+OnNyhkM"
Content-Disposition: inline
In-Reply-To: <1302150177.2458.30.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VV4b6MQE+OnNyhkM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 07 Apr 2011, Benjamin Herrenschmidt wrote:

>=20
> > > Doesn't that mean that power_pmu_read() can only ever increase the va=
lue of
> > > the perf_event and so will essentially -stop- once the counter rolls =
over ?
> > >=20
> > > Similar comments every where you do this type of comparison.
> > >=20
> > > Cheers,
> > > Ben.
> >=20
> > Sorry for the nag, but am I missing something about the way the registe=
r and
> > the previous values are reset in the overflow interrupt handler?
>=20
> Well, not all counters get interrupts right ? Some counters are just
> free running... I'm not sure when that power_pmu_read() function is
> actually used by the core, I'm not that familiar with perf, but I'd say
> better safe than sorry. When comparing counter values, doing in a way
> that is generally safe vs. wraparounds. Eventually do a helper for that.
>=20
> Cheers,
> Ben.

I am honestly not sure, I was under the assumption that all counters would
generate an interrupt if they overflowed.  I do not have the hardware docs =
to
prove this, so I will have a V3 that (I think/hope) addresses your concerns=
 out
momentarily.

Eric

--VV4b6MQE+OnNyhkM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNneNLAAoJEH65iIruGRnNAj0H/3dAR++g0uiPaHaMw12ADag3
hsGeRsJ8CtuQA1dk2SyhkUudhcy4tOj87Fpnj2L2+y1ewSfBOHzsa4zbryUsRrxM
vNKWZXdMjeUHIVfbPXbd2Xd9SlNgytFSpxlw00nOUV2VhuZk41V7NvI7TbtMkxfx
qAAhCofeEY8OlAgrrgVb8nUuDxaT+tpnzV6bNyY2oUhVqx0ZelJFSUyTfaT63dhl
O5cJbShStZMkKZ4AC29p56ObhjqVLoHxDnWO6RCypvdUm8JywDcEyeu1d3g716pw
QQ+KrS910pue6sDAxb6GJfmwYulitcl/vYSktJQSMGOXhLwox/4i7GgZdY2O/ZY=
=NkCe
-----END PGP SIGNATURE-----

--VV4b6MQE+OnNyhkM--
