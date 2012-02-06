Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab2BFIsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 03:48:55 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43006 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2BFIsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 03:48:54 -0500
Message-ID: <1328518244.22240.25.camel@sauron.fi.intel.com>
Subject: Re: [RFC] killing boilerplate checks in ->link/->mkdir/->rename
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 06 Feb 2012 10:50:44 +0200
In-Reply-To: <20120203170825.GX23916@ZenIV.linux.org.uk>
References: <m14nvc82jo.fsf@fess.ebiederm.org>
	 <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
	 <m1wr87ywex.fsf@fess.ebiederm.org> <m1ehueyz20.fsf_-_@fess.ebiederm.org>
	 <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
	 <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
	 <20120202012258.GQ23916@ZenIV.linux.org.uk>
	 <20120202212400.GR23916@ZenIV.linux.org.uk>
	 <CA+55aFzHSv2eHKenVhxnSFMJMXtJCnxD2xu6QjMiMLEGLCZ2uQ@mail.gmail.com>
	 <20120203011612.GS23916@ZenIV.linux.org.uk>
	 <20120203170825.GX23916@ZenIV.linux.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-qW6kZOSmJctOEikHzS66"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qW6kZOSmJctOEikHzS66
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-02-03 at 17:08 +0000, Al Viro wrote:
> On Fri, Feb 03, 2012 at 01:16:12AM +0000, Al Viro wrote:
>=20
> > 	* ubifs, hfsplus, jffs2 - definitely broken if you create enough
> > links.  i_nlink wraparound to zero, confused inode eviction logics.
>=20
> BTW, ubifs plays funny games with i_nlink - decrements it early in
> unlink/rmdir/rename and then increments it back on failure.  *If*
> we really want it that way, we need to use set_nlink() there.  Frankly,
> I'd rather deal with drop_nlink() after the last possible failure
> exit...  Unless there are serious reasons why that wouldn't work, that is=
.
> Artem?

The way code is organized is that the UBIFS journal subsystem functions
accept 'struct inode' and struct direntry' objects and write them out to
the media as they are in RAM. So before calling 'ubifs_jnl_update()' we
should have all the fields in 'struct inode' to be set correctly. Thus,
we have to drop 'i_nlink' before calling 'ubifs_jnl_update()'.

WRT dealing with 'drop_nlink()' after the last possible failure - I can
just make own partial copy of 'struct inode' and pass it to
'ubifs_jnl_update()', if there is a need. I would not like to make the
journal code more complex than it already is by adding 'i_nlink' usage
smartness.

WRT 'sen_nlink()' - I can use it instead of 'drop_nlink()'/'inc_nlink()'
of course. But I do not really see why is this better. E.g.,
'drop_nlink()' additionally gives me ' WARN_ON()' in case of 'i_nlink'
wrapping.

--=20
Best Regards,
Artem Bityutskiy

--=-qW6kZOSmJctOEikHzS66
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPL5RkAAoJECmIfjd9wqK01oAP+gO/1K8fmstlcauHFAt7ty1P
MiITE5CTdcRLNppDItM7KTnYGZA0eK7muF7NKBIugHIfSNGkvGr1n0MR2lmDgySY
w+REoc3/ku7dtTpWCvtgjQkJx3sc/FkLloQnyf40dTYiXEnOsWaBFjId119D6deb
1Lr0DCS2djBuAiPvv2okHMfz/kRtBES6CUZ/PLvteCq5BsyiIOwUUmU1IAJBej2l
aA+JkBFGt9MdRpD4xwFFsJaqTp/wjQmF/GqFcT6R63Yhlu0O/wh2uBPvfvr3SUhG
P04JqiQrZbNjwxfg1qbfcKdp9KGGDd2QzaJWfCPcwPfYv2rnipObDtkooFogcskD
tJchSkRRdqIBPbfhqwzpw3+Ui9zP7PMkRBPhzr9ghsoZaykc0Z5wHN7BcF7FLGz4
HjUSe42vFi0mRy05JuEQ7cilGa852vFzG2pmgYj9Yj05Q+Nq+7KX/M46HgzIInGt
JKUM1A3uUT3X9XbbvIYt4nAmEEUZQqmX1Xeaq/1YqPXeniUMubPxx6E2L8SsjGU8
iHvv2v2zs1lbOuMaNCM4mqQbMX6bpYdCwuqnQhJyiGBMCMAjEO9k+9ukVVex5rir
dXFUat9Ie19sM5mVEaxvYBFtlu6diQMGDbgmJZlxRij3qrRP9THyJfBfu+Qa9O4Y
W+Gd9ZzuM9KSajRcQ3Hx
=ztZa
-----END PGP SIGNATURE-----

--=-qW6kZOSmJctOEikHzS66--

