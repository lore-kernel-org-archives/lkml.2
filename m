Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab2HHMHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:07:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51021 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003Ab2HHMHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:07:41 -0400
Date: Wed, 8 Aug 2012 14:07:37 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Grant Likely <grant.likely@secretlab.ca>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/dt: use linear irq domain for ioapic(s).
Message-ID: <20120808120737.GA5433@avionic-0098.mockup.avionic-design.de>
References: <1343890270-13007-1-git-send-email-thierry.reding@avionic-design.de>
 <20120806073811.GA3261@breakpoint.cc>
 <20120808104629.GA20296@avionic-0098.mockup.avionic-design.de>
 <502252C8.3090600@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <502252C8.3090600@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:D/4cm2Mkbq3kKVPPFq91J0zYmcnQ9tsHAWWXb1jZNN3
 wefC9vVNdv8vnXkbvIMpm9gmwUdBT8iUHOpk8WpL3e9G9PazSY
 ekbpXFjTr7VoJAMo6HSs+3hCb2ytFBoE7ZqV3esRitIW4N58Me
 7Dg+reOoy5mrVFjGSsh1u2zpCrLGKbgB7qFB1fU/fsCjkGZgjw
 SqHtC4hYWYpJXA/kUnaNsc8gzAfyfE5FY7YJcG2/g33lgD7kMm
 I0gwha736F8WT344bKMJ1YbaieKV8hQDOAgnVThFO7rnslCzDT
 fxMNMrlA6b3Zphu8MfLgVd9N2CtrdJsu3Lc0dAxXZmyNu1FQnP
 Le2K1o5qgjGV2jhe2DSkNzvHOgiGKKUuyNcZXRvVvjRqM07MEo
 jpbinFpqGzTuhboOBJekICJycPijUQoaRKRB87B47PVZQMOVlt
 lfGbH
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 08, 2012 at 01:51:36PM +0200, Sebastian Andrzej Siewior wrote:
> On 08/08/2012 12:46 PM, Thierry Reding wrote:
> >On another note, I saw that you've used the "intel,ce4100" prefix in
> >various places and I wonder if it would be useful to replace them with
> >something more generic like "intel,hpet", "intel,lapic" and
> >"intel,ioapic" respectively. The hardware that I use is based on an Atom
> >N450 and works with the current code, so it really isn't ce4100-
> >specific.
>=20
> No. You do have a compatible entry. It first appeared on the ce4100
> CPU. If it happens to also work on the n450 then it seems to be
> compatible with that one. "This" is documented somewhere=E2=80=A6
> Usually you add 'compatible =3D "your cpu", "generic binding"' in case
> you need a fixup / errata whatever for "your cpu". Even if you compare
> all hpets from Intel there is the one or other difference / errata.

Exactly, but "ce4100-hpet" isn't very generic. What I'm saying is that
the last entry in the compatible list should be something generic, like
"intel,hpet", which can be overridden by putting a more specific entry
in front. I'd expect the ce4100 HPET to use something like this:

	compatible =3D "intel,ce4100-hpet", "intel,hpet";

On N450 this could for instance be:

	compatible =3D "intel,n450-hpet", "intel,hpet";

With that in place, the driver code can match on "intel,hpet" to catch
all implementations and use the more specific entries if quirks are
required for the specific hardware.

Thierry

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQIlaJAAoJEN0jrNd/PrOhkUQQALZFgrRSKypy3nezT05E1sa1
vUo9hiWORK8TUCY67HpPt3VuAAXGOjWvr0G/1jdcAb2rj4529Q9sTUZJdLsLgxiv
75BWcWqT3/gzBZ8O3seuS1Ozc63119TesIbkLa6m9dUm91KQSxV/witA3aYjaUKo
3exa76OY4uKKXhafpLxc0gMIF2unuTeDzuiVn4rn6Zp+5rHNtdHm/mV7u7wvhmn+
EI3OAkr97gf4Vp3EUHL9LjYFhrtEmo4LsreJWQQiVW3GH3KouFWhiFy1l7heCmp/
m+CCW7OaeqUBazqeG+Y4QbCDz7EUb/7TJxNtyQMnQV3jgEQfS7H/mmOhvUyQZ0eL
Eu0w2w6tFRxJJKQZVaShxRq4NpC/YuKIlkUrTz0zJolEv9OKHdnBzmRIIIwOiugt
8YlscXq5ruBbSKNU8aBILMZ+0Iru1Tq3sx6cnwWzgE1hzIPC17bqccYMxELKQx1H
neXk/2ZNjwIdkIQ4FTQfPDA7wf/03XBsseq1PNviXDg/CNtHZ10uv6sQNFh1rtwV
PaUia4FOGiROySkM3yGNdqdGZ8Qh2gtKrgKIjkMf6FdpDHdsfNtatggs1cye1ZYn
cop+yyIKfsWGH9aNl5HSx+0wnrz72HhscONDKXm5Ximlr99+yqltlxQ8rYWFPBAd
rM3YDKt5/dRzE6DIj8e/
=tubf
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
