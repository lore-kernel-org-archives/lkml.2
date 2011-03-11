Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab1CKAWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:22:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55619 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab1CKAWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:22:20 -0500
Date: Fri, 11 Mar 2011 11:22:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the nfs tree
Message-Id: <20110311112212.67557e19.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__11_Mar_2011_11_22_12_+1100_8F_qG1p.lNIz_xqV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_Mar_2011_11_22_12_+1100_8F_qG1p.lNIz_xqV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

After merging the nfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from fs/nfs/client.c:45:
fs/nfs/nfs4_fs.h: In function 'nfs4_schedule_session_recovery':
fs/nfs/nfs4_fs.h:303: error: parameter name omitted

Caused by commit 13ffe1da57fb ("NFSv4/4.1: Fix
nfs4_schedule_state_recovery abuses").

If you add code that is obviously affected by config options, it is worth
while build testing with and without those options ... in this case
CONFIG_NFS_V4_1 is not set.

I have used the nfs tree from next-20110310 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__11_Mar_2011_11_22_12_+1100_8F_qG1p.lNIz_xqV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNeWs0AAoJEDMEi1NhKgbscmIIAIhLBTg7p4eI9+BLubzFhQd8
SmisYxMlTJTEuVZXWVoCVGYFyOtQX5dw+4UlM7vch7zGtaJSs2RFGgofiYQMQS4Q
YfmkIROcycLMSM1VmJs11XdRDYCUc0H0Zkj9O6Cme4xnGMMl1pL79JOGrpIdAa9s
SyR6/lzQRzHZS2Nxmk0PsspQ38hZ9T2nf6uzdyXNTiB5n5WACglF5m7w/cNf4hQr
DOEmiWPeunxSFMId6YnePttKDnn+teg8bLvpt3SDWef+MI6by4f7+lYe0l2ue5BK
X9IruK+8ZuZ1Waks6rYcOtjLg5C8OY838qkx7kQgyRS1JfxqK+/QoQ1s8CQ2ruE=
=VDt3
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Mar_2011_11_22_12_+1100_8F_qG1p.lNIz_xqV--
