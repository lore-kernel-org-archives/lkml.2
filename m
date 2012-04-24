Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab2DXK4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 06:56:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59990 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358Ab2DXK4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 06:56:08 -0400
Date: Tue, 24 Apr 2012 11:56:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] regulator: core: Keep boot_on regulators powered during
 init
Message-ID: <20120424105603.GA12063@opensource.wolfsonmicro.com>
References: <1335173873-24301-1-git-send-email-ulf.hansson@stericsson.com>
 <20120423101804.GA8318@opensource.wolfsonmicro.com>
 <4F953455.3080002@stericsson.com>
 <20120423110522.GB8318@opensource.wolfsonmicro.com>
 <4F95495D.4050508@stericsson.com>
 <20120423122555.GM8318@opensource.wolfsonmicro.com>
 <4F954ED6.2040201@stericsson.com>
 <20120423180140.GR8318@opensource.wolfsonmicro.com>
 <4F965FC4.7010502@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <4F965FC4.7010502@stericsson.com>
X-Cookie: Be careful!  Is it classified?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 24, 2012 at 10:09:40AM +0200, Ulf Hansson wrote:
> On 04/23/2012 08:01 PM, Mark Brown wrote:

> >Can the driver use is_enabled() in the probe routine to check the
> >current status during probe and hand off appropriately?  The issue here
> >seems like it's the fact that the driver isn't managing to bootstrapping
> >of its state well.

> Well, it is not as simple as that. An mmc host driver is just a
> driver for handling a certain mmc IP. Uper layers handles the
> (e)MMC/SD/SDIO protocol including controlling power the card.
> Moreover the complicated detect procedure is handled in a work.

> In principle what you are proposing will mean that each mmc host
> driver will have to "flush" the rescan work from probe. This will
> have horrid impact on boot time since rescan can take several
> hundred of milliseconds for each eMMC/SD/SDIO card. Is is far better
> to handle the rescan in parallel works.

No, that's not what I'm suggesting - all I'm suggesting is that the
driver uses is_enabled() in probe() to check if the regulator is on, if
it is then it grabs a reference to it.  Then, when it's figured out
what's going on, it can drop the reference again if it's not needed.

> I really think it would be much beneficial to be able to tell the
> late init call (regulator_init_completet) to back off from disabling
> this regulator. If not using boot_on, we can invent another
> regulator constraint for this. What do you think of this?

This just seems awfully fragile and very much dependant on things like
having the driver actually enabled to clean up later.

> >Worst case seems to be that the card will be briefly powered during boot
> >then turned off again after enumeration which doesn't seem like the end
> >of the world to me.

> It is really crucial that the regulator is not switched off in an
> uncontrolled manner. It will mean viloating eMMC spec and in many
> cases the hw is not able to reset the eMMC and thus the detect
> procedure will fail. Likely the eMMC holds root file system then the
> platform wont boot...

Right, but I'm talking about uncontrolled enables not disables - worst
case is you'll have to do an ordered shutdown you wouldn't otherwise
have to do but that doesn't seem like the end of the world.

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPloa2AAoJEBus8iNuMP3d5WkP/2RZIH7iEZBIF8kACryKlKh4
jerNLI3/bInlHFpDKM5Y7944fMPWfPyT//azwFcjMhQunOLkI1DrPofCAsFNN/l0
kkSZH4uaz7gB1a6NqIzbxFg/KWMosJk1ll4WRaD5w0dQjnfRqqIZiylVnGZ6lXvs
0LT30w0RdrIW0DdTA4rJQ3MchIY0ABGkDM0EhK779/oqpQ0rQt+ZlQRhxYn/DoEf
ETXKOeAiLaKEGyhbTxqDj8rJhmOP6yL1wtLTyo2xSNX2Sf9Pq01P/OHuHfW0ufzq
rkfihEsNzJsmjcuhhZGpXF10p+esKA0MF8kfpBDjqbTfDrJQ8wDNXyAvCV3gcFL+
YLXd7E45npIgTP8pkwxfbR6gZYrl1YnllbXEflf9jTgqtfK2Veixg5Ode1p/DMhl
ILwcbf5fRXEZACmirwcmp5h8zEFKb6/7MpO47lCPjIRqF51RMcbTjNNv2+mEHBo+
5PM6gsZUlnLqDBuBj1x8TQUGPma8a3fc3TOCsx98UyGwTuIIG4rfRjQ7X2q1uhPZ
D/aQgGn2mQQrKiOb1FQYvvUDvRVj1cX0aH0ApCMCqvKpvQA+L/q86h6cweviX3yu
TW3exv85juisYCEUCLfRpQE6VOqHktSvyJ3/Bci+b91RwnIU23X79pq2oZuSmnWt
5tGtmsGHhUFCkaluW8Me
=Jz/B
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
