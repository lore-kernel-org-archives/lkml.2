Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab2BTEui (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 23:50:38 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36908 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2BTEug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 23:50:36 -0500
Date: Mon, 20 Feb 2012 15:50:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the scsi-post-merge tree with Linus'
 tree
Message-Id: <20120220155024.f627530239322e4ee92c9b9d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__20_Feb_2012_15_50_24_+1100_cSLP_IqeszHFAb6u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Feb_2012_15_50_24_+1100_cSLP_IqeszHFAb6u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/x86/kernel/process_32.c between commit 34ddc81a230b ("i387:
re-introduce FPU state preloading at context switch time") from Linus'
tree and commit "x86: use this_cpu_xxx to replace percpu_xxx funcs" from
the akpm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/process_32.c
index 80bfe1a,6acfb80..0000000
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@@ -358,9 -377,7 +358,9 @@@ __switch_to(struct task_struct *prev_p
  	if (prev->gs | next->gs)
  		lazy_load_gs(next->gs);
 =20
 +	switch_fpu_finish(next_p, fpu);
 +
- 	percpu_write(current_task, next_p);
+ 	__this_cpu_write(current_task, next_p);
 =20
  	return prev_p;
  }

--Signature=_Mon__20_Feb_2012_15_50_24_+1100_cSLP_IqeszHFAb6u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPQdEQAAoJEECxmPOUX5FE3mEP/jK9LY7QeQe0UZEIjsRabbED
bemAFkwLZiN/iu73SWqwCIZBXJ82rBgo+Q0maTDn5A22PGLcoTXVJBy+UDNiTD2K
0l1vunO0o6qW2zQw9ksNXGmPZF9PuVIZ7+hRGlaYXFVpL3eKFkf5eCb5KWPGzZ8L
ocLTbjHcJ1QPhQYjOnUMyjSMjLy2rYazro7HDTcdpowC8mFsuSDV+K4nnWXgcI3/
W2EI6Zxwv9ed6Ye/sI3VUW+XNVxwrxpihZkaT4RM+8UQMjX1fR1Foj6B3OzehdUr
atF+CJuj/+yYvNMqGN/fS3DrwojkhaUf41Od4WqQcblHMsvp8ioh39Nelv1eZ9wv
EAk/BuMkOQ2Z6Crvt8qGqvj5pBeJxhbCnMlNJc9Glz5iPUMvJhoJpP4s7vGUCQ5e
VUNPnsvCfqQ3STItlsIyIOBMMocDzpDKZQKsKw2FkwcqfKMoj5xyWCHVby7FZce0
tPsd4HsIFBntCPpHDdZmkv7kcEDa6ZFoRcW6WXFI/G7o2QwAB1frp7RRPZxBVf1s
tddDfJygigjnmsyd8rL0supX0tViMBb6BqpwKBgNtE5JzAAGd7cse/YF3/J0iIUR
CWCsSJcypGHLuZRRLdYOcTBy7WRI7JYiPh+QkQjKXohm1e4HNjXIpGdYk5QE130s
e/CoAUtQ0+J90ZaxScgk
=ufz9
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Feb_2012_15_50_24_+1100_cSLP_IqeszHFAb6u--
