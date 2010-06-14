Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab0FNLPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 07:15:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59830 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756162Ab0FNLPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 07:15:50 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Andy Whitcroft <apw@canonical.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1276513297-23306-1-git-send-email-apw@canonical.com>
References: <1276513297-23306-1-git-send-email-apw@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jae16fO5R1E7MsI4gal9"
Date: Mon, 14 Jun 2010 12:15:42 +0100
Message-ID: <1276514142.14011.329.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 1/1] docbook: need xmldoclinks for all doc types
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jae16fO5R1E7MsI4gal9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-06-14 at 12:01 +0100, Andy Whitcroft wrote:
> We need the xmldoclinks built for any document types built from the
> XML sources.
[...]

Yes, you're right, I don't know why I put xmldoclinks there.  It Worked
For Me when building the linux-doc package in Debian.

However, the dependencies you're introducing seem to assume a serial
make.  I think this (untested) change would get the dependencies right:

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefil=
e
index 9d6f1a4..e9d75e6 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -35,7 +35,7 @@ PS_METHOD	=3D $(prefer-db2x)
 PHONY +=3D xmldocs sgmldocs psdocs pdfdocs htmldocs mandocs installmandocs=
 cleandocs xmldoclinks
=20
 BOOKS :=3D $(addprefix $(obj)/,$(DOCBOOKS))
-xmldocs: $(BOOKS) xmldoclinks
+xmldocs: $(BOOKS)
 sgmldocs: xmldocs
=20
 PS :=3D $(patsubst %.xml, %.ps, $(BOOKS))
@@ -95,7 +95,7 @@ define rule_docproc
         ) > $(dir $@).$(notdir $@).cmd
 endef
=20
-%.xml: %.tmpl FORCE
+%.xml: %.tmpl xmldoclinks FORCE
 	$(call if_changed_rule,docproc)
=20
 ###
--- END ---

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-jae16fO5R1E7MsI4gal9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATBYPU+e/yOyVhhEJAQK4Uw//USvNJIogt5rrDleOaqg65fqNIDrGcib6
cw+UF6QbCKsmQvG78+cnmZ3qLckw9lrAOmp1cjs4358LKQLWz77EdyazIwKHbVxB
a4WHnswnaZXbs06fcTOmsMpZEdO+cDvOxGDygQFXajLGuxSxNZH58rEYjW06zyvE
2RKaH1YDu6TDwnI7H4VB6rerf/hjnXKhhi6WSnGI91wpQvo1JRVu3h01HWyr/1EG
LL5B1WKdIU+wVHzrOM+OdHKBwwGiaoUIf49IUdsdD/wFF+d/4KH0HQ1w7ghXtEiy
ELoMPyB/gu+llxUh7Aimw9hyKe3X4HytUSUjrnbDrD7nIfhie9R7ql+tTeznJPik
4dseTzBqe1pKu9hiN3pzFJvMGi0XFNGwjaUl1RljkFvQtsYBbElggwYDpdL09AnC
g8QJqXVFuMIPtey8t3ztqljNQmOqd2Hf1amY22bknfQu3lvPq4h6LyeRFxIilMjk
mxQmsCJOyuc4pJJntI+Mqv9zHYGoBN3mKCb5vO+fC4nL9gLAzqwN79zXf9Jb62v0
Lc5papqW8+9F5Exo5La1HpNtBQYw2SqdUR9MCHiEwuBEKYt2A0e7yAKXMWepBIy4
HCv/pNdP/4S4PcgE2NHsGK5J90i1UVT00Gph50tCGlFvA3eeMz6yaxhbR5l5zq31
uO0Y8k87osA=
=4qz3
-----END PGP SIGNATURE-----

--=-jae16fO5R1E7MsI4gal9--
