Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab1FFLhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:37:52 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:43341 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755673Ab1FFLht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:37:49 -0400
Date: Mon, 6 Jun 2011 14:37:43 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, greg@kroah.com, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 4/9] usb: Add max_speed to usb_composite_driver
 structure
Message-ID: <20110606113742.GY18731@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1306847914-19876-1-git-send-email-tlinder@codeaurora.org>
 <1306847914-19876-5-git-send-email-tlinder@codeaurora.org>
 <20110606111755.GV18731@legolas.emea.dhcp.ti.com>
 <00ef01cc243d$92c6d150$b85473f0$@org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1olvqv+k0f6DP9aD"
Content-Disposition: inline
In-Reply-To: <00ef01cc243d$92c6d150$b85473f0$@org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1olvqv+k0f6DP9aD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 06, 2011 at 02:33:32PM +0300, Tanya Brokhman wrote:
> > On Tue, May 31, 2011 at 04:18:24PM +0300, Tatyana Brokhman wrote:
> > > This field is used by the Gadget drivers to specify the maximum speed
> > > they support, meaning: the maximum speed they can provide descriptors
> > for.
> > >
> > > The driver speed will be set in consideration of this value.
> > >
> > > Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> >=20
> > personally, I don't think this is good enough. The gadget speed is
> > actually the min() of the f_* speeds. So, IMHO this should be coming
> > from f_* and during bind you would:
> >=20
> > gadget->speed =3D min(f->speed, gadget->speed);
> >=20
> > for all functions. Also, both this patch and what I described above,
> > only works considering nobody touches that enum, so we might want to be
> > careful and add some comments to the enum to avoid anyone from touching
> > that :-)
>=20
> You're right, the full and best solution would be to set driver speed as =
the
> minimum of all the speeds its functions support. (Please note that it's t=
he
> usb_composite_driver speed we're talking about and not the speed of the
> gadget).
> Unfortunately, we need to determine the driver speed before any of the
> functions binded to it so the above solution isn't possible.
> In any case, gadget->speed is determined upon real connection to the host
> that can occur long after the f-> bind() and it depends on whether for
> example SS HW negotiation protocol succeeded or failed.

true, let's take your approach for now.

But we might still want to force HighSpeed even though the HW has
SuperSpeed support. The real solution, for the long run would be to
always start with pullups disabled (iow, don't connect to host
immediately) and only connect after the gadget driver is all
initialized, then we will know the gadget speed before connecting, and
we can have the gadget driver "request" for a particular speed from the
controller.

For now, let's take your approach.

--=20
balbi

--1olvqv+k0f6DP9aD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN7LwGAAoJEAv8Txj19kN14fgH/jjss8oSnsiE1hrdBeKkRC+L
8Ke5e9nkkqq6z37YHI2og3rPAUZXB6spgbfxWygn275WyFSEPmV/4Xrc9P/LpGhR
3O1qbi8FYKZ0RpIRChm2sp4/HkcyEG2fI8PQg09qtIZYbBbcdZr9hJBVv/DI3S3P
9pL4b564iGa3u8KlGkRRdb72wiO4jEeF95cQFWdD8DFBOREfPm6+kXqo4O9UeovU
O/Qk3VK/pg2haQZVyGOR0iS7CJVmoyx0zYm1di7/1iP48nbXJg7hofT/75/UPhvp
FswYY3QzqTCwp3O0Iwn4a5pBVj2NQJtUgKzmtdOt7Z6e/Wt9yovlQh4GsHm3e2g=
=CnNF
-----END PGP SIGNATURE-----

--1olvqv+k0f6DP9aD--
