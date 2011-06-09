Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab1FIJMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:12:21 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:34599 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753956Ab1FIJMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:12:20 -0400
Date: Thu, 9 Jun 2011 12:12:14 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Tatyana Brokhman <tlinder@codeaurora.org>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RESEND v15 1/10] usb: Add usb_endpoint_descriptor to be
 part of the struct usb_ep
Message-ID: <20110609091213.GA13552@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1307360469-29120-1-git-send-email-tlinder@codeaurora.org>
 <20110609083207.GX13552@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ds9maZbwT7uk2FVi"
Content-Disposition: inline
In-Reply-To: <20110609083207.GX13552@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ds9maZbwT7uk2FVi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again,

On Thu, Jun 09, 2011 at 11:32:10AM +0300, Felipe Balbi wrote:
> On Mon, Jun 06, 2011 at 02:40:45PM +0300, Tatyana Brokhman wrote:
> > Change usb_ep_enable() prototype to use endpoint descriptor from usb_ep.
> > This optimization spares the FDs from saving the endpoint chosen
> > descriptor. This optimization is not full though. To fully exploit this
> > change one needs to update all the UDCs as well since in the current
> > implementation each of them saves the endpoint descriptor in it's
> > internal (and extended) endpoint structure.
> >=20
> > Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
>=20
> now that I look at this patch carefully, won't this break all gadget
> drivers ? I mean, if I apply this patch, all gadget drivers will be
> using descriptor from struct usb_ep, but noone is actually assigning
> that pointer.

actually, I was wrong. The gadget driver is setting it, not the
controller anymore. I'll take this series in.

--=20
balbi

--ds9maZbwT7uk2FVi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8I5tAAoJEAv8Txj19kN1qPcH/jWE5IlPOmx3vspXokgzwxJo
VATVmWifIk6FYj6S/289P1cJoQeiGVZAJxp6+5Ta+ObhAhkHPkRF5TK38S0aeVRM
8O3Qw+H8EaTZvcXC2Ulj86JNYiYE4T03gs3bwyHASAhMf6sB2Yir4+2Aju6ljU5d
FZ8x6/ten8Wg1PO+G/M62TqgERPpDe/9EIxsGj8zaFqpgZcVr+aRqNEuI0nYrwz3
5//tfmklcBT9jp5ASxDGdj1tEqu/dkxTqGvD8wOAS345MAofxa8TjxAntHM78I7P
gC55+1HSlC4ivCjK34dIavzPO1dMfHBUuMLH5JKy6Rovxop62NlxznrYeobCCV0=
=Hnsw
-----END PGP SIGNATURE-----

--ds9maZbwT7uk2FVi--
