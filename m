Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab0DWLGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 07:06:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60099 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab0DWLGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 07:06:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=KkoqmRkG6+Q019/eXuppTCsJKF79/I7u0Ey6A2ZxRfz8p9w3M7RGnEnzMa2lkrwI+0
         eyf8LXNS2m4uvqzXMvtRdvorHwe2iTdEcyUgzuBsbsTGVYyhi8dlXGOPR5qWMRB01KhP
         LpcrF+ddYcL/a1GYP+nGySWWjKyQyKFlSA634=
Date: Fri, 23 Apr 2010 14:07:42 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] suppress warning: "quotatypes" defined but not used
 (resent: v2)
Message-ID: <20100423110742.GD3293@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C1iGAkRnbeBonpVg"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C1iGAkRnbeBonpVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Suppress compilation warning: "quotatypes" defined but not used.
quotatypes is used only when CONFIG_QUOTA_DEBUG or CONFIG_PRINT_QUOTA_WARNI=
NG
is/are defined.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 788b580..109cb39 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -132,7 +132,9 @@ static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dq_st=
ate_lock);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dq_data_lock);
 EXPORT_SYMBOL(dq_data_lock);
=20
-static char *quotatypes[] =3D INITQFNAMES;
+#if defined(CONFIG_QUOTA_DEBUG) || defined(CONFIG_PRINT_QUOTA_WARNING)
+	static char *quotatypes[] =3D INITQFNAMES;
+#endif
 static struct quota_format_type *quota_formats;	/* List of registered form=
ats */
 static struct quota_module_name module_names[] =3D INIT_QUOTA_MODULE_NAMES;
=20

--C1iGAkRnbeBonpVg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkvRf34ACgkQfKHnntdSXjSqrwP+MxDl9ij0s6qi9flxzB2msULz
3YcptQu+CBHQ73yE2YoHjiAOSE/YuoxMTy6OvsQStTmRKgoZZXOLmqkxigunjUE8
0AgF04ilzaTLDmflpJ6ztBidqed+CfOwXESUedM5YkltRBG2lF2EGOy2nZyi0LYw
XYoafJbOwcPcOQKJwZw=
=glFv
-----END PGP SIGNATURE-----

--C1iGAkRnbeBonpVg--
