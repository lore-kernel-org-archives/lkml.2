Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab1HLCwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 22:52:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48035 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab1HLCwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 22:52:42 -0400
Date: Fri, 12 Aug 2011 12:52:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 1/2] evm: building without EVM enabled fixes
Message-Id: <20110812125234.bb689ec3cd29f2ac48f3453d@canb.auug.org.au>
In-Reply-To: <1313036572-27122-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1313036572-27122-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Aug_2011_12_52_34_+1000_q+hJnndx9/fzRG8l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Aug_2011_12_52_34_+1000_q+hJnndx9/fzRG8l
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mimi,

On Thu, 11 Aug 2011 00:22:51 -0400 Mimi Zohar <zohar@linux.vnet.ibm.com> wr=
ote:
>
> - Missing 'inline' on evm_inode_setattr() definition.
> Introduced by commit 817b54aa45db ("evm: add evm_inode_setattr to prevent
> updating an invalid security.evm").
>=20
> - Missing security_old_inode_init_security() stub function definition.
> Caused by commit 9d8f13ba3f48 ("security: new security_inode_init_security
> API adds function callback").
>=20
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> ---
>  include/linux/evm.h      |    2 +-
>  include/linux/security.h |    7 +++++++
>  2 files changed, 8 insertions(+), 1 deletions(-)
>=20
> diff --git a/include/linux/evm.h b/include/linux/evm.h
> index db5556d..62deb65 100644
> --- a/include/linux/evm.h
> +++ b/include/linux/evm.h
> @@ -45,7 +45,7 @@ static inline enum integrity_status evm_verifyxattr(str=
uct dentry *dentry,
>  }
>  #endif
> =20
> -static int evm_inode_setattr(struct dentry *dentry, struct iattr *attr)
> +static inline int evm_inode_setattr(struct dentry *dentry, struct iattr =
*attr)
>  {
>  	return 0;
>  }
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 1c528b1..f399cf1 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -2048,6 +2048,13 @@ static inline int security_inode_init_security(str=
uct inode *inode,
>  	return -EOPNOTSUPP;
>  }
> =20
> +int security_old_inode_init_security(struct inode *inode, struct inode *=
dir,
> +				     const struct qstr *qstr, char **name,
> +				     void **value, size_t *len)
> +{
> +	return -EOPNOTSUPP;
> +}
> +

These stub functions *must* be "staic inline" (see my build report on
linux-next) just like the one you fixed above.

Good plan:  if you introduce a function whose existance (or behaviour)
depends on a CONFIG option, then build test with and without that CONFIG
option set.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Aug_2011_12_52_34_+1000_q+hJnndx9/fzRG8l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJORJVyAAoJEDMEi1NhKgbsm/8H/Rmcf++3b1ciVfGhlEQEq/c8
5044WUSbKh7CK/deGXYAyJ7ctX5TJ4OzVPzF5YxesDYRjJWf24k/T8lva/o9cYi+
lUkXV2NzbG9L2cC8Pj/RWyY7gpjJ2+R5HZSLJ7EwlJqMWwakJD+G+f4N7FAKMJB3
DlbB19n4N4O0nkIEG9jJQZ16syfZxS2F8DZ4DtrP2hsUu0BVhCh581Bqr6fMwy/h
FjVAbpFfYLPY5XxGvhYGnVsMkrZiCiz79A240y2xT9tAfwAKuLUMM57/7QmLVW+a
N3RtRswNQM8yZOQcSq0MgMVFmxAKed9j/6NOs6IEAmSAmU0/MmarDS1d7SI4Qo8=
=Zdlw
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Aug_2011_12_52_34_+1000_q+hJnndx9/fzRG8l--
