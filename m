Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab2GSEgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 00:36:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58051 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab2GSEgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 00:36:37 -0400
Date: Thu, 19 Jul 2012 14:36:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: build failure after merge of the tty tree
Message-Id: <20120719143627.adc9d5e5333449d6c8588a99@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__19_Jul_2012_14_36_27_+1000_S2nEvJqwS=ePn2/D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Jul_2012_14_36_27_+1000_S2nEvJqwS=ePn2/D
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/char/pcmcia/synclink_cs.c: In function 'shutdown':
drivers/char/pcmcia/synclink_cs.c:1347:27: error: invalid type argument of =
'->' (have 'struct ktermios')
drivers/char/pcmcia/synclink_cs.c: In function 'mgslpc_program_hw':
drivers/char/pcmcia/synclink_cs.c:1388:45: error: invalid type argument of =
'->' (have 'struct ktermios')
drivers/char/pcmcia/synclink_cs.c: In function 'mgslpc_change_params':
drivers/char/pcmcia/synclink_cs.c:1401:14: error: wrong type argument to un=
ary exclamation mark
drivers/char/pcmcia/synclink_cs.c:1408:22: error: invalid type argument of =
'->' (have 'struct ktermios')
drivers/char/pcmcia/synclink_cs.c: In function 'mgslpc_throttle':
drivers/char/pcmcia/synclink_cs.c:1731:19: error: invalid type argument of =
'->' (have 'struct ktermios')
drivers/char/pcmcia/synclink_cs.c: In function 'mgslpc_unthrottle':
drivers/char/pcmcia/synclink_cs.c:1760:19: error: invalid type argument of =
'->' (have 'struct ktermios')
drivers/char/pcmcia/synclink_cs.c: In function 'mgslpc_set_termios':
drivers/char/pcmcia/synclink_cs.c:2296:19: error: invalid type argument of =
'->' (have 'struct ktermios')
drivers/char/pcmcia/synclink_cs.c:2297:10: error: invalid type argument of =
'->' (have 'struct ktermios')
drivers/char/pcmcia/synclink_cs.c:2305:20: error: invalid type argument of =
'->' (have 'struct ktermios')
drivers/char/pcmcia/synclink_cs.c:2314:18: error: invalid type argument of =
'->' (have 'struct ktermios')
drivers/char/pcmcia/synclink_cs.c:2316:22: error: invalid type argument of =
'->' (have 'struct ktermios')
drivers/char/pcmcia/synclink_cs.c:2327:20: error: invalid type argument of =
'->' (have 'struct ktermios')

Caused by commit adc8d746caa6 ("tty: move the termios object into the
tty").  Grep and build testing are your friends ...

I have used the tty tree from next-20120712 again for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__19_Jul_2012_14_36_27_+1000_S2nEvJqwS=ePn2/D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQB47LAAoJEECxmPOUX5FEQCoP/2y5eAvx3O84sDZaSV1BS30q
79xYK5T4ax2YDKn+cdayCmu0q2B72XShEPZ9eSO2VnVRPV3KcJyV4+gnLU0Mk1/X
bK3rZGqyvYFZBBaSr4M6YwG2S8Fml5jIFJlawBMsogTEzVdna2vAfYwGcZjdnv+K
FM28IsyU7WEl18Um6Y4yA/m6OB8QrD2q63D8hMq6jtpe8pXMRzd9LomshWcJxZTm
6nxBqc5+F+//UyJmxwnzSZ1ZFHZGSkfe99U0xUR93FuBVrcg6Aeff49O2NMcIWPx
jQm82kgzXLXRPocq1S6CHXN9j+FSL3ZC/OcT97fZjraVVVDhX9XcGCvTdLCIntSr
m5opUuWRAx+thyFdWbNAcejFzmOu+SYdMtEjNvNpvErTRrHQjXnAN/e1B1lfBhvX
+AZd2vwpQAuNI9jJrdVZFpciZaQVUvinI3Z0FEwjQY6C0hir9J+u6Frlt2PIaHte
mtS2wEE0VN6q4CBmspywNA4DTCaayuCdkLd56/qgzwLzvQEo5fGKkeVxX1BkD3bi
DOwx0c2PbVXl462+yTsUBssrM0GDuMwdpMtrhfXTm9tv8vHer9rk6XzE4k3LBsSV
G8FYcEspbcJ5MNGrE+pb/uUoDFPjwMU/4eeHjx8+N6VUuS9ep10XkjaFwllfXmL2
sxB8UGJtDFcZZ0jpaXXT
=h345
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Jul_2012_14_36_27_+1000_S2nEvJqwS=ePn2/D--
