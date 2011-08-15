Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab1HOUD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:03:58 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:38997 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302Ab1HOUD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:03:56 -0400
Date: Mon, 15 Aug 2011 23:03:50 +0300
From: Felipe Balbi <balbi@ti.com>
To: Doug Anderson <dianders@chromium.org>
Cc: balbi@ti.com, Ben Dooks <ben-linux@fluff.org>,
        Stephen Warren <swarren@nvidia.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>, Jean Delvare <khali@linux-fr.org>,
        Rakesh Iyer <riyer@nvidia.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] i2c: tegra: Check for overflow errors with BUG_ON.
Message-ID: <20110815200349.GA2616@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1313434172-18319-1-git-send-email-dianders@chromium.org>
 <20110815191745.GA7178@legolas.emea.dhcp.ti.com>
 <CAD=FV=Xd67iw=GXV9i4O5LKnJd20=BkYyfVuxPgxQ5GZRJEy4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <CAD=FV=Xd67iw=GXV9i4O5LKnJd20=BkYyfVuxPgxQ5GZRJEy4A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI,

On Mon, Aug 15, 2011 at 12:52:36PM -0700, Doug Anderson wrote:
> Felipe,
>=20
> On Mon, Aug 15, 2011 at 12:17 PM, Felipe Balbi <balbi@ti.com> wrote:
> > so due to a FIFO overflow you lock up the whole system ? Can't you e.g.
> > reset the controller and reconfigure it rather than locking up the
> > system ?
>=20
> Certainly we could try to be more proactive and reset / retry / return
> the error to the client.  However, since the only expected situation
> where this BUG_ON should hit is due to a bug in this driver itself
> (AKA: i2c clients shouldn't be able to do anything to cause the BUG_ON
> to hit), that seems like a lot of added complexity.

so at least just pass an error to the client, but hanging the entire
system seems a bit too much, dont you think ?

> Also: if there is an arbitrary software bug that causing an overflow
> condition to occur, I'm not sure how stable the system will be.
> Specifically, the i2c controller is used (among other things) to talk
> to the PMU and adjust voltages in the system.  If we just sent it a
> random command, I'd rather report the bug right away so we don't get
> hard to find/reproduce failures in other parts of the system.

that's a good point, I still think that e.g. making a cellphone
unresponsive until a watchdog reset triggers just because you got a FIFO
overflow on the I2C controller is too much.

--=20
balbi

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOSXukAAoJEAv8Txj19kN11pQIAJlIJw+kHOicIT917XAJFY6E
ozSUe9rSBTkr7/jyBub7VGHWyMw5dJE6QvOOyuyl0Z+BMjcmEwRqTdRuX1rIM0AD
RHCh5BsPa16mnO9v3CVCt+Jn0Cu96j+iNM730rduUMc1cJRDDA0cCLjwBye4DCUp
u+7p+QfilZHuIsnlnuSOjMLdglE3FUszlhbcr58YObtc8F+tmqNuaNJdBtB6ZrHI
vbX5xCXOV9TPm5ZBCDa+vvWv4wVbWd7qxUJKKjs1+eGXvMG1E4MjiE6V+6D5hwsc
DJAumuKbeYPytN04liYsvhZIDrjzb9qolxMro+JN3NjdIPMPNxkBK2g/R3Rld8w=
=WPkP
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
