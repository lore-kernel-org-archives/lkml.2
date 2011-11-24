Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1KXJZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 04:25:08 -0500
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:57591 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754612Ab1KXJZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 04:25:05 -0500
Date: Thu, 24 Nov 2011 11:25:01 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-omap@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "open list:MUSB MULTIPOINT H..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: musb: PM: fix context save/restore in
 suspend/resume path
Message-ID: <20111124092500.GF3352@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1322011104-21817-1-git-send-email-khilman@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KJY2Ze80yH5MUxol"
Content-Disposition: inline
In-Reply-To: <1322011104-21817-1-git-send-email-khilman@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KJY2Ze80yH5MUxol
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 22, 2011 at 05:18:24PM -0800, Kevin Hilman wrote:
> Currently the driver tries to save context in the suspend path, but
> will cause an abort if the device is already runtime suspended.  This
> happens, for example, if MUSB loaded/compiled-in, in host mode, but no
> USB devices are attached.  MUSB will be runtime suspended, but then
> attempting a system suspend will crash due to the context save
> being attempted while the device is disabled.
>=20
> On OMAP, as of v3.1, the driver's ->runtime_suspend() callback will be
> called late in the suspend path (by the PM domain layer) if the driver
> is not already runtime suspended, ensuring a full shutdown.
>=20
> Therefore, the context save is not needed in the ->suspend() method
> since it will be called in the ->runtime_suspend() method anyways
> (similarily for resume.)
>=20
> NOTE: this leaves the suspend/resume methods basically empty (with
>       some FIXMEs and comments, but I'll leave it to the maintainers
>       to decide whether to remove them.
>=20
> Signed-off-by: Kevin Hilman <khilman@ti.com>

3.1 ? so this should go to stable too, right ?

--=20
balbi

--KJY2Ze80yH5MUxol
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOzg1sAAoJEIaOsuA1yqREZnsP/3nBhHFH3vQ8Hg4SBgqnHhmq
tRjFBLThP+J9pDT9fR1ENqpyYa9X2JX34Ip+SmqVwxwDWWvuVCW926PWsh94CmC3
C+ete8E25e3u5KBpMLGJ8Sryj55R/RwMiVuydDQyzRGe4zRgSV9kVKSOQ2erDEN9
mM25xz7ERro2bJVsocHpJPrCzlrTY7q/zqbY3QlfRh5l1Z5uatvHKe6JsdhbuNKh
ETYm70XC4sMj9DonjYltx2l+XZXrBOwcSHF1LJbWpngi2rprjz2f9Q2D4Om0HeDG
cejda3EZ61rhA7CCOfiP+SYjMCOc1pYMVS/pevrUYaAXhJ9nj4+pmkjSu4hVrJjx
tS7KBKuC/Yt3sYHEmQPnr/Wui14SK8JMOwHiQUnoL1jtDf2oIwSbVvvTwhpDwyor
/mx1fIjRcyZpNc3u5SEFBVOYY9+bSwJOGK9x2mF0DMEvEYBPFxT/EzW9b7kVuGSq
eXu1IskVGzGktiY7lJkOFj449SMJCX3ciHSXo83hE55VrHTJD00uaWt1tVf+8xSL
mwp9IN8d/rUU5jfFlg1l1XUQbjygyvS4ezL8bca+sd6b9Nl2jzoytwHEUY9sbI2A
U1zfYwebn5jsgA5Ab14wbYXnUc5up6q4moeyx2NOIdvXRKZ6qUsdsuDmBk1tn1p2
Trus9FXcZ46YdX4iVCCK
=yceo
-----END PGP SIGNATURE-----

--KJY2Ze80yH5MUxol--
