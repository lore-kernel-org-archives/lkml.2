Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1KXJ15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 04:27:57 -0500
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:47740 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754045Ab1KXJ14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 04:27:56 -0500
Date: Thu, 24 Nov 2011 11:27:52 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-omap@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "open list:MUSB MULTIPOINT H..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: musb: PM: fix context save/restore in
 suspend/resume path
Message-ID: <20111124092751.GG3352@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1322011104-21817-1-git-send-email-khilman@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qxfKREH7IwbezJ+T"
Content-Disposition: inline
In-Reply-To: <1322011104-21817-1-git-send-email-khilman@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qxfKREH7IwbezJ+T
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

applied, thanks.

I've added Cc: stable@vger.kernel.org so that this goes to v3.1 too.

--=20
balbi

--qxfKREH7IwbezJ+T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOzg4XAAoJEIaOsuA1yqREAw4P/0P5mQ6NwX7prw4VexJkGnYi
KYYl5bNikmumRbZeE5FbZHhNNyCcXRCDGNv54VAWjaG0CJF49W+thnccKKtHiqxc
3VnQRdKAOLD5Q/amR5DYDY2ghOIv/opmVxCeuAetcpkYXXjY9Yk/wom79tgXjAeA
J1ZMctpLVQJghJ9fp01hT6FDtBwI/rTPq140u/OQjiFhlUIk2u4u2w6MIcUwamlY
FuVfeHRPVmdzIJzPCC27ZtsFA7lUHLmQUzOe9YOV1Ik6sQlNtmsar5+dSaj6cfXw
vDN/yHPfuC4xzgDaonQ9jvlAJ6oJQ7Bl/zv0zi8fTp9wBQHotEhP59KMKVTGM0fI
3DQ8Z4xzVRKAtLk9xq6e3h0FPaoR21pPoolFCv+OjjyLPwz1CVl9hlzfW2sdGzm+
BCoT5K/ve2mHyc1l+vqkyVgitMMvKXi/hsThV4g4hJgBm6MmzohPvls8PbQ41VI6
0gy6heeKZvXfe3E54sfZNZaqrAdFyXyF1wy+Pu8BPIyNRkWKhm2e3WpPZQBKndel
t2MKRP03+0teR/wLH6bsN3Q6tMCoQb0hYpchUHqU3887w/JINq1H1CDaXDLar+xJ
VvKUMG6CUvRxGRuB4DP01rdpTAJTuO0JEaPXuf/D7kya+yMQFcINk1RRZMSX+w7L
K87/S4SJ72K+P/B8sYby
=2PQr
-----END PGP SIGNATURE-----

--qxfKREH7IwbezJ+T--
