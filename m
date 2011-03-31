Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216Ab1CaTPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 15:15:19 -0400
Received: from wnohang.net ([178.79.154.173]:42521 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759205Ab1CaTPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 15:15:16 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 1E5D5249FC
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 94B42247C3
Date: Fri, 1 Apr 2011 00:45:07 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Michael Witten <mfwitten@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use the environment variable PYTHON if defined
Message-ID: <20110331191507.GA5052@Xye>
References: <20110326224408.GA1336@Xye>
 <20110328144721.GB17872@ghostprotocols.net>
 <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com>
 <20110329181524.GA5140@Xye>
 <AANLkTi=3Wq3Xt-QFR-FLRQ1kBjpWjaBZNFpOiE_T15WH@mail.gmail.com>
 <20110329204024.GA20824@ghostprotocols.net>
 <AANLkTinmXdmNX+iCB4svo3QqR6AcwGrasziFJPeu0J=M@mail.gmail.com>
 <20110329211437.GB20824@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s/l3CgOIzMHHjg/5"
Content-Disposition: inline
In-Reply-To: <20110329211437.GB20824@ghostprotocols.net>
X-Operating-System: Arch linux x86_64 2.6.38.2-bldit-db-FAE
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s/l3CgOIzMHHjg/5
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,
     Regarding the point where it warns about python-devel not existing,
it looks like that existing feature test will pass even when python3 is=20
chosen and fail at a later stage. So I made this little change to feature t=
est=20
so that it fails when python3 is chosen and perf build succeeds with the wa=
rning
printed rather than failing later.
* On Tue, Mar 29, 2011 at 06:14:37PM -0300, Arnaldo Carvalho de Melo <acme@=
ghostprotocols.net> wrote:
>Em Tue, Mar 29, 2011 at 04:02:07PM -0500, Michael Witten escreveu:
>> On Tue, Mar 29, 2011 at 15:40, Arnaldo Carvalho de Melo
>> <acme@ghostprotocols.net> wrote:
>> > I think that the best course of action is to emit a warning and go

>> Good.

>> I'll make it so!
>
>Thanks.

--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: quoted-printable

=46rom: Raghavendra D Prabhu <rprabhu@wnohang.net>
Date: Fri, 1 Apr 2011 00:17:36 +0530
Subject: [PATCH] Added a py3k test to feature tests.

Currently, make fails at a later stage when python-devel test succeeds
incorrectly for Py3k. This fixes that.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 tools/perf/feature-tests.mak |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/feature-tests.mak b/tools/perf/feature-tests.mak
index b041ca6..ba287c9 100644
--- a/tools/perf/feature-tests.mak
+++ b/tools/perf/feature-tests.mak
@@ -84,6 +84,8 @@ define SOURCE_PYTHON_EMBED
=20
 int main(void)
 {
+	if (PY_VERSION_HEX >=3D 0x03000000)
+		return 1;
 	Py_Initialize();
 	return 0;
 }
--=20
1.7.4.2


--2fHTh5uZTiUOsy+g--

--s/l3CgOIzMHHjg/5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNlNK7AAoJEKYW3KHXK+l3w0EIAKEWd5HaXcL6w5RuMOobS9Q0
AsjaIkR79+4VgzHSgB3TrQq++hxfKun3q8icsJfSPSkDW5co49L7P89ytHPLK/jc
Wr3Dk06H2uNqLtzuCl/PfsHX3KdnslriLlO6b2ChaAv6L0z9M/nMrkoJ5byfWjTu
ADk8ijjc3dD7gkvZ2l06eEfSBhKg5sVmGpBFCxFbz2ZSyyLw9KF5wzS1SqTnCzpL
M8HWXGsKWaJsI6rFbaEODupMKUsTJyn+2WCWn64g46B8+ft0ZeqmZQUw3v7XbnEW
pgR4gcgrzThcRsmgjwnLUedEWn6eAUtbcGHxvYALStpdUX9tzmSc0u6Ti/TB9dE=
=ls2d
-----END PGP SIGNATURE-----

--s/l3CgOIzMHHjg/5--
