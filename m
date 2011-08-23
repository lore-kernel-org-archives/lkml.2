Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab1HWRUC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 13:20:02 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:42172 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755234Ab1HWRTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 13:19:55 -0400
Date: Tue, 23 Aug 2011 20:19:43 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mnazarewicz@google.com>
Cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
Message-ID: <20110823171942.GC10996@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <op.v0n67imkvgw7ix@mnazarewicz-glaptop>
 <Pine.LNX.4.44L0.1108231030270.2069-100000@iolanthe.rowland.org>
 <20110823145759.GM1341@legolas.emea.dhcp.ti.com>
 <op.v0n9l9h9vgw7ix@mnazarewicz-glaptop>
 <20110823151105.GP1341@legolas.emea.dhcp.ti.com>
 <op.v0oaia2bvgw7ix@mnazarewicz-glaptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
Content-Disposition: inline
In-Reply-To: <op.v0oaia2bvgw7ix@mnazarewicz-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 23, 2011 at 05:26:24PM +0200, Michal Nazarewicz wrote:
> >On Tue, Aug 23, 2011 at 05:07:11PM +0200, Michal Nazarewicz wrote:
> >>If you look at config_buf() in composite.c, you'll notice that composite
> >>just skips functions that do not support current speed.  This
> >>means, that if a connection uses high speed but given function
> >>can handle only
> >>full speed, it won't be included in the descriptors.
> >>
> >>config_buf() is called from config_desc() which similarly, iterates over
> >>configurations skipping the ones that do not support given speed.
> >>
> >>Configuration is defined to support given speed if at least one function
> >>that is added to that configuration supports that speed (see
> >>usb_add_function()).
>=20
> On Tue, 23 Aug 2011 17:11:06 +0200, Felipe Balbi <balbi@ti.com> wrote:
> >I'm trying to think if this is really what we want. This might mean
> >$current_config will be different depending if we connect it to SS, HS
> >or FS hubs.
>=20
> What do you mean by $current_config?  The bConfigurationValue will be

the currently chosen configuration.

> the same for "the same" configuration regardless of speed but different
> configurations may be available for different speeds and "the same"
> configuration in various speeds might have different functions.
>=20
> So just for the sake of having something concrete, let's say we have:
>=20
> Configuration #1 with
>   function A supporting FS and HS and

my question is what happens with the HS support on function A
(descriptors, endpoints, etc) when you connect it to a HS hub or to a FS
hub.

>   function B supporting FS only.
> Configuration #2 with
>   function B supporting FS only.
> Configuration #3 with
>   function A supporting FS and HS and
>   function C supporting HS only (dunno if that makes sense).
>=20
> When connected to FS hub, we will return the following:
>=20
> Configuration #1: A, B
> Configuration #2: B
> Configuration #3: A
>=20
> When connect to HS hub, we will return the following:
>=20
> Configuration #1: A

See, I'm not sure this is allowed by USB spec. But I could be wrong. (I
mean having a function disappear)

--=20
balbi

--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOU+EuAAoJEAv8Txj19kN1Vu8H/1w9+p3WKS6wxHxkbSX3BrZm
6KG6IoVDGQpZC0Yz8HPAzVGrqwjWBzqp96HLPzSPpg5fUVQVGCafeV8tmzo2DeX9
VUSFcrkiby4YpzZ9KyNObbnZu9d1/au9A9VJjGL6Ws7I8t2L5kCpRFQXzU649zhU
TUtXlwb1KQ/kVujcumubla+h9b69xhGo4E05rT7mxJ+6IMMaKezihyLSsuTbGzVm
Fudlmzh7cWHPKDl+K7dsE6zcJeTeS0Ysbvh+biB48ZQ0BbvD9gFjgh1iU8QJvLh6
P0IJDZH9sLxtYFPJnLw0LXGH0ejX2o0OU8qalj/h9SdpSUmtTlvqu2eco/pqb/I=
=DDew
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
