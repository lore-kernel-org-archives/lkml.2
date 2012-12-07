Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945928Ab2LGCGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 21:06:54 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40940 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424855Ab2LGCGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 21:06:52 -0500
Date: Fri, 7 Dec 2012 13:06:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hauke Mehrtens <hauke@hauke-m.de>, Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the wireless-next tree with the mips
 tree
Message-Id: <20121207130640.f470f4d054bfb1dda95732ab@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Dec_2012_13_06_40_+1100_M4/vSIwrtsoMXtyM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Dec_2012_13_06_40_+1100_M4/vSIwrtsoMXtyM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
include/linux/bcma/bcma_driver_chipcommon.h between commits ef85fb28305f
("bcma: add locking around GPIO register accesses") and cf0936b06d8e
("bcma: add GPIO driver") from the mips tree and commits a22a3114a820
("bcma: add methods for watchdog driver") and a4855f39d4eb ("bcma:
register watchdog driver") from the wireless-next tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/bcma/bcma_driver_chipcommon.h
index a74e33f,e513591..0000000
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@@ -1,7 -1,7 +1,8 @@@
  #ifndef LINUX_BCMA_DRIVER_CC_H_
  #define LINUX_BCMA_DRIVER_CC_H_
 =20
 +#include <linux/gpio.h>
+ #include <linux/platform_device.h>
 =20
  /** ChipCommon core registers. **/
  #define BCMA_CC_ID			0x0000
@@@ -572,12 -572,8 +573,14 @@@ struct bcma_drv_cc=20
  	int nr_serial_ports;
  	struct bcma_serial_port serial_ports[4];
  #endif /* CONFIG_BCMA_DRIVER_MIPS */
+ 	u32 ticks_per_ms;
+ 	struct platform_device *watchdog;
 +
 +	/* Lock for GPIO register access. */
 +	spinlock_t gpio_lock;
 +#ifdef CONFIG_BCMA_DRIVER_GPIO
 +	struct gpio_chip gpio;
 +#endif
  };
 =20
  /* Register access */

--Signature=_Fri__7_Dec_2012_13_06_40_+1100_M4/vSIwrtsoMXtyM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQwU8wAAoJEECxmPOUX5FEQuEQAJHPxBYFsaVsfztTLUWbogJ9
ySewUMGc+IURt7Ww0QswY3zAhTMlV5w5YNa/Jpnscm6rrWPM75oUmu9qsyb2f93z
H5/ImMV/Lsoq4+Heh41yDR+O0gy8mtePqiBVSwXgCsGDm/Bj5v0mcHlsuWNsbKp5
UzB9Ry06TE5qJI4PvYA1WPGPXywWskVPSEk925ObfXN4kXfZVjBzuHyRjrWw2zDt
RU6GJ16WtfIavVLmhTAp8vCYMmZSSpivqzj82Wq8dXB8ldpZ50HiUjMHdrFFdtzY
RB8oX19nqKD415gsgVwN8MZj+VmQ2gGrXNZvwCHKqRTl5CpSOt9cQzJ/GGSURYaR
owWXG8qGBUUKeZtcfUkxRBUl2z8yXXMFjmT5bPn6yWWO45XijYpVX1wmNoLY2fyJ
UT4bkkU3R8z61FBYlmgEgjZhVAe9CZXbUG2vdEZBUnqeeobyth4lL57MocusR+00
ZIPuxMs6VYPq65QajRX6/iCQDc22g4QTq1OT9pKK9I8cR7Xq0YW+ssPvguho2fjq
ip3aCxqBTLpJGMpsVOO9Rtu3TavBqJ4C20iTEZAwA3u+iexLUba3BQ+ZxSbYBZf4
/5pzaSfRPC3dpATWefOs6fzyXUStF/QtZ+L2kw9QJz1vFvMfTWiznwNh8IFBt21p
pIoT5rPpcy11Nd01pCFT
=uEtt
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Dec_2012_13_06_40_+1100_M4/vSIwrtsoMXtyM--
