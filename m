Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab1FIIcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 04:32:21 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:47953 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419Ab1FIIcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 04:32:17 -0400
Date: Thu, 9 Jun 2011 11:32:10 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RESEND v15 1/10] usb: Add usb_endpoint_descriptor to be
 part of the struct usb_ep
Message-ID: <20110609083207.GX13552@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1307360469-29120-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V/5pStbHlGfNIMG1"
Content-Disposition: inline
In-Reply-To: <1307360469-29120-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V/5pStbHlGfNIMG1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 06, 2011 at 02:40:45PM +0300, Tatyana Brokhman wrote:
> Change usb_ep_enable() prototype to use endpoint descriptor from usb_ep.
> This optimization spares the FDs from saving the endpoint chosen
> descriptor. This optimization is not full though. To fully exploit this
> change one needs to update all the UDCs as well since in the current
> implementation each of them saves the endpoint descriptor in it's
> internal (and extended) endpoint structure.
>=20
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

now that I look at this patch carefully, won't this break all gadget
drivers ? I mean, if I apply this patch, all gadget drivers will be
using descriptor from struct usb_ep, but noone is actually assigning
that pointer.

A better approach would be to:

(a) add the field to struct usb_ep
(b) make each controller assign that pointer while still keeping the
	last one (keep the old interface too, make one patch per
	controller)
(c) make each gadget/function driver use the new interface (one patch
	per driver)
(d) remove the old interface from all controller (one patch for all of
	them)

--=20
balbi

--V/5pStbHlGfNIMG1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8IUGAAoJEAv8Txj19kN1/koH/2dFib7lfbT3YBtYiWVqhiDZ
lCtlKetABS9MrUqyj1y3st+AQJho5LtT8vDKrxaZsCgR1G8GJLWv2pqt8lYSNNTW
OxouK2/wgyIIKfv/DNslq2z0iQ6gAhdwJKF5tG2Lw1JpLCXrNEqKF/ed+7tGbu+i
lOv/2ghUJwnzPF2PvW7R52/12k9RaHlQUikP4nlWrmpXMEomojkh2wSzHFrMWzuq
tPmVI4c1vKSDw2qbcP7eJEw+83AIukYou8M3WtHH06zpi5EdIuypW+5K6T5D3s0h
ZP8cO9PM4SOZ7Qsi34q3nIOG1dxHID5et+GUjO9n22gyfJOAZ0wO833AWFPpTIQ=
=1ZQH
-----END PGP SIGNATURE-----

--V/5pStbHlGfNIMG1--
