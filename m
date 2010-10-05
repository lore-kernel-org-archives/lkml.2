Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab0JEU3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 16:29:33 -0400
Received: from smtp208.alice.it ([82.57.200.104]:39336 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757519Ab0JEU3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 16:29:31 -0400
Date: Tue, 5 Oct 2010 22:29:17 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Alan Ott <alan@signal11.us>
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oliver@neukum.name>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hidraw, fix a NULL pointer dereference in
 hidraw_ioctl
Message-Id: <20101005222917.9f4da7bc.ospite@studenti.unina.it>
In-Reply-To: <4CA9DC8D.3030207@signal11.us>
References: <1286018724-7484-1-git-send-email-ospite@studenti.unina.it>
	<4CA9DC8D.3030207@signal11.us>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Oct_2010_22_29_17_+0200_i0qkyJffJP.ar5Gg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Oct_2010_22_29_17_+0200_i0qkyJffJP.ar5Gg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Oct 2010 09:54:21 -0400
Alan Ott <alan@signal11.us> wrote:

> On 10/02/2010 07:25 AM, Antonio Ospite wrote:
> > BUG: unable to handle kernel NULL pointer dereference at 00000000000000=
28
> > IP: [<ffffffffa02c66b4>] hidraw_ioctl+0xfc/0x32c [hid]
> > [...]
> >
[...]
> > there is a similar problem when _writing_ to the device, but Alan's
> > changes in that area are shuffling the code a bit, should I send a patch
> > [to hidraw_send_report()] on top of Alan's work for that, or a fix for
> > current mainline [in hidraw_write()] on which Alan should rebase his
> > work would be better?
> >   =20
>=20
> This needs to go back into stable kernels as well, so a patch against=20
> mainline will be necessary for that. If you want to make a patch against=
=20
> mine, that's fine with me. If you want me to work it into my patch,=20
> that's fine too. (I want you to get credit for the fix though :) ).
>

Alan rebasing your patch on top of the hidraw_write() fix is trivial
so you do it in your v5, ok? It does not get rebased automatically just
because of the mutex_lock() call.

If it is OK to you I'd promote my Tested-by to a Signed-off-by in
the commit message so to take implicit credit for the fix. But this is
not even needed as the fix will be in mainline anyway.

> > The same pattern of unchecked hidraw_table[minor] is also present in
> > hidraw_get_report but this function is called only after the NULL check
> > in hidraw_ioctl _for_now_, so that is currently safe.
> >   =20
>=20
> I can stick a comment ahead of hidraw_send_report, similar to the one=20
> which already exists.
>

ACK.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Tue__5_Oct_2010_22_29_17_+0200_i0qkyJffJP.ar5Gg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyrip0ACgkQ5xr2akVTsAHoaQCfUx1s+lHvU710FrEr7pluNyqL
cSQAoJxvFk6c8XIbAcSBYYD761NkH+dY
=LpGn
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Oct_2010_22_29_17_+0200_i0qkyJffJP.ar5Gg--
