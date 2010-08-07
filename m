Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab0HGEVd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 00:21:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35968 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab0HGEV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 00:21:29 -0400
Date: Sat, 7 Aug 2010 14:21:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build error after merge of the kgdb tree
Message-Id: <20100807142122.a305ed8a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__7_Aug_2010_14_21_22_+1000_Zm+dLh6GMdwB1KIE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__7_Aug_2010_14_21_22_+1000_Zm+dLh6GMdwB1KIE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jason,

After merging the kgdb tree, today's linux-next build (powerpc
ppc64_defconfig) produced this error (and hundreds of similar
errors/warnings):

In file included from include/linux/rculist.h:10,
                 from include/linux/dcache.h:6,
                 from include/linux/fs.h:375,
                 from include/linux/security.h:25,
                 from security/min_addr.c:3:
include/linux/rcupdate.h:606: warning: function declaration isn't a prototy=
pe

Caused by commit 9e213357d0aeaeb81e213cfd3b9415db5fccc1b5
("rcu,debug_core: allow the kernel debugger to reset the rcu stall
timer").  Some of these are errors because powerpc builds arch/powerpc
with -Werror.

I have used the kgdb tree from next-20100806 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__7_Aug_2010_14_21_22_+1000_Zm+dLh6GMdwB1KIE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMXN9CAAoJEDMEi1NhKgbsPjgH/1ts7bskMSBwlyoMPRJrmwXG
fLxfRI8wj7IPndDk4SfvVQD1eKVVZP3rAtF9LfJVlJ52NBBuImu7VbVEbMn90pVk
HMnXiACRMYhtTOAHD3hAe6tJFuiyclGFfcAcyaQFPzEs/1A/0Re8jn2ku43x+KBn
+kBgQaJJXK/cvSclA26uij+rn8DOP04NKHa4Aivlm4FdWCY3zJNLZx3EYNmItYfh
StQdjHJw0QYmAvOLBbgLn0sokQMMDXs13tLhhgxdKyVl756JlbpWpoce8g5cHfI9
Om4enpFJySxiJ5YY6jNPfDfTvnVHm//AK7sCV+BS4ETvkiKKxIS/2fV+cXJJYuU=
=1EUA
-----END PGP SIGNATURE-----

--Signature=_Sat__7_Aug_2010_14_21_22_+1000_Zm+dLh6GMdwB1KIE--
