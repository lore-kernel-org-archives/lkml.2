Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2BFEX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 23:23:59 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:34896 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab2BFEX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 23:23:57 -0500
Date: Mon, 6 Feb 2012 15:23:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Hans J. Koch" <hjk@linutronix.de>,
        Torben Hohn <torbenh@linutronix.de>
Subject: linux-next: build failure after merge of the final tree (gpio tree
 related)
Message-Id: <20120206152346.106057d7dd747d0daa47bbc8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_Feb_2012_15_23_46_+1100_Rtl8imGifQLMA9U6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Feb_2012_15_23_46_+1100_Rtl8imGifQLMA9U6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/gpio/gpio-sodaville.c:130:2: error: unknown field 'dt_translate' sp=
ecified in initializer
drivers/gpio/gpio-sodaville.c:130:2: warning: initialization from incompati=
ble pointer type [enabled by default]
drivers/gpio/gpio-sodaville.c:130:2: warning: (near initialization for 'irq=
_domain_sdv_ops.match') [enabled by default]
drivers/gpio/gpio-sodaville.c: In function 'sdv_register_irqsupport':
drivers/gpio/gpio-sodaville.c:152:8: error: 'struct irq_domain' has no memb=
er named 'irq_base'
drivers/gpio/gpio-sodaville.c:182:2: error: implicit declaration of functio=
n 'irq_domain_add' [-Werror=3Dimplicit-function-declaration]
drivers/gpio/gpio-sodaville.c: In function 'sdv_gpio_remove':
drivers/gpio/gpio-sodaville.c:263:2: error: implicit declaration of functio=
n 'irq_domain_del' [-Werror=3Dimplicit-function-declaration]

Caused by commit 8b26c833d229 ("gpio: Add a driver for Sodaville GPIO
controller") interacting with the irqdomain tree changes.

I have reverted that commit for today.  I am not sure how you should
handle this ... you could send me a fixup patch that I should apply as a
merge fix when merging the irqdomain tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__6_Feb_2012_15_23_46_+1100_Rtl8imGifQLMA9U6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPL1XSAAoJEECxmPOUX5FE0WcP/iHL5wOebOQfPUhsR8N6Ab65
IohiTVdQsMLpfQ/+ktpQFu09Zw93LUgcJmWld29bUKdwbYQBK6R2U0Oa022eB4rO
nstMJ09cG8HeBZhcGV+cBt8MO+IOgqtbhrPqIo2M09OKrsspHupMpJ2SyU7v4eCN
lsHMJXZ1jTmy85ICT9f5nNxAdOrHFVhiJ3lSTKCgC2JcVlGJj2w209ctRzEf0dNF
EKmh1296v4tz4A3Z6XOIUYktxvcV28MQTiJGbn/bUsYfa43Jv9/3XerxHdbBTI9M
/YIaUCVf33Ty2BVHq8fwwKvptRm27NevBd/NybrqbqAP7iyl28dPK3ok2smW/PDJ
CJz6BDzdL2yqOnOyKzASe+q6uedNu61R9s/Vn56un0ohwL9cBKKqn/KXpEIGBpne
nHmRRU6MtxsFUDNXSw34+VssXaNp95Ctve/mBkgB9d6uL4J+vLDDeTEctp6mQJI6
+IBh0z70murNGYqQAS0+IRawnW1dw204Z/uOL1vM53PSo6ulnGqtPPjomMobnX4Q
mqJ35UwEGqAdjzKLVXYuLdyn0jx0UGzG/w79oFvalc4/nGtPseTouktNIjr3EfbF
NVHtCcy5KYTuyssqbW/9oZOS1ZdZ2j90JeJhWj2xSi/NKB1L8iUNO1LWAsZxM3L6
5+xlFJxlFGAXFUi+NUE7
=svfX
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Feb_2012_15_23_46_+1100_Rtl8imGifQLMA9U6--
