Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab2IMILn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:11:43 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42357 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab2IMILg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:11:36 -0400
Date: Thu, 13 Sep 2012 18:11:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Fries <david@fries.net>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20120913181127.862265ddb9a08758ada8405c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Sep_2012_18_11_27_+1000_nRiYuamSGOnGGKcu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Sep_2012_18_11_27_+1000_nRiYuamSGOnGGKcu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

drivers/built-in.o: In function `rtc_hctosys':
hctosys.c:(.init.text+0x4a98): undefined reference to `rtc_hctosys_ret'
hctosys.c:(.init.text+0x4b54): undefined reference to `rtc_hctosys_ret'
hctosys.c:(.init.text+0x4b58): undefined reference to `rtc_hctosys_ret'

Caused by commit "rtc_sysfs_show_hctosys(): display 0 if resume failed"
from the akpm tree.  rtc_hctosys_ret was moved into class.c but protected
by defined(CONFIG_PM) && defined(CONFIG_RTC_HCTOSYS_DEVICE) and this
build does not have CONFIG_PM set.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__13_Sep_2012_18_11_27_+1000_nRiYuamSGOnGGKcu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUZUvAAoJEECxmPOUX5FEAbwP/j5HkGY5jcCWCVaL8THaFOei
iWYpUcXq29dswNgz/60zTMsk6LewIgn3oVTv/cLufYCfeoXCgKP/zr8NSbL+sxG+
J5NEbMkZhhdcwthLMf3ViRKaPUc5hDkhCKvDW7AUyxwGgCfBGkf4YWSj4134UDMh
bhx1yvEbu4GeRZNVLxXGZ7TXV//jIZrxonEYTF6AJ83/reMzLIB6gvaxlUzUWd0Q
R+Zyu6Ku8WMZPSrneJ436tZZWiaPpgDhtUdeXk0WjDzhO7BZmDHiOS/o3sDz1iX/
c8qrtHgdevxPUm8ucJVA8Mz7BDTY26JZGn8buOQxTaO7TdnWBWS+ygqEJ9kCwBct
gCDuD+fdf19tzF9OxRUeEEIJ2w50T6sz0phZX5Y4FAXFKouTnZK6Okv6ZBSYZFYl
O8fm6QKEC5IJn7nALUiGyYbnqxVaCVuXNbcrqs+N7x3L7y9YHexcP+zmiHHy9OYn
hwlvxYBi3ftqrk0/yiDCsW+4AvKDy/zuQQy6BfaTRcqOdWAm+SwMVKysUDlTwYPh
GvJY7fPLNP9RYQsaLj2Oln7oUuRy4KBclgul6HliN1R/VsBd3f+ggW7x9SXtiu3a
qsOGZe1hXBb/tT/1FzVS+e+PujpDdrxWKrHjxxoBS0cs79JjgB/mCd61P5fLxOC0
sFsV5Ty+Jd7XPwgY5ob/
=kJoV
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Sep_2012_18_11_27_+1000_nRiYuamSGOnGGKcu--
