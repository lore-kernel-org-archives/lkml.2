Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab1JBTAQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 15:00:16 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:47395 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754070Ab1JBTAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 15:00:00 -0400
Date: Sun, 2 Oct 2011 21:59:54 +0300
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 16/30] usb/musb: HDRC depends on TWL4030_CORE for OMAP3/4
Message-ID: <20111002185953.GB25690@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <1317566760-25681-17-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VrqPEDrXMn8OVzN4"
Content-Disposition: inline
In-Reply-To: <1317566760-25681-17-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Oct 02, 2011 at 04:45:46PM +0200, Arnd Bergmann wrote:
> The musb_hdrc driver tries to select TWL4030_USB or TWL6030_USB
> on some platforms, but those symbols in turn depend on TWL4030_CORE.

the very fact that MUSB tries to select those is wrong. That's also some
buggy legacy crap which is still floating around...

MUSB does not depend on TWL4030. MUSB depends on a PHY being available,
no matter which one.

IMHO, this would be better moved to board definition, ideally with an
option for selecting some symbol as module (as I have suggested before).

Ideally, all those broken dependencies on MUSB would be cut down to
depends on USB && USB_GADGET.

--=20
balbi

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOiLSpAAoJEAv8Txj19kN18DcH+wSGtsmnq2ROFyLlYU8FYK+4
1+yjEznbrqsifO0SfhiO1fI3QO9uNcMtxjuvbmvcpQErTUfx3omubM1Gwv/ea3YT
y5WbxScvwyqhWtXqNhSwPz9XeF1xRkxqyPHRD+IkQhbA8PMFW0Iyfev2jHJuRcua
T/xdPGw/9z6igxjj6AYQvWP1mUJJDI0POavpm8nqhM5IS3nKqd1i2C/ydyz5PBqV
aatvMsSFyzjuyMq5qW4zeQB+p8FTvX3voerwhCrvJqm0XL3wQeiPppkVKVoekNsm
vlSKemqAyRnjbsqENLcv50yYQTIj1Tn7yVkZJuj9ur68UuBUelDB6xGJFSTSpCs=
=Pw7r
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--
