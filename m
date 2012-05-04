Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab2EDJJC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 05:09:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33001 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752674Ab2EDJJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 05:09:00 -0400
Date: Fri, 4 May 2012 10:08:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 2/3] MFD: twl6040: Allocate IRQ numbers dynamically
Message-ID: <20120504090856.GA14230@opensource.wolfsonmicro.com>
References: <1336049665-27777-1-git-send-email-peter.ujfalusi@ti.com>
 <1336049665-27777-3-git-send-email-peter.ujfalusi@ti.com>
 <20120503132004.GB14296@sirena.org.uk>
 <4FA2881B.6010902@ti.com>
 <20120503145248.GJ3955@opensource.wolfsonmicro.com>
 <4FA2A08C.5000403@ti.com>
 <20120503152643.GM3955@opensource.wolfsonmicro.com>
 <4FA3958A.4080206@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <4FA3958A.4080206@ti.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 04, 2012 at 11:38:34AM +0300, Peter Ujfalusi wrote:

> The irq_base was used to map the nested interrupt numbers somewhere high
> enough. twl6040 has one irq line towards the CPU (comes via
> i2c_client->irq).
> With this change we just change the mapping of the nested interrupt
> range provided by twl6040 (instead of hardwired number we ask for
> suitable range).

You're not understanding the issue at all - the issue is that if
some driver outside the twl6040 driver is using an interrupt in that
range based off the irq_base that they supplied then you'll break them.
The most common case here is using GPIOs on the device as interrupts.

If this is safe you should at least be making it clear why...

> We have sdp4430 and PandaBoard with twl6040. They are fine. The other
> non upstream boards should be fine as well with this change.

...ideally in a more concrete way than just saying it works on your
reference boards.

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPo5yeAAoJEBus8iNuMP3dtbYP/2iCwbJLD2d0ESRZnuZ7RDas
JAFaY1/QWI9fTMqBjhm7TlD6iKaxgsXFYrJFOzM9w49X318Dh8PxWbGaopMS1jm4
MDsoBdmKi3bVhMvB2S6rgUE7zXbLRX1T0dlXbCkJtQvBjkKvEPeLguSPIjcMf2Ep
33gf47N/+ikaLa4/LiSUOamLTpQ9Vt4w70vfXTwRO6z6iSZE/+EwhpgSPEpCV/3x
yii8xbu7aLfetr8U9EtgtfFsoPGaBVH6hdLCcewwo1/5U4/POoISOTf+6G9/jJK8
kUiaZaeO3UHFzFLgQGDszP2C0NZ2cJ98WMQi5Bj0WqM2B8iR7MyLpvkzkzwkxVCF
VoHyHx1Wm7nUJywMDzX5KP1E0z2OhSGSCkgFUH2pOrzyv+osUXaDmKpO5lYL9zEs
liHL0sRBSfxUU2ZHOcszgVOTGot/6OaxE8z3HA2uY4Uvt4VBa7wKH3TiXoH0MKyK
uonC5j8C7/5rguTefypXQ8tUxIIYsiEn1rt2crL2daYLEPpImCEToALqU1VITnsX
KCgl7kEPIRsgeLw2SBaULzVuY/pfGhdx0JhBBuQL2diCxYzFMlTY7TiD8k5EP4mM
rB9N7aox+ZeAEBFEsMubQENUugepxNxzjoRIAWmHQZ/L6z3I2bidsBVNOBb68Jrk
N4dWecBceV2m+ndDb46s
=Otg/
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
