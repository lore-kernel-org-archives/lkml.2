Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab2B0FRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 00:17:09 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48608 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2B0FRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 00:17:07 -0500
Date: Mon, 27 Feb 2012 16:16:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alex Shi <alex.shi@intel.com>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120227161655.8360c0ddbd68feb8dce6a28f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__27_Feb_2012_16_16_55_+1100_2GvxRAI4sc.ys7Ew"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Feb_2012_16_16_55_+1100_2GvxRAI4sc.ys7Ew
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/x86/include/asm/i387.h between commit 1361b83a13d4 ("i387: Split up
<asm/i387.h> into exported and internal interfaces") from the tip tree
and commit "x86-change-percpu_read_stable-to-this_cpu_read_stable-fix"
from the akpm tree.

The former commit moved the code to arch/x86/include/asm/fpu-internal.h,
so I applied the patch there (see below).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu=
-internal.h
index 4fa8815..5caaf43 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -344,7 +344,7 @@ typedef struct { int preload; } fpu_switch_t;
  */
 static inline int fpu_lazy_restore(struct task_struct *new, unsigned int c=
pu)
 {
-	return new =3D=3D percpu_read_stable(fpu_owner_task) &&
+	return new =3D=3D this_cpu_read_stable(fpu_owner_task) &&
 		cpu =3D=3D new->thread.fpu.last_cpu;
 }
=20

--Signature=_Mon__27_Feb_2012_16_16_55_+1100_2GvxRAI4sc.ys7Ew
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPSxHHAAoJEECxmPOUX5FE6CMQAJKIfb8IkXO1XkqW7JvTvIlZ
TOfpcpj8B+ZCQDpKwoWRwpV1gtscx1cRjemhoTy4Cw+u0CHYXsl+7bdayMzMt21w
Lo836o33GMNg6zYyprpN/EFCB3mXwV28jxq28ndjFuTJHpFr+PzjI+ACX5QEXjfA
4alnmt/EcIJX79nMvaRM5dh6o+Is8xV7orWnLpNwn9Ow1/t+b5SUnz71rq4bBeRU
Jkgc5tUgfZpU+ytKVeWz71GGkv0XtczqvKxttvh7tEBYbT1OuJahpsVAPO8+wpgw
39PwW6OuD8M7j7uDGekJtLUjKp1+oEpX6aYyjEcnHfgh/7mhAL8Oxdhlfc7I8R4+
xvM57X5CiiOeSRtOnxqe7QgHlByJUpsYhjwGLhazlOjeJtOs2z7UnMC9fwXDMMiq
GMv3b4V5Qc3lQyvbvqZNvMy5ywJhsrTYKjvJsuBstStnmyyvIwAMi8InK+/8I1Db
Bq96BMIqEgYuI5isH8BMJLG/h12PIGMf2augixJ93AyUQf9iPGQt/14x9Vf2IZvl
Q34X3HIPMw7PArnmoF9hdJHpbFUJXHxx/2hQIQVI3QkCmNaNwa47YJKeayfnpeG6
zXzHf8Z7NMN8Tk96C8hzP77qqX75ZyPZX0+afFyoBvSmphJZai2rUDCygfRi0G7t
SP1rzNcueLPSQo6dX/fE
=aYkh
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Feb_2012_16_16_55_+1100_2GvxRAI4sc.ys7Ew--
