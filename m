Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab1LRCIK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 21:08:10 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45909 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198Ab1LRCII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 21:08:08 -0500
Message-ID: <1324174076.2844.11.camel@deadeye>
Subject: [RFC][PATCH 1/2] firmware, module: Keep names of firmware blobs
 required by built-in drivers
From: Ben Hutchings <ben@decadent.org.uk>
To: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
Date: Sun, 18 Dec 2011 02:07:56 +0000
In-Reply-To: <1324173539.2844.9.camel@deadeye>
References: <1324173539.2844.9.camel@deadeye>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-NLUluxHECkDg6VW3iyzh"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NLUluxHECkDg6VW3iyzh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[This belongs before the previous patch, which should be considered
2/2.]

Change MODULE_FIRMWARE() to include the given blob name to the object
file even when not building a module.  Discard that information when
linking vmlinux.

This will allow us to stop repeating this information in
firmware/Makefile.
---
 include/asm-generic/vmlinux.lds.h |    1 +
 include/linux/module.h            |    7 +++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinu=
x.lds.h
index b5e2e4c..7d1f1d7 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -678,6 +678,7 @@
 	EXIT_CALL							\
 	*(.discard)							\
 	*(.discard.*)							\
+	*(.firmware_wanted)						\
 	}
=20
 /**
diff --git a/include/linux/module.h b/include/linux/module.h
index 3cb7839..2cc323d 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -176,7 +176,14 @@ extern const struct gtype##_id __mod_##gtype##_table		=
\
 /* Optional firmware file (or files) needed by the module
  * format is simply firmware file name.  Multiple firmware
  * files require multiple MODULE_FIRMWARE() specifiers */
+#ifdef MODULE
 #define MODULE_FIRMWARE(_firmware) MODULE_INFO(firmware, _firmware)
+#else
+#define MODULE_FIRMWARE(_firmware)					\
+	static const char __module_cat(firmware, __LINE__)[]		\
+	__used __attribute__((section(".firmware_wanted"), unused, aligned(1))) \
+	=3D _firmware
+#endif
=20
 /* Given an address, look for it in the exception tables */
 const struct exception_table_entry *search_exception_tables(unsigned long =
add);
--=20
1.7.7.3



--=-NLUluxHECkDg6VW3iyzh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATu1K/Oe/yOyVhhEJAQqTrBAAyE5GxaT+6Ve2Ylk33jWEPpNR+6He1bQ4
dQTirTRqwhYg+r4HHi7ftbMevpDJzSWORTuWk+ez2+3gfKHU9cxyoYxVypNW5pa8
BCmU40X7WcXjlCB5TKptEy02LuA0qVd3HNL5r8KjP+pNpWN5++7XGu3WhznZYKuO
jWg5fyBmjDUwNaMTClcprx33Da0ukYONo3aObhUlj8lTJ3x+nG/9+ediUs9kK7ty
4P8ll1H7bQFBQtrRv9GsfWhetW0DyYnNm9WH6n0andL5vHTMTxfAnbUBhWtwFKVi
A/SLwrfmjE5ae3npccLNrsHmR/ePeWIfBKw8q3fSHy5Stgul4EP/uteDb+aV90yd
Mq+RwgI49/Q2kOmHy2PQRfbwOPaLEnFOag2XU7GVUUC79jbCJDTvL/ub8MAzTbmn
LDR1o7jm6qMssxOEfuyS0M9keqs2ybPOnH1lj2xFZD/7RmMSJhyB+9SklUroNcOr
/sUpr7p313hGVifW9Xg44OYiEJAvhYnO0Ttc3//qxentQmUHhHVjA4mUNvf8TWW6
EwxQNcgFEWWFT4soSaPwaaMIHgu+4Lf56DyG/9x15GwyffZjPmflBwyYTqrEZaob
ZHzIEz0/WatB4vtBEs5t6IzoPLIxNpFPhScLMzZuvVJtM9UGxZMl6/X2rLIhXAeQ
+JoH90NSA8w=
=c/jP
-----END PGP SIGNATURE-----

--=-NLUluxHECkDg6VW3iyzh--
