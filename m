Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab2B1BEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:04:54 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:48336 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755408Ab2B1BEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:04:53 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v2] parisc: dont unconditionally override CROSS_COMPILE for 64 bit.
Date: Mon, 27 Feb 2012 20:04:52 -0500
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "kyle@mcmartin.ca" <kyle@mcmartin.ca>, "deller@gmx.de" <deller@gmx.de>,
        "dave.anglin@bell.net" <dave.anglin@bell.net>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
References: <1330298813-17262-1-git-send-email-paul.gortmaker@windriver.com> <1330378864.2822.92.camel@dabdike.int.hansenpartnership.com> <1330380189.2822.95.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1330380189.2822.95.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1709520.v6gKf0jSzM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201202272004.55187.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1709520.v6gKf0jSzM
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 27 February 2012 17:03:10 James Bottomley wrote:
> --- a/arch/parisc/Makefile
> +++ b/arch/parisc/Makefile
>=20
> -CROSS_COMPILE	:=3D hppa64-linux-gnu-
> +
> +# if no default set, try to find the corresponding 64 bit compiler
> +ifeq ($(CROSS_COMPILE),)
> +CROSS_COMPILE	:=3D $(shell $(CC) -dumpmachine | sed s/hppa-\\\(.*\\\)/hp=
pa64-\\1-/)
> +endif

fails when using "hppa2.0-xxx".  perhaps:
CROSS_COMPILE ?=3D $(shell $(CC) -dumpmachine | sed 's/^hppa[^-]*-/hppa64-/=
')

don't even need the ifeq check then
=2Dmike

--nextPart1709520.v6gKf0jSzM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPTCg2AAoJEEFjO5/oN/WBrVgP/2rbzbuqJmMRAPm7iSzsN6aa
SMx2jFS44FSt0wq7oh++RwyBTsqxpIqJDvc4Ap9bWCTW5YLlWSXW+B6NkTkTSRiK
xfGnnP06qT+OlgmaOQbQg+Xunz0S3bY700Nlzm5mJpOxvklf4H+9iUWtGthwz35g
q10WmGEOKJNwYoVh1YWohj/8eCK9SUUokLlnTnselKdPcxVBY6zGXR/qwXpaIMnx
cfYbo81GBcq8yiAqZ5ZrjXxg/Nc/jnM/pibTSp9ZKLSHVEUqQlYLH9DPlC6Ko7XV
/PBrFIVslkW7xbpAuBZO0YJLbmniNYSkNtxlieHJX+PtevdsOx/PWOKfM67csOt4
Oahj9WT8JzWofcbUmbwYLvhtawXxm5th8fIMzlYR9HysGk5Q8EjqJVceLYmkRR/T
jzHXEFvkRcHfR9EdOxhajQeTVLNZv5yhfEpt9jDWCt+J0rdd8hNgLdX3kgFg+c71
CxQPWGMrmiJAsQ9c3kutl+o5rUyFUNeTDoN6iGWdkUofHKyz9SONh7wluMd1Gmk1
/xx5wH8rl3HBFTSo4fH/TC3sHhm8kFk3vQ+fauASJyFVkij3zHG+5oVT12FtSa2s
fEzf1e5ivnR2yrdbmMGbdmkSb+F+eDjcoI2vFCFSVNfTaTnBKVXJcGVUUnzJ0zT4
dIZLSc4mCJnVtFd33Ndy
=+Bpe
-----END PGP SIGNATURE-----

--nextPart1709520.v6gKf0jSzM--
