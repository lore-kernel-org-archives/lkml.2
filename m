Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab2BOGjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 01:39:12 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:36217 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab2BOGjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 01:39:08 -0500
Date: Wed, 15 Feb 2012 09:40:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jorgyano Vieira <jorgyano@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: crystalhd: crystalhd_misc: improved debug macros
Message-ID: <20120215064059.GO4141@mwanda>
References: <1329272406-26198-1-git-send-email-jorgyano@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eQyCKlb8USywWNtC"
Content-Disposition: inline
In-Reply-To: <1329272406-26198-1-git-send-email-jorgyano@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F3B5307.007C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eQyCKlb8USywWNtC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 15, 2012 at 12:20:06AM -0200, Jorgyano Vieira wrote:
> Improvement of debug macros to ensure safe use on if/else statements.
>=20

How are the originals unsafe?  The changelog should say how this is
an improvement.  Something like "I put do { ... } while(0) around
the macros so it matches the rest of the kernel."

Really we want to get rid of these.  It would be easy to delete
BCMLOG_ENTER and BCMLOG_LEAVE right now.  They're only used for five
functions.  BCMLOG() is slightly complicated.  BCMLOG_ERR() could
be sed replaced with pr_err().

So could you do that instead?  Send a patch to remove BCMLOG_ENTER
and BCMLOG_LEAVE?  Then send another patch to replace BCMLOG_ERR()
with pr_err().  Take a look at how the pr_fmt macro is used for
this.  Don't actually do it with sed.  Take the time and review each
printk() and notice bugs as you go along.  You could replace them
file by file if you wanted or all at once, which ever is easier for
you.  Then send a third patch to add the do {} while(0) block to
BCMLOG() until someone works up enough motivation to fix it
properly?

regards,
dan carpenter




--eQyCKlb8USywWNtC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPO1N6AAoJEOnZkXI/YHqRj+cQAI91Nik36JvZ6NMbKfH2i3A8
grvv9FOOkdB7zUYOpjvvS39fgNcKfrKW8yt9cSgVY++okRAnDWthNyyYHpgl5Sf4
klkmUT+iHoiC/g2xFNDxMPghMtUzGjlvV0DMhWAd1hj1a6PahngUEi2riqozt0Gs
7GMX/CH/P38yatx+wdkokRB8f9E/p0Vs2b3j2rlFzkbHUq46w1+WuanW6AfdF51J
NWxx0rpPzUBtAXgP9uDXRzhIbtht2b5W8mlMN72SS1qRmhDM4c6ceBHGxEMpBcRU
81Xb6QzHAqTgOGYAkmBCjoDW7BGxxHU8hjQeYbOXDAS+IDOrYE/Ulunx8t2AYpKB
0dIwU3F4NN9eBM6dqPk6TTTNDwPxt+jaPQIUBUA86mUBhqrRV81iJwe1ZvOX0R2l
dG43Kg/KDXwCbt2JTiEtr6EFwRdZgVwJcUJSrrSogInSBqWiOIEKsiJZSJK5ZnOr
qh5V2kAMzGdNAW+RtZuOZQ3YNdxaBwC4aKiHsE9ksg5S5jtdyQTBPXiMYgOIpz0j
LVBGhS20JMi7xViTWa3JWozv5ruIjd3/N9Mpnmukml5oKyY2JvKi7j0VgDlE2s9Y
4C3ddWd9ZhQ64cIbi9e3kbXNqOUKRUl/LdBnls/QRFdtfCP9OecZ+I7s/oYBNqj0
GBh3BmRKLwlEgEcWxSzG
=x4ZC
-----END PGP SIGNATURE-----

--eQyCKlb8USywWNtC--
