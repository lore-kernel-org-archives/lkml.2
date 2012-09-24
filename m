Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab2IXGgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 02:36:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54326 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab2IXGgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 02:36:18 -0400
Date: Mon, 24 Sep 2012 16:36:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Sourav Poddar <sourav.poddar@ti.com>
Subject: linux-next: manual merge of the tty tree with the workqueues tree
Message-Id: <20120924163609.4f274e6340b92cea66eceb40@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_16_36_09_+1000_R7FEWjtx0jNh/26L"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_16_36_09_+1000_R7FEWjtx0jNh/26L
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/tty/serial/omap-serial.c between commit 43829731dd37 ("workqueue:
deprecate flush[_delayed]_work_sync()") from the workqueues tree and
commit ac57e7f38ea6 ("serial: omap: Remove unnecessary checks from
suspend/resume") from the tty tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/tty/serial/omap-serial.c
index 0952d71,3c05c5e..0000000
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@@ -1203,10 -1222,8 +1222,8 @@@ static int serial_omap_suspend(struct d
  {
  	struct uart_omap_port *up =3D dev_get_drvdata(dev);
 =20
- 	if (up) {
- 		uart_suspend_port(&serial_omap_reg, &up->port);
- 		flush_work(&up->qos_work);
- 	}
+ 	uart_suspend_port(&serial_omap_reg, &up->port);
 -	flush_work_sync(&up->qos_work);
++	flush_work(&up->qos_work);
 =20
  	return 0;
  }

--Signature=_Mon__24_Sep_2012_16_36_09_+1000_R7FEWjtx0jNh/26L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQX/9ZAAoJEECxmPOUX5FEYKsQAJaXXkvFVrle/yllu8Cm6BCp
10A2nurIlQAKwWs/lgJMs6/mhmjoF2f4ia+Eaxa0YuuMptwZM0u1qPErrHYMbLrc
YkgetlZ+3P3PDFAIBA/Rw7VPtoj5s83+p7g40fuDXKJsqlLH/9130Gbner3Kxcpo
fjTMskiLo5Ph0tTlU4004MkUdaRtsdJXr/kCiZPVBWjtGbj7BqBCm3AFJapxFGZn
8n7sOkU9NJamk31fI8GVmCNZDAxcNzP+13Uo4fPS2wlYP6LjPZC0XkAyFgzs/YBr
QNgoKv+3ZoovXii8SNOv3WRWyOrIxOm5SeXaSJQ/a6KQNDDnmd9jxs0kBP0N3ywe
sXbEn/0cpdp04rA9S0qUEjIMi+OmGpKyXhNRW/p2mihU1lRAXZyeIlfYUENe7ZON
X65/qsIXaXqsj+GAm376e/TnDeDBMKNEg/V58Ag1A+La7uzhSLytb1Fnq3ihk1bo
jhJjb8THLSDfdBeXTugZOnNotISdOep9+5LZXMSYGVOYfetRFdec4P8mslgwMjX1
ih6BjAlWTB+HIYTXDaNKmo52f+NbVY4ZnDuKAIUD+4nLD7iIgAOejgs0x6kPrHyY
sna5K6mFnmGEk/pshNQQ+2nO/ScMRoS/O1k4aJdRhlbU7davop25j5IGtsLTucP9
SmBs5/uxihsUgPv9eQDW
=41Lk
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_16_36_09_+1000_R7FEWjtx0jNh/26L--
