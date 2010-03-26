Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab0CZWBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:01:05 -0400
Received: from ppa01.Princeton.EDU ([128.112.128.213]:34649 "EHLO
	ppa01.Princeton.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab0CZWBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:01:03 -0400
Date: Fri, 26 Mar 2010 18:00:25 -0400
From: Yury Polyanskiy <ypolyans@princeton.edu>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       john stultz <johnstul@us.ibm.com>, Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: [PATCH] hangcheck-timer is broken on x86
Message-ID: <20100326180025.052d930f@penta.localdomain>
In-Reply-To: <20100326214648.GF9984@mail.oracle.com>
References: <20100323233611.6dcbe4f4@penta.localdomain>
	<20100326214648.GF9984@mail.oracle.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YFqpw.aJHM4WkpurTtnDdcf"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/YFqpw.aJHM4WkpurTtnDdcf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 26 Mar 2010 14:46:49 -0700
Joel Becker <Joel.Becker@oracle.com> wrote:

> On Tue, Mar 23, 2010 at 11:36:11PM -0400, Yury Polyanskiy wrote:

> 1) Does getrawmonotonic() satisfy hangcheck-timer?  What I mean is, will
> it always return the wallclock nanoseconds even in the face of CPU speed
> changes, suspend, udelay, or any other suspension of kernel operation?
> Yes, I know this is a tougher standard than rdtsc(), but this is what
> hangcheck-timer wants.  rdtsc() at least satisfied udelay and PCI hangs.

Yes, as far as I can tell. Note that rdtsc is hosed on suspend-resume.

>=20
> 2) If it does satisfy, why not use it for all hangcheck usage instead of
> any ifdefs?

On my part, I didn't want to touch the S390 code since I can't test it.

Yury

--Sig_/YFqpw.aJHM4WkpurTtnDdcf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkutLnkACgkQemuRe3zuqORhiwCeM4lU1rnQJR9hbduni7MC8GKV
32QAmQG55a6+gPGv7Cbci5DqHLl/Ssym
=BTz1
-----END PGP SIGNATURE-----

--Sig_/YFqpw.aJHM4WkpurTtnDdcf--
