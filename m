Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0KAUKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:10:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44817 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab0KAUKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:10:39 -0400
Date: Tue, 2 Nov 2010 07:10:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: michael@ellerman.id.au
Cc: Jesper Juhl <jj@chaosbits.net>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@pcug.org.au>
Subject: Re: [PATCH] iSeries: Don't leak if allocations fail in
 mf_getSrcHistory
Message-Id: <20101102071025.2fe5e6ca.sfr@canb.auug.org.au>
In-Reply-To: <1288609842.10671.7.camel@concordia>
References: <alpine.LNX.2.00.1010301911220.1572@swampdragon.chaosbits.net>
	<1288609842.10671.7.camel@concordia>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__2_Nov_2010_07_10_25_+1100_zW5=f1BF_qIxG6eK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Nov_2010_07_10_25_+1100_zW5=f1BF_qIxG6eK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesper,

On Mon, 01 Nov 2010 22:10:42 +1100 Michael Ellerman <michael@ellerman.id.au=
> wrote:
>
> On Sat, 2010-10-30 at 19:20 +0200, Jesper Juhl wrote:
> >=20
> > If memory is tight and a dynamic allocation fails there's no reason to=
=20
> > make a bad situation worse by leaking memory.
> >=20
> > mf_getSrcHistory potentially leaks pages[0-3]. I believe the right thin=
g=20
> > to do is to free that memory again before returning -ENOMEM - which is=
=20
> > what this patch does.
> >=20
> > I realize that the function is under '#if 0' so this probably doesn't=20
> > matter much, but I assume that the function is still there for a reason=
=20
> > (but I could be wrong, I don't know the powerpc code).
> > Anyway, I suggest we remove the leak.
>=20
> Stephen is the iSeries maintainer, and I think he #if 0'ed the code. But
> I don't think it will ever be un-ifdef'ed, so should probably just be
> removed.

Well, only unofficially iseries maintainer :-)

Yes, just remove the whole function ... it was never used and never will
be.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__2_Nov_2010_07_10_25_+1100_zW5=f1BF_qIxG6eK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMzx6xAAoJEDMEi1NhKgbsHVAH/jH5hG+60uvx4OZuMnZp+mVe
2wm2ZaABnxOLVz4lR8VtBHQXZ9+mHofaqVGh01M709dnuVyJZY7XzX/vnRdFKGVh
hXZLn+9LCf9g4dr1/A6L/2REjXSG8EwjfMlDjLOs8fCQVpXPikMaRQy0iZ3Iqmvs
lynyZS0REotggSUKwy8BNpXN17wyNOv03ijJY/FNJL9Co+CfwHG1Y3/1gDmum4X2
o4pQ23M9oVshcF0uuo3wEGnjA+JGCq8mEnXzilyM/6xf7WJpTDv0kH1l5DcckFUY
SvO0vYE90T5kctCYtJfwHPIHBprBeACO4omTu8/A58aeb0lWdTjuEHSvHvbW1eg=
=lZYc
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Nov_2010_07_10_25_+1100_zW5=f1BF_qIxG6eK--
