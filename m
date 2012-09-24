Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab2IXMSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:18:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42937 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab2IXMSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:18:01 -0400
Date: Mon, 24 Sep 2012 22:17:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Moody <pmoody@google.com>
Subject: Re: linux-next: manual merge of the userns tree with the security
 tree
Message-Id: <20120924221752.6537996620e5e8ef5a4965a7@canb.auug.org.au>
In-Reply-To: <20120924214116.211935861448f95b82f7f722@canb.auug.org.au>
References: <20120924214116.211935861448f95b82f7f722@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_22_17_52_+1000_tnzs97c3bd13EZkx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_22_17_52_+1000_tnzs97c3bd13EZkx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 24 Sep 2012 21:41:16 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> diff --cc kernel/auditsc.c
> index 37f52f2,ff4798f..0000000
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@@ -1160,32 -1151,8 +1152,38 @@@ void audit_log_task_info(struct audit_b
>   	char name[sizeof(tsk->comm)];
>   	struct mm_struct *mm =3D tsk->mm;
>   	struct vm_area_struct *vma;
>  +	char *tty;
>  +
>  +	if (!ab)
>  +		return;
>  =20
>   	/* tsk =3D=3D current */
>  +	cred =3D current_cred();
>  +
>  +	spin_lock_irq(&tsk->sighand->siglock);
>  +	if (tsk->signal && tsk->signal->tty && tsk->signal->tty->name)
>  +		tty =3D tsk->signal->tty->name;
>  +	else
>  +		tty =3D "(none)";
>  +	spin_unlock_irq(&tsk->sighand->siglock);
>  +
>  +
>  +	audit_log_format(ab,
>  +			 " ppid=3D%ld pid=3D%d auid=3D%u uid=3D%u gid=3D%u"
>  +			 " euid=3D%u suid=3D%u fsuid=3D%u"
>  +			 " egid=3D%u sgid=3D%u fsgid=3D%u ses=3D%u tty=3D%s",
>  +			 sys_getppid(),
>  +			 tsk->pid,
> - 			 tsk->loginuid, cred->uid, cred->gid,
> - 			 cred->euid, cred->suid, cred->fsuid,
> - 			 cred->egid, cred->sgid, cred->fsgid,
> ++			 from_kuid(&init_user_ns, tsk->loginuid),
> ++			 from_kuid(&init_user_ns, context->uid),
> ++			 from_kgid(&init_user_ns, context->gid),
> ++			 from_kuid(&init_user_ns, context->euid),
> ++			 from_kuid(&init_user_ns, context->suid),
> ++			 from_kuid(&init_user_ns, context->fsuid),
> ++			 from_kgid(&init_user_ns, context->egid),
> ++			 from_kgid(&init_user_ns, context->sgid),
> ++			 from_kgid(&init_user_ns, context->fsgid),

These should all be "cred" not "context", of course.  I fixed this in my
tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Sep_2012_22_17_52_+1000_tnzs97c3bd13EZkx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYE9wAAoJEECxmPOUX5FEpmkP/R4Qv0gMtFo4LDPbOvwcrG25
H6uy+h9aSpyQ8bsBseuj9QgahLmtltU2KZqZHsSdq4n+UXkXsdiIsFmPyX82Ynr/
92DBQKZ4oTn6T7VBnsS06FyTe/uHGYgUcdTxLyBV3aky1X51UZk2Dwv4CRXF02rN
zZtrpX5W0HousKYU3XAh2ydfqr7j7ooa4p88lAEUN3u03l6XWqnHaOAeRLMF2C+O
UXN6TAPG/vkPsJOozPBZMk3HDbEbNY8m11dlMayKSFGlY6R/u3mSdMKIVamGS/+a
GM3TZ9rEaYLaXVX0kGYPEfyEy3+gLuyTCkUMeoZ35HuuF8uRXix93YKZUOX/pGeh
buYvR/I6wbEXRy+QVev0GHDYj1zFwHUnhXr/jL1NOJyv3fJEWQneYzC4lpXnACSj
IZlMQLCY1nnzr4kZo+deG2+HMaaxdXsa5Q0IYpXgQD5S9JSG2DAvFQ+ts1Vdstk/
d68zUpkgaPxUv9yrLzcPsg7EoKO1/bQYJKxYEgPnx03lwC/zivOsnx1wDhdzCJN+
ng9ImVNtr4KoFds0+rlpubuWpTB4Rm5887eokauxb+77FjXHUwUcQQcFLW2AlWpn
3mYjmsWUaQBXl7VSgBt3h7GSzsA1tfU+EoIzYJUNJbm9VGNCoOzxU5Bk5hbL119z
WrgVtLbZiXp8S+hRd/o+
=nvWW
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_22_17_52_+1000_tnzs97c3bd13EZkx--
