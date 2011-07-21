Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab1GUGew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 02:34:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55459 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab1GUGet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 02:34:49 -0400
Date: Thu, 21 Jul 2011 16:34:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the final tree (maybe
 vfs tree related)
Message-Id: <20110721163440.9b8339c580f39d69ec2ba30f@canb.auug.org.au>
In-Reply-To: <20110720135524.GW11013@ZenIV.linux.org.uk>
References: <20110720173232.3c7e46d310e2224e459b0ac1@canb.auug.org.au>
	<20110720135524.GW11013@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__21_Jul_2011_16_34_40_+1000_vz.jddfwTqZEIP5y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Jul_2011_16_34_40_+1000_vz.jddfwTqZEIP5y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

On Wed, 20 Jul 2011 14:55:24 +0100 Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
> On Wed, Jul 20, 2011 at 05:32:32PM +1000, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > After merging the final tree, today's linux-next build (sparc defconfig)
> > failed like this:
>=20
> > And many more similar.  Again, I assume some include files changed.
> > Maybe commit 347727d3f51d ("superblock: introduce per-sb cache shrinker
> > infrastructure") which included linux/mm.h in linux/fs.h ...
> >=20
> > I have left this again.
>=20
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 1ce9086..e0569e4 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h

I added this patch to the end of linux-next today and it fixed both the
sparc and sparc64 build problems.  Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__21_Jul_2011_16_34_40_+1000_vz.jddfwTqZEIP5y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOJ8iAAAoJEDMEi1NhKgbslIUH/j2lW3x/ada5pF1BgG/Znk9R
rUeH6uz3yQ7QuVjr5Emc8ZAOqRRA6Gmkwvq05UC0hYI3Rn7HX+BOGKp0zBm1XZaB
50HH65VBqft790Mg3LH/cKgC+4a+8qFa1ScfcvWgefVDE+GRHSPV+rdQvBkpYFM+
FF0TNOkbAgROJdaVNdS1kb0Bd5t2zzQdSbGqfERiXxsg+vSECijjBIi9kcECnIJZ
JQpMslSpBsNceiardm9JCKSZT65oBmlbcIm+ivW7zVsqM6LLoA9U0HX69K9A5HHS
RrRSfO7CA/dVOrsceExKAq4CfMrwH8HdzhU8vHR0kcdRngqrJqCrGexRZmouIEg=
=YEjh
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Jul_2011_16_34_40_+1000_vz.jddfwTqZEIP5y--
