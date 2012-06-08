Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761758Ab2FHXbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 19:31:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:59098 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760373Ab2FHXbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 19:31:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="150384633"
Date: Sat, 9 Jun 2012 02:32:41 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH, RESEND] fs: push rcu_barrier() from
 deactivate_locked_super() to filesystems
Message-ID: <20120608233240.GC18981@otc-wbsnb-06>
References: <1339191663-17693-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20120608150253.e42464a6.akpm@linux-foundation.org>
 <20120608221446.GA18250@otc-wbsnb-06>
 <20120608152550.258d6a30.akpm@linux-foundation.org>
 <20120608222734.GT30000@ZenIV.linux.org.uk>
 <20120608153120.b722d7c3.akpm@linux-foundation.org>
 <20120608223624.GU30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PuGuTyElPB9bOcsM"
Content-Disposition: inline
In-Reply-To: <20120608223624.GU30000@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PuGuTyElPB9bOcsM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 08, 2012 at 11:36:24PM +0100, Al Viro wrote:
> On Fri, Jun 08, 2012 at 03:31:20PM -0700, Andrew Morton wrote:
> > On Fri, 8 Jun 2012 23:27:34 +0100
> > Al Viro <viro@ZenIV.linux.org.uk> wrote:
> >=20
> > > On Fri, Jun 08, 2012 at 03:25:50PM -0700, Andrew Morton wrote:
> > >=20
> > > > A neater implementation might be to add a kmem_cache* argument to
> > > > unregister_filesystem().  If that is non-NULL, unregister_filesyste=
m()
> > > > does the rcu_barrier() and destroys the cache.  That way we get to
> > > > delete (rather than add) a bunch of code from all filesystems and n=
ew
> > > > and out-of-tree filesystems cannot forget to perform the rcu_barrie=
r().
> > >=20
> > > There's often enough more than one cache, so that one is no-go.
> >=20
> > kmem_cache** ;)
> >=20
> > Which filesystems have multiple inode caches?
>=20
> inodes are not the only things that get caches of their own...
>=20
> BTW, Kirill, would you mind not cross-posting to that many lists ever aga=
in?

Sorry for that. I haven't deal with patches that potentially affect so
many people before.

--=20
 Kirill A. Shutemov

--PuGuTyElPB9bOcsM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP0ouYAAoJEAd+omnVudOM0VIQAI9Gow9ddAIbjak4y3WdTGxo
UUzzDQSEhtgRij+pk4lIS0SRp/YLqSnJXsLXNZ5+JE/QWwM8X1+qctim7wFp2Ei2
93yFsKTq6Wd5tIVxuVCIulLAiYyTOnxqUbovv+D5wSUZkWIe+/yQRIzXZZBFWIWT
/KPnTZ1AO8BKwAUkCR/jjJzRT5KpckH2DS4w7+1gTCfHG3GNHrmV8lXwVGDguuv6
U3dxto+OW7zZIpHNy2p560ACKNXzDx3vDY86O8rTy6LziC/ux36HZgqvmojrHOzY
j1ajPiXD3NWK++YFmuQlUI0rd/zFNsHGQdgvflq9yGrsHTD8z4AijCmsp8tGqRzj
60oiVTMY6dyScbiQ1XNTheRvUh4Rh3BZ9rP62sI0SB6onG7cCxpuJ0I3BmYb2Inh
ZDHU9xl+wzAnD7AEU+i9U636iVYg4FSNKFolWD2ZLiPBz9TujRsss0uhReDA5WE5
4gVIHMdWTrOJo2hAyMzWKEfUIFMKGuzvEeICmgqJAg6qnIttcUbEjnHXChN0fkbG
MRBRqRxue8CSCBqf8kiRFuM7pF/bNv1c4UcufVjZ43MjIta6ftIOHfAIiO7Ab29D
/TRiC81Bj/1ORT2EWSk6Slvcyj0Ko5YZ3vsdfYdhVX3QJbxIJ7bc73BXRndvTwEj
11w8b6wgUZzxDYdWmIH6
=fm8Y
-----END PGP SIGNATURE-----

--PuGuTyElPB9bOcsM--
