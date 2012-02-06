Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2BFRD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:03:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52649 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab2BFRDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:03:54 -0500
Message-ID: <1328547955.22240.39.camel@sauron.fi.intel.com>
Subject: Re: [RFC] killing boilerplate checks in ->link/->mkdir/->rename
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 06 Feb 2012 19:05:55 +0200
In-Reply-To: <20120206135655.GF23916@ZenIV.linux.org.uk>
References: <m1wr87ywex.fsf@fess.ebiederm.org>
	 <m1ehueyz20.fsf_-_@fess.ebiederm.org>
	 <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
	 <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
	 <20120202012258.GQ23916@ZenIV.linux.org.uk>
	 <20120202212400.GR23916@ZenIV.linux.org.uk>
	 <CA+55aFzHSv2eHKenVhxnSFMJMXtJCnxD2xu6QjMiMLEGLCZ2uQ@mail.gmail.com>
	 <20120203011612.GS23916@ZenIV.linux.org.uk>
	 <20120203170825.GX23916@ZenIV.linux.org.uk>
	 <1328518244.22240.25.camel@sauron.fi.intel.com>
	 <20120206135655.GF23916@ZenIV.linux.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-kUZLN3dhkT9rGOcPprNa"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kUZLN3dhkT9rGOcPprNa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-02-06 at 13:56 +0000, Al Viro wrote:
> On Mon, Feb 06, 2012 at 10:50:44AM +0200, Artem Bityutskiy wrote:
>=20
> > WRT 'sen_nlink()' - I can use it instead of 'drop_nlink()'/'inc_nlink()=
'
> > of course. But I do not really see why is this better. E.g.,
> > 'drop_nlink()' additionally gives me ' WARN_ON()' in case of 'i_nlink'
> > wrapping.
>=20
> So does inc_nlink() when you are asking to get from nlink=3D0 to nlink=3D=
1.
> I.e. on failure exit in your unlink()...

Indeed! I'll switch to 'clear_nlink(inode)' and 'set_nlink(inode, 1)'
for those inodes which are being unliked.

--=20
Best Regards,
Artem Bityutskiy

--=-kUZLN3dhkT9rGOcPprNa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPMAhzAAoJECmIfjd9wqK0POEP/j1tTtfR6oqOWtCc4n5NfDGR
7wDOK2P0y9jQWM9MX4VR7v2NYKFYbh9ZeYG+sFYKzlZw9mYZeggRqwBeF6mGeavF
6YcKDdGiMBnY46oJcg3FzFY3YqMrjh9HoxBP2AcS5gw0Izz+n7R7/L3vvy7oMTmJ
sLVBCEfWGGbArqK63mL60+64l0QuxmE1MQbkl3JHfaV4v1lNz7nGbMKr8FMaGxwA
g3/GKoavZw+bFtzQX5Cak5fAXCJ48/spwKmKEdK+5suF25f2ZJQF+P6elGZr8iKY
nBnsepI/eCZ6ErybX3rxmh51D6F6IHBEj1ZSJcrZJticKTwK9XMhykcv89U7C3PW
u9W+5W1m/orAmvnHZ2mbBfFW35fcW8SpK7Cc8F2BffvBdGQyTEoB47ssFe2Ntqy/
pNvuAYg4MkVOTDxjObOOGY2l5eA+g9wCWdgh41DwyIZormXoC466fyqvAIFubNi6
gh7/fK8Sb0d4o7VJFFLE+StsxgOZAgMjEjlZuzojPNKa8vvRTyyvvl6UP4qqMzCg
4mEr+pbPpMr97eVPRxjdDTLHyQvNQIC6taP10QDzOGRhTYz0vkpMfjxbZ5u2y1KR
8YC4y68cFSdLGGzInL2zRmjNAeSlsZAOTql4jLf+fhTOJrazEeHsvcngVQz6ANCX
2QuB7F5fQHTMn5fzIqN/
=i23q
-----END PGP SIGNATURE-----

--=-kUZLN3dhkT9rGOcPprNa--

