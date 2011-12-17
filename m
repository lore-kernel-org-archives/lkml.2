Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab1LQOeA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 09:34:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63722 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab1LQOd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 09:33:57 -0500
Message-ID: <1324132520.4240.26.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Scott Wood <scottwood@freescale.com>
Cc: shuo.liu@freescale.com, dwmw2@infradead.org, Artem.Bityutskiy@nokia.com,
        linux-mtd@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        leoli@freescale.com
Date: Sat, 17 Dec 2011 16:35:20 +0200
In-Reply-To: <4EE6725C.3050706@freescale.com>
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com>
	   <1322973098-2528-3-git-send-email-shuo.liu@freescale.com>
	   <4EDEAEB9.6020703@freescale.com> <1323724195.2297.11.camel@koala>
	  <4EE66EFE.1050608@freescale.com> <1323724784.2297.20.camel@koala>
	 <4EE6725C.3050706@freescale.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Q08dyElqo8J5Em+DwD+s"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Q08dyElqo8J5Em+DwD+s
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-12-12 at 15:30 -0600, Scott Wood wrote:
> On 12/12/2011 03:19 PM, Artem Bityutskiy wrote:
> > On Mon, 2011-12-12 at 15:15 -0600, Scott Wood wrote:
> >> NAND chips come from the factory with bad blocks marked at a certain
> >> offset into each page.  This offset is normally in the OOB area, but
> >> since we change the layout from "4k data, 128 byte oob" to "2k data, 6=
4
> >> byte oob, 2k data, 64 byte oob" the marker is no longer in the oob.  O=
n
> >> first use we need to migrate the markers so that they are still in the=
 oob.
> >=20
> > Ah, I see, thanks. Are you planning to implement in-kernel migration or
> > use a user-space tool?
>=20
> That's the kind of answer I was hoping to get from Shuo. :-)
>=20
> Most likely is a firmware-based tool, but I'd like there to be some way
> for the tool to mark that this has happened, so that the Linux driver
> can refuse to do non-raw accesses to a chip that isn't marked as having
> been migrated (or at least yell loudly in the log).
>=20
> Speaking of raw accesses, these are currently broken in the eLBC
> driver... we need some way for the generic layer to tell us what kind of
> access it is before the transaction starts, not once it wants to read
> out the buffer (unless we add more hacks to delay the start of a read
> transaction until first buffer access...).  We'd be better off with a
> high-level "read page/write page" function that does the whole thing
> (not just buffer access, but command issuance as well).

It looks like currently you can re-define chip->read_page, so I guess
you should rework MTD and make chip->write_page re-definable?

--=20
Best Regards,
Artem Bityutskiy

--=-Q08dyElqo8J5Em+DwD+s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO7KipAAoJECmIfjd9wqK0c8QP/2msdz4o9q6aDoJkYKeSF0aA
MAHGcA4Ae/sUyDEteuK01hdMD6V8RXb7HXahCkdv1sXhyNPwIb2BcL7elWCJ8DXw
AfRSBVOwUcAtdy5jcWjmrWMHm4rhrcBH0tsIIgpmC5MsQNr64cr8bozeg+IL8mcZ
toecUcPtzQOVC0FzVbE0tgJe7ZYy6/CUz/XsMzhoX0P9WBKeWg+mBWt9IqadYIqV
jIODOEJ11E9rmp3B46bfWzwLuytXNaZpNUezQmO2zZtliEDW6yZGDU3bjANtECmr
DBrgjo9ApTWJ8ERwvr7T53CO/edF/HjXEh+H0ha36M5Vwt10HSU3y1fsR7FXtWVL
fLsXKQlZdLcRejvzkbaPM92O2DOovp4E/5xMw/u6xWKqpjjV6UPQftauP/5jlDoY
SbtjEsC/1VzeRhwLWHTmEJGu/Odz83Fv292LlT1l37n0/ZkrROw9+PpnqcgcdoeM
bWljBqWO9wv3vCQDwt/elykF5ojPqWPukrtEzK8VadHDqmLtLWp9whlUz5Kvj5NK
mHzMwjPQHz0c+qd0TeUOTE9B+C1sVAq8xKGvI9nnr/wT7sbIdmWK2Sj8Ya9OEAI1
+0s3zvoDI6fS7dZLJKug8F0ETyhh4qkJag1fAVcYDRqTamAGT1La3VP0kUV8Ymb6
1vzhQVPJkej0jGWFS8g1
=q3oJ
-----END PGP SIGNATURE-----

--=-Q08dyElqo8J5Em+DwD+s--

