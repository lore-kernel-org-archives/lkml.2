Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213Ab2GEFAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 01:00:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43635 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab2GEFA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 01:00:29 -0400
Date: Thu, 5 Jul 2012 15:00:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the tip tree with the vfs tree
Message-Id: <20120705150012.63b7d7be0a0f549cfe650515@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jul_2012_15_00_12_+1000_YnM/5neaDbvMchVN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jul_2012_15_00_12_+1000_YnM/5neaDbvMchVN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in kernel/fork.c
between commit 7ab538da1f8a ("trim task_work: get rid of hlist") from the
vfs tree and commit 0ea86208345b ("sched, mm: Rework sched_{fork,exec}
node assignment") from the tip tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/fork.c
index bebabad,1a69745..0000000
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@@ -1414,8 -1415,7 +1415,7 @@@ static struct task_struct *copy_process
  	 * We dont wake it up yet.
  	 */
  	p->group_leader =3D p;
- 	INIT_LIST_HEAD(&p->thread_group);
 -	INIT_HLIST_HEAD(&p->task_works);
 +	p->task_works =3D NULL;
 =20
  	/* Now that the task is set up, run cgroup callbacks if
  	 * necessary. We need to run them before the task is visible

--Signature=_Thu__5_Jul_2012_15_00_12_+1000_YnM/5neaDbvMchVN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP9R9cAAoJEECxmPOUX5FEwmwQAJariZxQ3Ns7OP6K4rhzHPdH
6UVYciiZBozMS1Jk+uMeI8sdgFmAVDEvAjXU5bd5LoNTq4jq9xWDyuGwXIk+oU6d
HmxhT6al/GzZuJFKqRAA8dMgm54AisDigZMl5EEO7ps2VUslnablu9pJUdcQ+Vwj
Whr/G05jVtm7dZqPRght9eVgjdWWKM8vN4pVdToCN24gcuUnKdfyd7O5EnZkMR7M
f1DSmp1sc5lAUfJUUJxHS9wKA5c4mKtHrwJ13wCqtSZymAJk3Jhp4+HyHYVGFJuI
MsQr7kwbS/UP++wzAXEskirDqRTskgfUKew3YVvdML6XkjdVi+Jbulrfq4FapPmt
g+dVkBIm+mpyyWmpMTti62X4ittzd0AdN7MdRSW7nx12TcYK1olU5GArhhZlYgtq
NprbaPNMd7XBGVtTFnYPYnvjqx8AkLEsCBMChWxWk2Hn84rY+dkmctyev2miz3ue
SCRuyF7awugYP5xVu71cXrgKNWbV0jJE0GiJ0SuU78N0o9HisE1V/szSFWZtrHA8
GGGciacrCdV90zjLtIUt9MvQ/0/hw89OpuBDX1LY2o29GPx8ejHVkXwn/hpkgefE
KBeOOWczX53ba6WmmubGuAeZggPhAb4Bjy2b7PIZQiQMxyfLd8rw8bpJ6EgEe3mY
RhpBaM1E1yZjg6jkCyxi
=U0pl
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jul_2012_15_00_12_+1000_YnM/5neaDbvMchVN--
