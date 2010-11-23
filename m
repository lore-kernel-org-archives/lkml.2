Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab0KWOaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:30:39 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:59877
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447Ab0KWOah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:30:37 -0500
Date: Tue, 23 Nov 2010 06:30:26 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Message-ID: <20101123143026.GM20296@one-eyed-alien.net>
Mail-Followup-To: Luben Tuikov <ltuikov@yahoo.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
	James Bottomley <James.Bottomley@suse.de>
References: <20101123050048.GL20296@one-eyed-alien.net> <589506.10541.qm@web31809.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5V5c01chtBAiSHoy"
Content-Disposition: inline
In-Reply-To: <589506.10541.qm@web31809.mail.mud.yahoo.com>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2010 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Tue, 23 Nov 2010 06:30:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5V5c01chtBAiSHoy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 23, 2010 at 01:25:23AM -0800, Luben Tuikov wrote:
> --- On Mon, 11/22/10, Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
> wrote:
>=20
> > What are the consequences if the device returns what appear to be a
> > Caching Mode Page, but it is actually filled with garbage or otherwise
> > inaccurate data?
>=20
> Data corruption would be no different than when determining whether the
> media is write protected or determining other parameters. A similar
> question would be "What would the consequences be if the device
> misreported the media write-protect bit?" I suppose such a device would
> be quite broken and inoperative.

Not really.  In your example case of the write-protect bit, either the
device would be improperly marked as write-protected when it is not, or we
would improperly send write commands to a protected device.  Neither is a
great tradgedy; commands will fail, errors will be generated, and life will
go on.

However, I don't know what is in the Caching Mode Page.  I don't know how
those bits are used to determine the behavior of the rest of the kernel.
Maybe one of those bits means "only store data in Japanese" or something
equally disturbing.

The old code used to make a "safe" default choice if the caching mode page
was not available (for whatever reason).   What are the implications of not
making the "safe" choice improperly (due to mode page corruption)?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I need a computer?
					-- Customer
User Friendly, 2/19/1998

--5V5c01chtBAiSHoy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFM69AC3gL8qCooyc4RAopkAJ9zVEO1kytH7HAIgGI0Q61R4zkmagCdFU64
90jNyG/WDU1bKDzyEVlmgNI=
=xraA
-----END PGP SIGNATURE-----

--5V5c01chtBAiSHoy--
