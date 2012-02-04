Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab2BDPtU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 10:49:20 -0500
Received: from home.keithp.com ([63.227.221.253]:38612 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058Ab2BDPtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 10:49:18 -0500
From: Keith Packard <keithp@keithp.com>
To: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: debugging code shouldn't alter control flow
In-Reply-To: <Pine.LNX.4.44L0.1202021536080.1389-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1202021536080.1389-100000@iolanthe.rowland.org>
User-Agent: Notmuch/0.11 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 04 Feb 2012 16:49:06 +0100
Message-ID: <86r4yatx8t.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 2 Feb 2012 15:38:14 -0500 (EST), Alan Stern <stern@rowland.harvard.=
edu> wrote:

> -	urb->transfer_flags &=3D allowed;
> +	allowed &=3D urb->transfer_flags;

Minor bikeshed here, but 'allowed' is not the right name for the value
at this point; perhaps just
=20=20=20=20=20=20=20=20
	/* warn if submitter gave bogus flags */
	if ((urb->transfer_flags & allowed) !=3D urb->transfer_flags)

might be better?

Otherwise, this looks nice to me.

Acked-by: Keith Packard <keithp@keithp.com>

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTy1TcjYtFsjWk68qAQjvag/8Do4M+cqolVolpsjc0qt9fthqf/NZuNwn
KksyIkXDdaziFgPEQRTUtwFCiNXyaOeYpswY7n85EVsGIC2u9FlYWPm+Z4Q7V5E1
5v3vDfnuPiPxQbxAYu+ankYuVaGTTG7jKIdu/+ZX/f+kZ0PbczmwqsZNKGL4o2Pu
Pj3wUb8eevb9f6GVfK4P5jmya7uY7g/abi2XlzmXsXr34drw6kYJGUHGYvP17NE9
HPpCUtHdgBwSQh2Zcql5IlvT7wlGdNUoVKX+3qZpcvOfp2pKvxtZt4WVUmp1ilmk
nYxQmzedQgALvGEQnpSTHB+t2YJ+hTOQ6vcBl+GGvZFHDh7OyUQjv+djP7bu/xwD
FkGyEdUwYFZSDNXhGEThUVpbDo0WGAuPn4VEM6P3+LZYY4MJnIY7+RS0R+rRSYrt
QVL8vjBiusLM+KcTysL+GWtTAq40K56+U8Wf1z0yWG+ICbSbIbNbCZLMj1Cn5Zvb
piXZ4CVfxB+sV0oxvT0iMNoB9uypWu0M0ayPpnLEZhYi20+V3AenxWAA6ul24kn9
06gfKrU3AI8eeGZFi8ss0sKiUk5Ipb1/FzNJvpSdWPPn/OwOF4rSDxSV83W7Mo7q
kT2FuyFXNMMxuOd1WXEvOYG/c9wMUdip0qy/U+x8iGw1hUqQ7bl+iiiRHFdlsPMv
hQnkax1ifFM=
=FrhN
-----END PGP SIGNATURE-----
--=-=-=--
