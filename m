Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0DVIEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 04:04:37 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:55880 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab0DVIEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 04:04:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=N5q6ARWjiQ5bsFaKkhsnyGuZNMSdBBLB3T5hLBfyF1E7aR1F5Vl20ww8Z5hDpdZWEi
         zk544mcFch9nNPtj/hSp1pBOyG032Ku781giybfm5Cq2eiKVJVN1O4gFUrsmq+ZsMk9X
         i0b40pwMqoQkdTQ7hEPvtt4f/YmDusDOPBIKs=
Date: Thu, 22 Apr 2010 11:05:40 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: suppress warning: =?utf-8?B?4oCYcXVvdGF0?=
	=?utf-8?B?eXBlc+KAmQ==?= defined but not used
Message-ID: <20100422080540.GA3286@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,
There is unused (in some cases) pointer in dquot.c
fs/quota/dquot.c:135: warning: =E2=80=98quotatypes=E2=80=99 defined but not=
 used

which is referenced only when=20
#ifdef CONFIG_QUOTA_DEBUG or #ifdef CONFIG_PRINT_QUOTA_WARNING

My proposal is to wrap declaration in "if defined(CONFIG_QUOTA_DEBUG) || de=
fined(CONFIG_PRINT_QUOTA_WARNING) ..."?


diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 788b580..ab0a08a 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -132,7 +132,10 @@ static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dq_s=
tate_lock);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dq_data_lock);
 EXPORT_SYMBOL(dq_data_lock);

-static char *quotatypes[] =3D INITQFNAMES;
+#if defined(CONFIG_QUOTA_DEBUG) || defined(CONFIG_PRINT_QUOTA_WARNING)
+	static char *quotatypes[] =3D INITQFNAMES;
+#endif
+
 static struct quota_format_type *quota_formats;        /* List of register=
ed formats */
 static struct quota_module_name module_names[] =3D INIT_QUOTA_MODULE_NAMES;


--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkvQA1QACgkQfKHnntdSXjSaKAQAtAJloCF4dvywcppEBp0jxbfM
GRM5V95Xx4XVxjXt7shDcTmBPbF9aA2Gkj6JVtirJMzLkXe+qo62NHsJpkPTFB/1
VJi/Z6ageCEHIf+1zD80jmFw3z+igHd0567i+dtXJ/Nj4jmP6l9J1uFJ/geGi5p/
Z0JyRN+FGgMmztXy9Ho=
=saPv
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
