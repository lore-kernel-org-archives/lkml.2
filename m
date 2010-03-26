Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0CZVwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:52:39 -0400
Received: from ppa01.Princeton.EDU ([128.112.128.213]:60457 "EHLO
	ppa01.Princeton.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab0CZVwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:52:38 -0400
Date: Fri, 26 Mar 2010 17:52:01 -0400
From: Yury Polyanskiy <ypolyans@princeton.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joel Becker <joel.becker@oracle.com>, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>, Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: [PATCH] hangcheck-timer is broken on x86
Message-ID: <20100326175201.3dbac6ce@penta.localdomain>
In-Reply-To: <20100326142423.1334d407.akpm@linux-foundation.org>
References: <20100323233611.6dcbe4f4@penta.localdomain>
	<20100326142423.1334d407.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_4obkywy2pO5xN9GZc19oB0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_4obkywy2pO5xN9GZc19oB0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 26 Mar 2010 14:24:23 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 23 Mar 2010 23:36:11 -0400
> Yury Polyanskiy <ypolyans@princeton.edu> wrote:
>=20
> > The drivers/char/hangcheck-timer.c is doubly broken. First, the
> > following line overflows unsigned long:
> > # define TIMER_FREQ (HZ*loops_per_jiffy)
> >=20
> > Second, and more importantly, loops_per_jiffy has little to do with the=
 conversion from the
> > the time scale of get_cycles() (aka rdtsc) to the time scale of jiffies.
>=20
> It's a bit odd to have a driver be this broken on x86_32 for five years
> without anyone noticing.  What are the user-visible effects of these
> shortcomings?

When the overflown value of TIMER_FREQ is abnormally low, it spams the
syslog with KERN_CRIT messages "Hangcheck: hangcheck value past margin!"
But whether it happens or not depends on HZ and lpj in a complex way.
People have hit it occasionally as far as google search can tell.=20

>=20
> Also, please do send us a Signed-off-by: for this patch, as explained
> in Documentation/SubmittingPatches, thanks.
>=20

Sorry.

Signed-off-by: Yury Polyanskiy <polyanskiy@gmail.com>

Thank you Andrew!

Yury

--Sig_/_4obkywy2pO5xN9GZc19oB0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkutLIEACgkQemuRe3zuqOT89QCgrv3iLqDlYZPsKSBZbIwTptmn
JdYAn12L6sVjkO2VYOFN5jjIOF+U381z
=jEap
-----END PGP SIGNATURE-----

--Sig_/_4obkywy2pO5xN9GZc19oB0--
