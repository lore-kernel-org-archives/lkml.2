Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab1DBUqj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 16:46:39 -0400
Received: from wnohang.net ([178.79.154.173]:57605 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756239Ab1DBUqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 16:46:38 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 2F5EE24142
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net A3F162400A
Date: Sun, 3 Apr 2011 02:16:31 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: Michael Witten <mfwitten@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use the environment variable PYTHON if defined
Message-ID: <20110402204630.GA5738@Xye>
References: <20110326224408.GA1336@Xye>
 <20110328144721.GB17872@ghostprotocols.net>
 <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com>
 <20110329181524.GA5140@Xye>
 <AANLkTi=3Wq3Xt-QFR-FLRQ1kBjpWjaBZNFpOiE_T15WH@mail.gmail.com>
 <20110329204024.GA20824@ghostprotocols.net>
 <AANLkTinmXdmNX+iCB4svo3QqR6AcwGrasziFJPeu0J=M@mail.gmail.com>
 <20110329211437.GB20824@ghostprotocols.net>
 <20110331191507.GA5052@Xye>
 <AANLkTi=8YiYNUj0o4=XqrRqmNjUq7zPXVEpsysJ6KbMx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TYecfFk8j8mZq+dy"
Content-Disposition: inline
In-Reply-To: <AANLkTi=8YiYNUj0o4=XqrRqmNjUq7zPXVEpsysJ6KbMx@mail.gmail.com>
X-Operating-System: Arch linux x86_64 2.6.38.2-bldit-db-FAE
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TYecfFk8j8mZq+dy
Content-Type: multipart/mixed; boundary="b5gNqxB1S1yM7hjW"
Content-Disposition: inline


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* On Thu, Mar 31, 2011 at 03:29:12PM -0500, Michael Witten <mfwitten@gmail.=
com> wrote:
>On Thu, Mar 31, 2011 at 14:15, Raghavendra D Prabhu <rprabhu@wnohang.net> =
wrote:
>> Hi,
>> =A0 =A0Regarding the point where it warns about python-devel not existin=
g,
>> it looks like that existing feature test will pass even when python3 is
>> chosen and fail at a later stage. So I made this little change to feature
>> test so that it fails when python3 is chosen and perf build succeeds with
>> the war ning printed rather than failing later.
>
>Good point.
>
>However, try-cc does not run the resulting program after
>compiling it, so the test still succeeds.
>
>What you want to do is make the compilation fail;
>to do so, move your test here:
>
>  #include <Python.h>
>
>  #if PY_VERSION_HEX >=3D 0x03000000
>    #error "Python 3 is not yet supported; set PYTHON{,_CONFIG}"
>
>  int main(void)
>  ...
>
>P.S.
>Put your replies below the email quote.
Thanks. I have attached the corrected patch and also have tested it.
--------------------------
Raghavendra Prabhu
GPG ID:D72BE977


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-Added-a-py3k-test-to-feature-tests.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 8c52bc1f2acb16d3bc12ea43c82665ebef93285a Mon Sep 17 00:00:00 2001
=46rom: Raghavendra D Prabhu <rprabhu@wnohang.net>
Date: Sun, 3 Apr 2011 01:59:12 +0530
Subject: [PATCH] Added a py3k test to feature tests.

Currently, make fails at a later stage when python-devel test succeeds
incorrectly for Py3k. This fixes that.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 tools/perf/feature-tests.mak |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/feature-tests.mak b/tools/perf/feature-tests.mak
index b041ca6..8e5d16a 100644
--- a/tools/perf/feature-tests.mak
+++ b/tools/perf/feature-tests.mak
@@ -82,6 +82,10 @@ ifndef NO_LIBPYTHON
 define SOURCE_PYTHON_EMBED
 #include <Python.h>
=20
+#if PY_VERSION_HEX >=3D 0x03000000
+	#error "Python 3 is not yet supported; set PYTHON{,_CONFIG}"
+#endif
+
 int main(void)
 {
 	Py_Initialize();
--=20
1.7.4.2


--b5gNqxB1S1yM7hjW--

--TYecfFk8j8mZq+dy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNl4smAAoJEKYW3KHXK+l3d4IIAJ9oash0ah3SbRbwSmnC4QwC
sMewCnjKRK3mF2U+pTPCWQZ1Z7pJD+Ajg+4i3QeItO3Iz4Dojo/VK/HrRcaTS+b7
1vkF+s9aV9tbYBLWdpg49PaF79EuLato19NG/57KaXQe8WQI1F4ym1i06VIb3wPE
kFTcFM+zIgcrfKWGSxSTXXj+vYTWlcqVwljiEVEYqetRPfE6kDzVk+UcmDYZQPR9
1BeKC61GekENYhPquXNBNXkmVF2qTT5u3MvTN1ueMpgPN8Np5gCBZgPhwE+yuS1j
NQ5n09iUz1SlqiQDmu8D596AV4rpfO1vAlhndy63P8LxXvvAntHffIw/rt+oSDQ=
=ItR8
-----END PGP SIGNATURE-----

--TYecfFk8j8mZq+dy--
