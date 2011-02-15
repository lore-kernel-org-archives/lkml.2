Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab1BOV4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 16:56:09 -0500
Received: from eastrmfepo102.cox.net ([68.230.241.214]:45567 "EHLO
	eastrmfepo102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670Ab1BOV4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 16:56:08 -0500
X-VR-Score: -200.00
X-Authority-Analysis: v=1.1 cv=72mwMHry7RVIehb2GilHRvg51L14SqmocFmEXpMAk0g=
 c=1 sm=1 a=4UV-9Kl2S54A:10 a=UFf5x1fKmGVfY+5MkVsK7Q==:17
 a=QpZ7DMbfJW5xajv58_cA:9 a=A9EQfo302Kp1kFROLKYA:7
 a=OPz_tdsfGIi6BnyCpfUUzVXZ_EAA:4 a=CjuIK1q_8ugA:10 a=52nVw68kpdGx7AJ5BeEA:9
 a=s8KTtEOgbFfEohUiyKUsebwL_nAA:4 a=UFf5x1fKmGVfY+5MkVsK7Q==:117
X-CM-Score: 0.00
Authentication-Results: cox.net; none
Date: Tue, 15 Feb 2011 16:56:04 -0500
From: Will Simoneau <simoneau@ele.uri.edu>
To: David Miller <davem@davemloft.net>
Cc: will.newton@gmail.com, hpa@zytor.com, matt@console-pimps.org,
        rostedt@goodmis.org, peterz@infradead.org, jbaron@redhat.com,
        mathieu.desnoyers@polymtl.ca, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
Message-ID: <20110215215604.GA3177@ele.uri.edu>
References: <4D59B891.8010300@zytor.com>
 <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com>
 <20110215211123.GA3094@ele.uri.edu>
 <20110215.132702.39199169.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <20110215.132702.39199169.davem@davemloft.net>
User-Agent: Mutt/1.5.21 [Linux 2.6.37-rc4+ x86_64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13:27 Tue 15 Feb     , David Miller wrote:
> From: Will Simoneau <simoneau@ele.uri.edu>
> Date: Tue, 15 Feb 2011 16:11:23 -0500
>=20
> > Note how the cache and cache coherence protocol are fundamental parts o=
f this
> > operation; if these instructions simply bypassed the cache, they *could=
 not*
> > work correctly - how do you detect when the underlying memory has been
> > modified?
>=20
> The issue here isn't L2 cache bypassing, it's local L1 cache bypassing.
>=20
> The chips in question aparently do not consult the local L1 cache on
> "ll" instructions.
>=20
> Therefore you must only ever access such atomic data using "ll"
> instructions.

(I should not have said "underlying memory", since it is correct that
only the L1 caches are the problem here)

That's some really crippled hardware... it does seem like *any* loads
=66rom *any* address updated by an sc would have to be done with ll as
well, else they may load stale values. One could work this into
atomic_read(), but surely there are other places that are problems.

It would be OK if the caches on the hardware in question were to
back-invalidate matching cachelines when the sc is snooped from the bus,
but it sounds like this doesn't happen?

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk1a9nQACgkQLYBaX8VDLLUhnACgiz0MTQAi52r8R06uWcrh3ubQ
iGoAn0kw09kgnoLszgT72WtZH4nWsOZN
=Q2r7
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
