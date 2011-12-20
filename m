Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab1LTHZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 02:25:09 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:58876 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab1LTHZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 02:25:02 -0500
Date: Tue, 20 Dec 2011 18:24:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: linux-next: build warning after merge of the tip and rcu trees
Message-Id: <20111220182451.c08fa803f748f48101008661@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__20_Dec_2011_18_24_51_+1100_Tm6Eruw5cHrVg8CO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Dec_2011_18_24_51_+1100_Tm6Eruw5cHrVg8CO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

kernel/debug/kdb/kdb_support.c: In function 'kdb_task_state_char':
kernel/debug/kdb/kdb_support.c:639:2: warning: passing argument 1 of 'is_id=
le_task' discards 'const' qualifier from pointer target type [enabled by de=
fault]
include/linux/sched.h:2097:20: note: expected 'struct task_struct *' but ar=
gument is of type 'const struct task_struct *'

Introduced by commit 7fc20c5cbdd1 ("kdb: Make KDB use the new
is_idle_task() API").

This begs the question: Why does is_idle_task() not take a "const struct ta=
sk_struct *"?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__20_Dec_2011_18_24_51_+1100_Tm6Eruw5cHrVg8CO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO8DhDAAoJEECxmPOUX5FESBcQAJ0M6/gKDeRIY+LIuguSuiVZ
9JrXl1rqAdNpNL/ez1ecosIzHxCmZOMzZCrnMRzrSYN5OovPO6/9DEu0cD/hMdEr
XvFeUPouRfv/qria0FXcK9ra06VqBqBypo8/tf7wJdr5BQ+//IubuuLzB0TW+Dsj
MBvVO+mmiL45cTRkp5S6UV+Du3uO2v7Lxanr1lB240Eh1kjMvcCrqi4pLr7pUCNX
My6L9LqQdTH3qP9gK5IErcX0pRjwX9aIH/vVykg+iiqLxKLJyxQaV7Yud8RBRfN8
iCi5Mv9F4cS2RWdNi1IaU22ui1hBhZlCB8DmkYGohfrKNxuvj8CQiAexXooJ+wdr
sWVL8wGY0qyHNAu47Rn7w6Y0gyhmpPaaw3kjB1Yr9ktyn7nxI9hEqPVwT0E5zT7T
R5IEOX+80qrobUNyHdyAxbY0Wp/+QxKQuoCH0LU1RRq+fWRzGUWVvxiwzdZ8WAXT
hT0E2hCTuCvQDuX1yjhnVfZ5UHzZS8kgdE8D2TBNVHYJVH+O2/kMDGoyyGcQZ1fo
yRncTe6NYHnSzb3i2oZXxIqf3wZWMSknj3spff3EiudHMkSNJR0Ase3bIM/q8K0H
3+sWhhvzATYoYGjXTdB0wKGe0NuOwxoZO2ygacLZogJJ6bk2DLsx/jhcmgWEmPCC
j6GQAX2+0t1xpavQ7fLs
=l5Xj
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Dec_2011_18_24_51_+1100_Tm6Eruw5cHrVg8CO--
