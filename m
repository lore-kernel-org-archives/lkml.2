Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab0DWKqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 06:46:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41060 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab0DWKqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:46:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=OdIVg475/lD6p8CsHHdanncbtHpjjO0wQ9zX03Qska10nvLBGBA9lcq2IyvIP8fz+p
         mRatA4gip/0F+rNPIW63b2hm06X9qLjqjvvMAVlwgisUPyNI3xwQQOgSXEDKhSz09IPB
         CirR2deXEW4utn2nt0m4vI06+wnxglSsKQ6qc=
Date: Fri, 23 Apr 2010 13:47:55 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] suppress warning =?utf-8?Q?fs=2Fqu?=
	=?utf-8?B?b3RhL2RxdW90LmM6MTM1OiDigJhxdW90YXR5cGVz?=
	=?utf-8?B?4oCZ?= defined but not used (resent)
Message-ID: <20100423104755.GB3293@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rS8CxjVDS/+yyDmU
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
tate_lock);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dq_data_lock);
 EXPORT_SYMBOL(dq_data_lock);
=20
-static char *quotatypes[] =3D INITQFNAMES;
+#if defined(CONFIG_QUOTA_DEBUG) || defined(CONFIG_PRINT_QUOTA_WARNING)
+	static char *quotatypes[] =3D INITQFNAMES;
+#endif
+
 static struct quota_format_type *quota_formats;	/* List of registered form=
ats */
 static struct quota_module_name module_names[] =3D INIT_QUOTA_MODULE_NAMES;
=20
--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkvRetsACgkQfKHnntdSXjRNXwQAxKhHOwdYPlrxClZI5Nf9HuIB
TxBmmV+07IYTanzxpCDVhOct+08hJspeV91VAgT6G+QrcWYg0fpxHg/oDP5v0Drd
QSSIpusr0GF3y3KZB2zZH1hCEFl2BHyc/8kPYXsxnZ1p+nAZFXZT6EnKvDtJ8QWD
J3zjAprXF99qiT3oC+k=
=Ke3Q
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
