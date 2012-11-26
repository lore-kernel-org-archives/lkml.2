Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab2KZNN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:13:26 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53596 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab2KZNNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:13:24 -0500
Date: Tue, 27 Nov 2012 00:13:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: manual merge of the akpm tree with the userns tree
Message-Id: <20121127001320.12439806f19c9b6ccce4e895@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Nov_2012_00_13_20_+1100_e0fO5iWDlAi.gt=C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Nov_2012_00_13_20_+1100_e0fO5iWDlAi.gt=C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in kernel/fork.c
between commit b2e0d98705e6 ("userns: Implement unshare of the user
namespace") from the userns tree and commit  ("fork: unshare: remove dead
cod") from the akpm tree.

I fixed it up (I think - see below) and can carry the fix as necessary (no =
action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/fork.c
index 7e0dc2f,58088f9..0000000
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@@ -1867,20 -1858,8 +1865,17 @@@ SYSCALL_DEFINE1(unshare, unsigned long
  		}
 =20
  		task_unlock(current);
 +
 +		if (new_cred) {
 +			/* Install the new user namespace */
 +			commit_creds(new_cred);
 +			new_cred =3D NULL;
 +		}
  	}
 =20
- 	if (new_nsproxy)
- 		put_nsproxy(new_nsproxy);
-=20
 +bad_unshare_cleanup_cred:
 +	if (new_cred)
 +		put_cred(new_cred);
  bad_unshare_cleanup_fd:
  	if (new_fd)
  		put_files_struct(new_fd);

--Signature=_Tue__27_Nov_2012_00_13_20_+1100_e0fO5iWDlAi.gt=C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQs2rwAAoJEECxmPOUX5FEZtMP/0Wc7Z6UFG66bnWhUiemnooO
lX9CrfvWtyKmNchCTG+cXyIq5lkouj1ogrNX6OPnZOhX2SgjHSDkMJ0it9Sqq7BD
Cly2Gvc7TjeMniVRlaag36OeY1KLMljFwfGvC9UKNVbnnokTn+jBcnwwyNThebFA
wgv8MWZsOQPN2CcnzWAV1f3p78u4P7TVSc4dgnp9yHnITkkeVWBiEfzO5D4HoIIV
3hB46ROlEURUQvw970Q9YFITtpmVmL3PIa1iYQpZfJXLmFtLwM/bngWRgIrfECOE
+G6K/kbt+F6wNkpsjje0muC9UW01UGmzbnvCWboa8ZsMRH5hFDUo8tYj751zah6E
Oi2tL1AQonjzFH2032uRKOT2huY4xJleNLfLndcbFvfG9voak/NkaJHPk0t5iXy3
0mDD8Qn0frQQzNyGaXDlcFke2Pu0AH9LFuXogG/icpkh2ZkEWtHJziJi1z4bv6na
mOXdYezfnGOiha4TBhroskKS6ksHB6YVFOP+Oep1FFkR+2Y6+NKj2cCxGXmxqCvR
lE9royR7M+q6CdwHk708aCk9bRSwdwg5Kabsco1/866Ctla42rU4fgKFPL0hmxDa
IxCqnHR20abFYD+cU3OxaSt3MPp1tzcouwJg7H+f1Pe/KXUX01brKiBhfuFvqltW
DvEsYlAyrdJ3G0+YWcZ7
=+8sj
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Nov_2012_00_13_20_+1100_e0fO5iWDlAi.gt=C--
