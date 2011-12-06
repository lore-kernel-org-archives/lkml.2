Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911Ab1LFEE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 23:04:59 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:49594 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932870Ab1LFEE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 23:04:58 -0500
Date: Tue, 6 Dec 2011 15:04:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20111206150445.258f8eb2ea76d5dd321112db@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_Dec_2011_15_04_45_+1100_am1pLytMnE.MLSqR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Dec_2011_15_04_45_+1100_am1pLytMnE.MLSqR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
kernel/Makefile between commit 029632fbb7b7 ("sched: Make separate
sched*.c translation units") from the tip tree and commit f7243fa71a4c
("brlocks/lglocks: clean up code") from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/Makefile
index 4363a41,d173c0c..0000000
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@@ -9,8 -9,9 +9,8 @@@ obj-y     =3D fork.o exec_domain.o panic.
  	    rcupdate.o extable.o params.o posix-timers.o \
  	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
  	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 -	    notifier.o ksysfs.o sched_clock.o cred.o \
 -	    async.o range.o
 -obj-y +=3D groups.o lglock.o
 +	    notifier.o ksysfs.o cred.o \
- 	    async.o range.o groups.o
++	    async.o range.o groups.o lglock.o
 =20
  ifdef CONFIG_FUNCTION_TRACER
  # Do not trace debug files and internal ftrace files

--Signature=_Tue__6_Dec_2011_15_04_45_+1100_am1pLytMnE.MLSqR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO3ZRdAAoJEECxmPOUX5FEZkkP/1FgBJKEX1ygKjtJJscASWz7
M3koNETSgHw/aZYKL/QndAZViC2c+1UZT0+lHCXgbF1ioAe0OvRlRusFFJfZryI3
cM2NPvixJeRjE5NwfBNfntaUDAktARXCLY0DSAOKvw1F5wbv+5AJAqfqzOl0G6g0
VJV8YAguFmvn8SsMvyd7CMLaYDlOUD7BEWckKJEBq2mIYi1vP7+5YAm5gnFZrRII
oLXr4JZdu9jL0kAPF8i8LCSM/rW1bQWMTgXv6+C50CzVdvPFeA76loqi1qz+v+TD
X24YuT3j1b0Ed/TFbMgzMJbV99rOuYWa+yDHur6ywOzAZGIaSa8ZK2Xq2YYmkFt6
I5EuwuHX2EUzwihVshHZbf7M3HokBJIzOsxqZs6d8eOk7TVQa7fjdMhIKonWFp+V
dbLPup6UPqewJFEEs8+5SAf0sD8pP4l4igc1qUoo+dqupBCnU0jtao0BfX2TNS3J
HzGHVSfcI1Ku6klYXDaCUrxUvK2J2P/xJHiNHgP3LsK2figCnel9BQuFBRVSRTJ4
QbXSGZy7noYLcxwkKZOtqiykeeEta7BXmnhaWHH5iIZ0ya/Haq05NEIRGViKP2J/
2AE3fknubTp7qMG/U+rTeZEpA4LNKco35Dc2wvRg6xTuz1VY9b7C6lsm0Z9a+knM
iqMfWN7Kft2QEXDHp4kO
=haze
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Dec_2011_15_04_45_+1100_am1pLytMnE.MLSqR--
