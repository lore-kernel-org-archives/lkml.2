Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab0IIC6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 22:58:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44663 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab0IIC6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 22:58:45 -0400
Date: Thu, 9 Sep 2010 12:58:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bojan Smojver <bojan@rexursive.com>
Subject: linux-next: build failure after merge of the final tree (suspend
 tree related)
Message-Id: <20100909125838.6c82edc4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__9_Sep_2010_12_58_38_+1000_+od2_IVNiLLHl4nL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Sep_2010_12_58_38_+1000_+od2_IVNiLLHl4nL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

After merging the final tree, today's linux-next build (powerpc allyesconfi=
g)
failed like this:

kernel/power/swap.c: In function 'save_image_lzo':
kernel/power/swap.c:447: error: implicit declaration of function 'vmalloc'
kernel/power/swap.c:447: warning: assignment makes pointer from integer wit=
hout a cast
kernel/power/swap.c:454: warning: assignment makes pointer from integer wit=
hout a cast
kernel/power/swap.c:457: error: implicit declaration of function 'vfree'
kernel/power/swap.c:462: warning: assignment makes pointer from integer wit=
hout a cast
kernel/power/swap.c: In function 'load_image_lzo':
kernel/power/swap.c:767: warning: assignment makes pointer from integer wit=
hout a cast
kernel/power/swap.c:774: warning: assignment makes pointer from integer wit=
hout a cast

Caused by commit 2b2609c19ff19361360552786bd252ef40dfe5ce ("PM /
Hibernate: Compress hibernation image with LZO").

See Rule 1 in Documentation/SubmitChecklist.  There is a missing include
of linux/vmalloc.h.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__9_Sep_2010_12_58_38_+1000_+od2_IVNiLLHl4nL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMiE1eAAoJEDMEi1NhKgbsEOsH/iU1jjKH94H4ZWGXm+1Qc1Wj
/E1WvTQpUmZibauZC2riCkS9y9PykOEYsZu4rzHkE8vnZYS5XJzDlBRDw4rV4icp
BeVNQnYofoYLovvdVoMqocplU7rop2VzNwUJfjVw9bJIRePHk+Hqu7ful4u4AIuG
BH1m8Dh7htVrJ1xmUUxigAqzZ2M3CReT3MCfShGO1Hs1cmHaO3u2DxJg0PZXWZ/I
qcOu53R0kV0IRgLvwOeKs7c16sFPaXcocjHTLUE7jIoNdLQ9fs2sfFLnNmGsO6rk
IPmokcRPJ16X4f7Qg4+5PrjlAvXcIk2mDdxoXb8z3OAtx4Ap1Mcm2GXN7sXgXjg=
=Cww5
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Sep_2010_12_58_38_+1000_+od2_IVNiLLHl4nL--
