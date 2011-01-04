Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab1ADEVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 23:21:18 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44606 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab1ADEVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 23:21:15 -0500
Date: Tue, 4 Jan 2011 15:21:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the percpu tree
Message-Id: <20110104152105.5cc7c3a9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__4_Jan_2011_15_21_05_+1100_phgk2IuRv_jJiS6Y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Jan_2011_15_21_05_+1100_phgk2IuRv_jJiS6Y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the percpu tree, today's linux-next build (x86_64
allmodconfig) failed like this:

arch/x86/kernel/cpu/mcheck/therm_throt.c: In function 'intel_thermal_interr=
upt':
arch/x86/kernel/cpu/mcheck/therm_throt.c:368: error: implicit declaration o=
f function 'this_cpu_has'

Caused by commit 6ac0bb7148b93fb40bccba5dff06d51a3e3ea283 ("x86: use
this_cpu_has for thermal_interrupt").

this_cpu_has() does not exist anywhere except in this introduced usage.

I have used the percpu tree from next-20101231 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__4_Jan_2011_15_21_05_+1100_phgk2IuRv_jJiS6Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNIqAxAAoJEDMEi1NhKgbs4nMIAJjwGTLOo3n5tT7pk91W5mBp
dqfog6S2mT8OW2f4o0mg3GT6KAKYgrYM8kH/eTMVlKGB0dJTepJWiZuZ1CNeRkEP
gYHtOLqKWetw8VNXNTLO6/gepg90gEz4l1dk7RQE/R/wykK+rRFyZ6cxHXEpbsYt
33egJNilyK7Xr+OgObITXYSGfU9kPBt5YhT+xoxwbgj/8790ETJHZ4YEaJz9kuUY
UKGs2SBNN+onzGIR5ufV1kqgsSvL9vdTjQRs5fVvIbLfq1lY1E1QD1XIMCBhNByZ
szu96+OZluZBPZxjuhn8Q4oLF627ScAMgzBtDeNOJ0t2pyw+iFl0/pbKvs9Q0V4=
=Cx87
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Jan_2011_15_21_05_+1100_phgk2IuRv_jJiS6Y--
