Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab0C2RFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:05:50 -0400
Received: from ppa03.Princeton.EDU ([128.112.128.214]:37565 "EHLO
	ppa03.Princeton.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab0C2RFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:05:49 -0400
Date: Mon, 29 Mar 2010 13:04:18 -0400
From: Yury Polyanskiy <ypolyans@princeton.edu>
To: john stultz <johnstul@us.ibm.com>
Cc: Joel Becker <Joel.Becker@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: [PATCH] hangcheck-timer is broken on x86
Message-ID: <20100329130418.2b5c068c@penta.localdomain>
In-Reply-To: <1269881007.1857.18.camel@work-vm>
References: <20100323233611.6dcbe4f4@penta.localdomain>
	<20100326214648.GF9984@mail.oracle.com>
	<1269824436.1880.2.camel@work-vm>
	<20100329101106.3678a312@penta.localdomain>
	<1269881007.1857.18.camel@work-vm>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5yWNrAt3PZEmREZS7.mM.7b"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5yWNrAt3PZEmREZS7.mM.7b
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Mar 2010 09:43:27 -0700
john stultz <johnstul@us.ibm.com> wrote:

> > I am not sure which archs do you mean. But in any case,
> > getrawmonotonic() is not just a wrap around a call to rdtsc() (or acpi
> > pm timer read). It is based on the clock->raw_time, which is updated
> > every timer interrupt by the update_wall_time(). So even if underlying
> > timer wraps, it doesn't lead to getrawmonotonic() returning 0 sec. =20
>=20
> What I'm saying is that if you're using getrawmonotonic() to detect
> hangs, you might miss them, as getrawmonotonic may wrap (and thus stop
> continually increasing) if the timer interrupt is delayed. This does not
> apply to systems using the TSC clocksource, but does apply to systems
> using the acpi_pm.=20

But if timer interrupt is delayed by more than acpi_pm wrap-around
time, then the update_wall_time() is also screwed. Since it is not, we
can rely on getrawmonotonic().

Y

--Sig_/5yWNrAt3PZEmREZS7.mM.7b
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuw3ZIACgkQemuRe3zuqOQxVgCeILSACbJFNa/op/eT7SRuQzG8
/l4AoKbn7pChiX6HbFLIAreNB1cqrQSA
=908W
-----END PGP SIGNATURE-----

--Sig_/5yWNrAt3PZEmREZS7.mM.7b--
