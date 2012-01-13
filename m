Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472Ab2AMXYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 18:24:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56230 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2AMXYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 18:24:21 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=NU-xHg3WDFYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=TnNvcMg5ZYGZWy9hj5IA:9 a=QEXdDO2ut3YA:10 a=PY4h83kcmz8-3f8ftuMA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120113231158.364436936@goodmis.org>
User-Agent: quilt/0.50-1
Date: Fri, 13 Jan 2012 18:11:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Lange <thomas-lange2@gmx.de>
Subject: [PATCH 0/2] kconfig/streamline-config.pl: Fix missed module loaded
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Linus,

I received a bug report from Thomas Lange, saying that after doing
a "make localmodconfig" his module 'brcmsmac' was missing. He tried
this on a few different kernels and said that it was always turning
off this module even though he had it loaded during the make localmodconfig.

I looked into it and found that that Makefile uses a variable to set
the module name:

obj-$(CONFIG_BRCMSMAC)  +=3D $(MODULEPFX).o

These two patches make localmodconfig handle this case.

The first patch is a clean up that makes the second patch easier to do.

I'm also sending these to stable.

-- Steve

Please pull the latest for-linus tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-kconfig.git
for-linus

Head SHA1: 364212fddaaa60c5a64f67a0f5624ad996ecc8a0


Steven Rostedt (2):
      kconfig/streamline-config.pl: Simplify backslash line concatination
      kconfig/streamline-config.pl: Fix parsing Makefile with variables

----
 scripts/kconfig/streamline_config.pl |   52 ++++++++++++++++++++++++++----=
----
 1 files changed, 40 insertions(+), 12 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPEL0fAAoJEIy3vGnGbaoAOhUQANtqO9GLs/L34FTqYtWs4xC0
VC6b0qs9i3hgvuWoFuxZEvqtA95/A8IAxZ5UsDe8NrE+GHVmZn5c17lfC+DxECEC
L2sr+LxJiO15j/8PrMuyzbg3LRnMslIynOkjX9HcOxYYWPBqBIaYZRTRFHhMx3UB
DB5IVOS8JuwvemATnvk6NIiEPzXVXoCdDCB6eydv1VXwPQgD95PdvMhk/nUo7iRm
E6m1gYpRcNOhLgNTsfNqCWhICgU607irUM/rjS/DE2ll+iujWH/ISZoAEUpL4A/N
8K3Igu9fqTbDjC4L5Vg761C444iJNZ/u7PnhAA9aLW0ua0vMqH21PEB1vhKpRjiG
fBX75WYWD9JbC6vI1bWHMo6O2Dd0r6oJTM33M5mzhxUYlXBpGxg5TVwgSjoq62h5
fbCzEDUmMnn5xRmEfrQr9MSzMm4x4DWJBj0/8BCTrkAgmGCUAaos4ksQw5jOpHLM
+XM6EzAucZRb4KwWHAm+Cv4Rq5mTCNPpHsF4N2F1fKFwuMP/5TJvn2anRTvBjDAk
bf/QOzjwRuNnpTdM14s1HbGCEsMHDFARCzpQG+48oejNI93kZfj3DgX/FYVREP9G
g1HDo+2h+slyMi0dwczInAYoczFQ01o11dDgfS/hzLa48W07tB5BnHs3zcKUrt9A
MsooaocHlhleSaXtyy12
=tHAS
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
