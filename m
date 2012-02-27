Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab2B0HGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 02:06:06 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:43160 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2B0HGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 02:06:04 -0500
Date: Mon, 27 Feb 2012 18:06:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20120227180601.bc286be07ce32fcf01725410@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__27_Feb_2012_18_06_01_+1100__ds9/X/cdw4+7Ost"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Feb_2012_18_06_01_+1100__ds9/X/cdw4+7Ost
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
failed like this:

drivers/tty/vt/keyboard.c: In function 'vt_do_diacrit':
drivers/tty/vt/keyboard.c:1500:3: error: implicit declaration of function '=
put_user' [-Werror=3Dimplicit-function-declaration]
drivers/tty/vt/keyboard.c:1502:3: error: implicit declaration of function '=
copy_to_user' [-Werror=3Dimplicit-function-declaration]
drivers/tty/vt/keyboard.c:1545:3: error: implicit declaration of function '=
get_user' [-Werror=3Dimplicit-function-declaration]
drivers/tty/vt/keyboard.c:1556:4: error: implicit declaration of function '=
copy_from_user' [-Werror=3Dimplicit-function-declaration]

Caused by commit 247ff8e610cb ("vt: lock the accent table") from the tty
tree.

I have reverted that patch for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__27_Feb_2012_18_06_01_+1100__ds9/X/cdw4+7Ost
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPSytZAAoJEECxmPOUX5FE6wsP/Ai39DaxoHHMNmP6t2josmw+
itNPolVPRMvdoM+4hbtQYULfsuZiG5GlYjO8zZmru9sK/EhULzrxWCwLdgs/Gx2S
/lG6okt/yARjquVdYFnF30AcDTqrmHMBir0FJ5J9SJWL2YfpsaZZeO/8UIwW/LHW
rpNMdLKjUaAdA5L7izxG5iZpSZh5GrCo//VeD+b+8hBDmL9SV0PX6h6t4tNOwD0A
WR8sN0eTrh64/nPe9NnvX1wT21QnamF8fXa6Stm4EtMWK40+PxwHarOH5yJZBvqb
ICRAZt9w0IZ53Fz3yjed5w/8/ezgxASO0OQyMBMflVujrZ/Eh4qX+BB+d3yEEVVK
bMpZl328lo09SF2lZQJYI7XxmeQ6jbLBsFyGWVdb/t4TqjM4N/g9FZ03pGjsEPYc
Xg61eALJ22W7ByHy7VS1AYAZlK42LtDX/feScZNvZ5kpwsPp7IYmmYlzaooft1Pa
cNqhHO/AV8RafN5D9QMYXq71+4KWKBAlthaWCtUA58oPnXSJtVYcnt6txK+4jYy5
3LNMZ4R6RiWD/yDgr9J8jg0xqe0sQLkAKknJABMZGiTlU570x7MVH+jAxBJoS4yl
YZ7zlhKKMKMmWGyMyZ6ipEsrGrYql25xFxb4sZr2QYyR1tGDt1s8tVFEicXjGuAS
JdrWcJuEKrJcrS+04Up9
=hmO+
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Feb_2012_18_06_01_+1100__ds9/X/cdw4+7Ost--
