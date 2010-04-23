Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab0DWKiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 06:38:18 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:34051 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab0DWKiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:38:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=oiarvcck+99bfkHEMs/XmUY6Ww77Y7OhT0JWNQfLpCpx+ThpvA2mhIxeBtnSyKX548
         SdzR23vUHNrygVmrIVi3wVMvDI4wEYy+p/nX8f/Wi9PugWlZ2854SoJ6Tm32Q0Y3h35F
         Iba2+ik3jwfktWr8RHh/YEkRjRMoQCTQrrrLQ=
Date: Fri, 23 Apr 2010 13:39:28 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] suppress warning =?utf-8?Q?fs=2Fqu?=
	=?utf-8?B?b3RhL2RxdW90LmM6MTM1OiDigJhxdW90YXR5cGVz?=
	=?utf-8?B?4oCZ?= defined but not used
Message-ID: <20100423103928.GA3293@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Suppress compilation warning: =E2=80=98quotatypes=E2=80=99 defined but not =
used.
quotatypes is used only when CONFIG_QUOTA_DEBUG or CONFIG_PRINT_QUOTA_WARNI=
NG
is/are defined.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 788b580..e6a2607 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -132,7 +132,10 @@ static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dq_s=
tate
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dq_data_lock);
 EXPORT_SYMBOL(dq_data_lock);

-static char *quotatypes[] =3D INITQFNAMES;
+#if defined(CONFIG_QUOTA_DEBUG) || defined(CONFIG_PRINT_QUOTA_WARNING)
+	static char *quotatypes[] =3D INITQFNAMES;
+#endif
+
 static struct quota_format_type *quota_formats;        /* List of register=
ed f
 static struct quota_module_name module_names[] =3D INIT_QUOTA_MODULE_NAMES;

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkvReOAACgkQfKHnntdSXjQy/QQAs1iaWx2U0O5s8ZXpdK/s5+Sl
m7K5FjRxkkHoTy5M8RoNtCQ8x4PhqTLIdTq7Ebto/w33HruB/YwxuUoJxxyHZGvW
kKwkL7U8HVrHGPXTTvqN3jr5CQ6EtsrNMNXLQUKb9QnWNVw6S/mhW5IAwq6rs5A0
jxlP7xtez9s7oqlIxHk=
=T5Dj
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
