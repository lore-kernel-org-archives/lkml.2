Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760670Ab2EDXlD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 19:41:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50123 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754728Ab2EDXlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 19:41:01 -0400
Date: Sat, 5 May 2012 00:40:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@ardb.de>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Igor Grinberg <grinberg@compulab.co.il>,
        linux-embedded@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: Handling of modular boards
Message-ID: <20120504234056.GV14230@opensource.wolfsonmicro.com>
References: <20120504185850.GO14230@opensource.wolfsonmicro.com>
 <20120504225514.GM897@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bGopQmzlzQgFk3Fg"
Content-Disposition: inline
In-Reply-To: <20120504225514.GM897@n2100.arm.linux.org.uk>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bGopQmzlzQgFk3Fg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 04, 2012 at 11:55:14PM +0100, Russell King - ARM Linux wrote:
> On Fri, May 04, 2012 at 07:58:51PM +0100, Mark Brown wrote:

> > I'm just starting to put some stuff together for this so I was wondering
> > if anyone had been thinking about this and had any bright ideas for how
> > to handle it, and also if people think that MFD is a good fit for this
> > or if we should split the silicon MFDs from these PCBs.

> I don't think its true to say that there's no support for this kind of
> thing.

> If you're thinking about a motherboard with separate add-on cards, then
> you can view the cards as their own separate platform device.  Your
> platform device driver would be a "whole board driver" responsible
> for creating and registering the specific devices found on the board
> in its probe function, and unregistering them in the remove function.

Oh, absolutely - there's support there at that level and several boards
doing some or all of this in mainline already.  It's not that you can't
do it, it's that there's a bunch of generic stuff to do with how you map
the resources through to the devices on the modules and describe the
chips that are on the modules for which there's no infrastructure so
everything needs to be hand coded on a per board basis.  The board
identification bits are board specific but the remapping and subdevice
instantiation bits seem like they shouldn't be.

> It also helps to give the right model to the power management support,
> because you're automatically arranging the child devices below the
> board-level device, which means all the child devices should be
> suspended before the board level device, and the board level device
> should be resumed before the child devices.

Yes, I'd anticipate that we'd have a device for the board which should
help with this sort of stuff.

--bGopQmzlzQgFk3Fg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPpGkBAAoJEBus8iNuMP3dbgoP/iAZyZpWvzioO14ckQqlqxn1
qilkY+PggmVKpt0BVSbwFmXwVeid22JqFn/86ixqsl/ZyzsgxMA1zQGiHvKX05ok
uS6H9W/+5BPPVVL3CcSNll5+sXW9F/QgGeYQRPaJvBrnWf8WGzAiNRRYgR44zDZq
aOua8NdxopvweQZkHc2tf/hy6ODSmnv/oq8xvd6PuzKIvpcfgNIVPatjrhpiTEls
u//XNkb4qjl9caT76FSf1+ZUeleVIUrAZS3jIfsKfYat6CU8vLrmwrWxo68oRYag
yIi2BjbuexQce9gogkB71Q8V1Wbz5+3xuLOenX2k2XhJxnSSStdAza7e6rkrsDtH
n0BTmUK9/KxZxpBaxF76Wb4m1vLZIgPgJxtwbg3fPRk808rTIHYzwGD9PpeM/JRD
YdLyLkUp7Gdse0GHao29p5uEK9VZFDrDUN0bzwi3/UQQ5M5Cks0WAClfnHwV/O8S
Xo5n6uA20i3veUuOm1mnRyqPMtkYD0BbKx5mAVQM8pOWD2Vx8Ch977ESkV0ebXqn
sOHy6NsbMmaur3ECHvKu1DaJJjWyHz93W2OP6StOdyCIT2FApj4UG06BDr1oWFnj
m//K8v3DAaOvzyYwUvQpvV4P//zpLvLXw4wS7v1DFN39f23HsuLl85iTcfEgvPMs
2xaI5pkxmMsoHOKOPHCR
=ooBm
-----END PGP SIGNATURE-----

--bGopQmzlzQgFk3Fg--
