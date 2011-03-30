Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab1C3ShE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 14:37:04 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45049 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab1C3ShC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 14:37:02 -0400
Date: Wed, 30 Mar 2011 14:36:56 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, anton@samba.org
Subject: Re: [PATCH] POWER: perf_event: Skip updating kernel counters if
 register value shrinks
Message-ID: <20110330183656.GA2564@mgebm.net>
References: <1301059689-4556-1-git-send-email-emunson@mgebm.net>
 <1301378637.2402.671.camel@pasglop>
 <20110329142519.GA3527@mgebm.net>
 <1301433165.2402.689.camel@pasglop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <1301433165.2402.689.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Mar 2011, Benjamin Herrenschmidt wrote:

> On Tue, 2011-03-29 at 10:25 -0400, Eric B Munson wrote:
> > Here I made the assumption that the hardware would never remove more ev=
ents in
> > a speculative roll back than it had added.  This is not a situation I
> > encoutered in my limited testing, so I didn't think underflow was possi=
ble.  I
> > will send out a V2 using the signed 32 bit delta and remeber to CC stab=
le
> > this time.=20
>=20
> I'm not thinking about underflow but rollover... or that isn't possible
> with those counters ? IE. They don't wrap back to 0 after hitting
> ffffffff ?
>=20

They do roll over to 0 after ffffffff, but I thought that case was already
covered by the perf_event_interrupt.  Are you concerned that we will reset a
counter and speculative roll back will underflow that counter?

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNk3hIAAoJEH65iIruGRnNsUwH/3qT728+BEeypqHDAYtS6Vxt
vrLNmiVCOjkBvek7FvXdmGmK2hlqj/fziTA9UCN5Z84Bm170X4R+PJFLeDBHfJSt
kcJVVw/TwQlmUu+E7K6tg1LRt0mfxeh/JvxhZylW3XlCNyL0xvs8PLtc5anbThDL
bi52mX7vbZLJxb+5ESLP71WmGYJ5K4ldLKH2BiwzEmXc8a1XhHmM6bmsh4qBL5pg
4Z4vTn+KB+L1JpYj6OVMYynmZtxx8/H1eRPSyVPVloQy9Ty3RzaUnpiqo46Autwc
2a2hYuDtk9Uq8Z1Ru75UVZI4cW838VmikMBOaZmRzMaSdIt/uCwlJQiLxGDYXpY=
=dnjq
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
