Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab2CULtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 07:49:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34537 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480Ab2CULts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 07:49:48 -0400
Date: Wed, 21 Mar 2012 11:49:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com
Subject: Re: [PATCH] REGULATOR: core add 3 new modes/statuses
Message-ID: <20120321114944.GA3226@opensource.wolfsonmicro.com>
References: <1332280258-5044-1-git-send-email-gg@slimlogic.co.uk>
 <1332280258-5044-2-git-send-email-gg@slimlogic.co.uk>
 <20120321002939.GA8567@opensource.wolfsonmicro.com>
 <4F69B254.1000603@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <4F69B254.1000603@slimlogic.co.uk>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 21, 2012 at 10:49:56AM +0000, Graeme Gregory wrote:
> On 21/03/2012 00:29, Mark Brown wrote:
> > On Tue, Mar 20, 2012 at 09:50:58PM +0000, Graeme Gregory wrote:

> >> USBBOOST this effectively turns the regulator around instead of using

> > In theory this could be done by other things so we should probably have
> > a better name, though in practice I'd be surprised to see many others.
> > It does totally break the idea of a mode, though - it's a massive change
> > in what the regulator does.

> Im not attached to the name, I just chose it as BOOST is a type of SMPS
> as well as being the common name for this function within TI. I do see
> what you mean by it not really fitting the "mode" descriptor well!

Plain BOOST does seem OK as a name - it was the USB bit.

> > Like I say I'm not entirely clear here, I keep meaning to try coding up
> > the custom API and see how it feels using it in a system - any thoughts?
> > Probably won't take me that long...

> This Im not really sure on, I don't see much info on the actual use of
> bypass mode in real devices yet. twl6035 uses it to power LDOUSB direct
> from USB bus intead of using the internal SMPS. But so far that is the
> only usecase I know of. Which of course means in bypass mode we not only
> have to change parent to some non existent virtual regulator but also
> enabled bypass mode.

There's some other stuff deployed already, though mostly internally to
drivers as the regulators concerned aren't generic regulators but are
internal to the device.

> > You also get this for ganging multiple regulators together to give a
> > higher power output, though normally you want variability so this has to
> > be handled at the hardware level.  This one also has an impact on how we
> > handle voltage changes, it'd be good if we could arrange things so that
> > get_voltage() and set_voltage() work through/with a regulator that's
> > tracking.

> I could see this also working if you set a parent regulator with a
> TRACKING flag so the framework knows the link. The other thing to
> consider is the twl6035 when you disable the parent SMPS on the LDO in
> tracking mode the LDO then switches to non tracking mode and uses its
> own configuration. When you turn SMPS back on it switch back to tracking
> mode.

That one is even more fun, it's relatively straightforward if they both
have the same configuration but otherwise...

> Altogether it looks like adding these features requires a lot more work
> than I had originally hoped :-(

> I guess the best way for me to proceed is to start to think about each
> of these "modes" individually and see what support I actually need from
> regulator framework to get them implemented.

Yeah, probably.  It's more likely something will happen about bypass
mode without you doing anything but I wouldn't rely on it.

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPacBRAAoJEBus8iNuMP3dM2YP/0d+c/QlaPbuUTXTsoMVcKc9
DwOQEjfrwKoruUZ0nHv+xRSpyHLtPaOczbzmuQomI6Mz3ddTYjemfse0U1KSgzXZ
CoYGMja3i6yA0Fj6Y0/hxDDPP+ou1fhSERMzhpsYnYtl7sY/44kUF9XaN2LhqWCl
IvJN50/fgkAzkmAbRIIz07zar7qmd+jYcXVCeFDQMCHwfVMqnL4yLefJ5Xy/Wbpc
jg2Mux/IussMgXth9mGbR7FXPUk+XrScmdPCtOXnH/Jurt3RHFmmk+aPXYepZMiM
4MPa5El7EzawyyUp89/Z/kZCab/uv5LToSCR9dCjOrshAeA4AqCUWKc8S7n2fQy8
uAYmXvuwfpzeQh2U2H27bJi64SNvn2dzQdEFLdEUdSMPNsvbndAFqN17YFhPl9OD
ruybqpLwws390ny6Eq2cS+ZKeYURo+PfdraJ2BZ9kz+SSX3A96P1ntsbXHfsD1vO
KtRKz6ubKGd9DjvJph/328dePpH9ZGWnwSrCFscjAY+l+RcJxW1hHcAnMde+Pahf
cKJxl3wyaS3ChotuPbrLts2MniqzYbo3a/RAH2ceILLm9zjjmqOQCLu18ErXpIiW
Uxvuhl7Qw44hPVtEqTrLmR+6KVTCCEvYHm8oWy2PxGuT8eL4goduWRX8UwqvSzhK
1JU19/FTt0Ce67lKCYmr
=ItD2
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
