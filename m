Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2B0Fdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 00:33:53 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53530 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab2B0Fdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 00:33:52 -0500
Date: Mon, 27 Feb 2012 16:33:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Shi <alex.shi@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120227163343.b0c0ff0836f433538ec295f5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__27_Feb_2012_16_33_43_+1100_omPGVHCD6mKOUA.q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Feb_2012_16_33_43_+1100_omPGVHCD6mKOUA.q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/x86/include/asm/i387.h between commits 8546c008924d ("i387: Uninline
the generic FP helpers that we expose to kernel modules") and
1361b83a13d4 ("i387: Split up <asm/i387.h> into exported and internal
interfaces") from the tip tree and commit
"percpu-remove-percpu_xxx-functions-fix" from the akpm tree.

I applied the appropriate part of the latter patch to
arch/x86/include/asm/fpu-internal.h and arch/x86/kernel/i387.c (see below).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu=
-internal.h
index 5caaf43..e9801b4 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -290,14 +290,14 @@ static inline int __thread_has_fpu(struct task_struct=
 *tsk)
 static inline void __thread_clear_has_fpu(struct task_struct *tsk)
 {
 	tsk->thread.fpu.has_fpu =3D 0;
-	percpu_write(fpu_owner_task, NULL);
+	__this_cpu_write(fpu_owner_task, NULL);
 }
=20
 /* Must be paired with a 'clts' before! */
 static inline void __thread_set_has_fpu(struct task_struct *tsk)
 {
 	tsk->thread.fpu.has_fpu =3D 1;
-	percpu_write(fpu_owner_task, tsk);
+	__this_cpu_write(fpu_owner_task, tsk);
 }
=20
 /*
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 7734bcb..32c3972 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -88,7 +88,7 @@ void kernel_fpu_begin(void)
 		__thread_clear_has_fpu(me);
 		/* We do 'stts()' in kernel_fpu_end() */
 	} else {
-		percpu_write(fpu_owner_task, NULL);
+		__this_cpu_write(fpu_owner_task, NULL);
 		clts();
 	}
 }

--Signature=_Mon__27_Feb_2012_16_33_43_+1100_omPGVHCD6mKOUA.q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPSxW3AAoJEECxmPOUX5FEMi0QAKCKOgbLA8b0HVURWatWcUfF
T0aEmfu6C3GppJA4xingcgatOkWZ3tNAbroAR8E3WNkBrhodE+IZsIf6tIt9FINn
DOUnG8/4Ozju4W79WNGoCOAtzHFiwBLrTkDFgkh6yVTzjyDgrdJLTiGj2CUFhitb
bnzA+Q7D77dg+pOVJ+OLS0R2iVoiltuEjll1B8grLvY2JCdquF+DyLrB5ggWMgKg
Zaj7bgDvOcbPriMFVw6hoZGWZI/3FDMhbHzbX08n9jzihRC3a6bPDjaRlagQu+a5
fIE6VxIgVXfBYmnacipQ+FXIDezFmMZuHwv5sHAMe+Vs4pZTGsh0iTMFZHeKDv9l
w8FoL0XimAVJWRQU9CPHrWbZD50YGfT52SexdEXGYy3inYm8n8GEFw7z0OmxE1Us
w6NLAa4jqpv2ItC4UtkPZJjs6I9PIY14Ulz/YgIbtDP5PqPhQShFbBa+6V326POg
Pd9TnP24JqebCjsKU/J8bzrDRpEeg5yfti19MeMcsW9JReXmRb28Pk/7vT4bsTy1
WsPDKNguQi9DW/00cm2DF6/oiuE/cARFc8xZ6icn0m6lVSIid5sfg8anMN4eeQej
cEaef5vxc/k10ZjXCEyjn/3qHzubl8Sj/h0c4c0PaVnOZ0qfVTzympAM4BcEId0D
BtL7QK/vSvCFqWTI7SF1
=g9xY
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Feb_2012_16_33_43_+1100_omPGVHCD6mKOUA.q--
