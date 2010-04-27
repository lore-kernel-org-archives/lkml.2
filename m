Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab0D0XAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 19:00:47 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:44490 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab0D0XAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 19:00:46 -0400
From: Eric Anholt <eric@anholt.net>
To: Jan Beulich <JBeulich@novell.com>, Brice.Goglin@ens-lyon.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: intel_i830_chipset_flush(): local clflush() vs. global wbinvd()
In-Reply-To: <4BD5787C020000780003C1DB@vpn.id2.novell.com>
References: <4BD5787C020000780003C1DB@vpn.id2.novell.com>
Date: Tue, 27 Apr 2010 16:00:30 -0700
Message-ID: <8739ygwlf5.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Apr 2010 10:26:52 +0100, "Jan Beulich" <JBeulich@novell.com> wro=
te:
> Eric, Brice,
>=20
> what is the point of issuing wbinvd() on all CPUs here if clflush isn't
> available, but using clflush() (if available) only on the current CPU?

From=20the IA-32 architecture manuals:

WBINVD: "Writes back all modified cache lines in the processor=E2=80=99s
         internal cache to main memory and invalidates (flushes) the
         internal caches. The instruction then issues a special-
         function bus cycle that directs external caches to also write
         back modified data and another bus cycle to indicate that the
         external caches should be invalidated.

CLFLUSH: "Invalidates the cache line that contains the linear address
          specified with the source operand from all levels of the
          processor cache hierarchy (data and instruction). The
          invalidation is broadcast throughout the cache coherence
          domain. If, at any level of the cache hierarchy, the line is
          inconsistent with memory (dirty) it is written to memory
          before invalidation. The source operand is a byte memory
          location.

My reading of these two is that wbinvd affects this processor's cache
lines, while clflush affects the cacheline regardless of which CPU owns
it since they all share the same coherence domain.

Given that on many systems without CLFLUSH (8xx chipsets), we have
issues with getting coherence to external memory successfully (note how
neither of those instructions provide that!), I'm not sure it's a good
time to be worrying about how to improve cache flushing performance on them!

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvXbI4ACgkQHUdvYGzw6veAyACeKCet/nCb7ILM/zYWwshFWVoQ
VZwAnRQkimfqhM64QoQt0Kvfvp20qVzg
=tCEL
-----END PGP SIGNATURE-----
--=-=-=--
