Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab1INGfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 02:35:04 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:52535 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab1INGfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 02:35:03 -0400
Date: Wed, 14 Sep 2011 16:34:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shan Hai <haishan.bai@gmail.com>, Yong Zhang <yong.zhang0@gmail.com>
Subject: linux-next: build warning after merge of the tip tree
Message-Id: <20110914163455.fcc47a7aba8604c690988473@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__14_Sep_2011_16_34_55_+1000_Px=Vq+3FJW1ZxFZO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Sep_2011_16_34_55_+1000_Px=Vq+3FJW1ZxFZO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (powerpc allnoconfig)
produced this warning:

lib/atomic64.c: In function 'lock_addr':
lib/atomic64.c:42:2: warning: return from incompatible pointer type

Introduced by commit f59ca05871a0 ("locking, lib/atomic64: Annotate
atomic64_lock::lock as raw").  This function (which is declared to return
"spinlock_t *") is now returning "raw_spinlock_t *".
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__14_Sep_2011_16_34_55_+1000_Px=Vq+3FJW1ZxFZO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOcEsPAAoJEDMEi1NhKgbsOu0IAJYawYdd21/JCucnV04SRzsI
O5lnb0YANszBzsjQa1MBTWmy07TOB9/6Vp6WidHfdjUt8jbmYx+VnmvXSG+e5705
YnLt57jTDMTRU1wmyFR0FKDBKQ0b3+BNcCxXtyf9IPqKCPndMLFqx+2jROiA2LV9
pV283evIHM2VigYTDPajGypkgU1gFdzOAOpA0gA34HgYSfZrK98U+OSnU4oGMtiM
Gwy4RfeUtKIOfSaocCK+ydB9+gxW9Wfcz8zpCRtcW2HvfGnXmQHbcnCZWCkWw8QC
0Pk10ZhoX+RfCea6OeCE082wgBC6O6AqmFyjFoEzQswgcja9afOpY9/L+nW4Zec=
=RYPS
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Sep_2011_16_34_55_+1000_Px=Vq+3FJW1ZxFZO--
