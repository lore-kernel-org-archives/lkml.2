Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab2BGTTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:19:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59105 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447Ab2BGTTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:19:46 -0500
Date: Tue, 7 Feb 2012 19:19:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v3] ASoC: da7210: Add support for PLL and SRM
Message-ID: <20120207191943.GB15929@opensource.wolfsonmicro.com>
References: <1328095529.15257.7.camel@matrix>
 <20120201115035.GC5648@opensource.wolfsonmicro.com>
 <1328621149.26721.18.camel@matrix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <1328621149.26721.18.camel@matrix>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 07, 2012 at 06:55:49PM +0530, Ashish Chavan wrote:
> On Wed, 2012-02-01 at 11:50 +0000, Mark Brown wrote:
> > On Wed, Feb 01, 2012 at 04:55:29PM +0530, Ashish Chavan wrote:

> > You need checks elsewhere to make sure that the user doesn't try to
> > reconfigure master/slave while the PLL is active.

> AFAIK master/slave configuration is static(depending on the board
> configuration) and done via set_fmt() from hw_params() of platform
> driver. Can you please point me to an example where dynamic/runtime
> setting of I2S master/slave mode is supported?

The most common case is things like bluetooth SCO connections where if
there's a baseband you want to clock from the baseband but if there's no
baseband (eg, for VoIP calls) you can't do that.  Some devices also need
to change audio interface configuration depening on things like the
number of channels.

Even without any dynamic reconfiguration you also have cases where the
sequence people use to power things up is to set the clocking and then
configure the audio interface format - even if the audio interface
format is always the same you'll still get it being reconfigured the
first time you start up.

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMXiiAAoJEBus8iNuMP3dQrEP/20OGAlYAdFVLyBpuu8iVKXv
Zo/vmFo7SlV8cAT/dKryMz76blwwcmznkEhOxjkSrt2CjQqVuY8PmOxXNEDwTbjz
6Z69YRpmPt5fvGmFzGKIypIDL4YTG2hQm9vsHk8HMMStaU1ZhfGkqHvaPu2COTAu
zc2oJQlRuX+BlfsI5T5KVAibhJK7+9cbybMjfm8zlK/+Ykwyo4j5tSzleV5yDCq3
HcyQQHZGOXVbfexsb2avtWOih2Yg6KFzJRghtyHYhksFqtwk1rfvfeXzUpieBGVL
FQ+LnprhX0Hx0MvzvIi72BpJspgMPZk26wrXKdP4Vjc6HwHAtCey2srzjLbo9lUr
3LMm4bq1crN/dyPUfBwMVeYnhLpu8ABodzZCYhXCBw7jrkAJJlaLNUt5DLFlVkHA
VCHo6TGf4OIoGA8pPEFYGLjEwReO56G9kHHA69tkZg8RhHuhAjI/NXZm60BOdQgt
qw5UuEHqr7Up9KyGBPEoptRXR6oH/otqSy6pc8FsmgkP8TArPrlh6GJwxEucx1ab
uP87qhIH5BpPFhw5iEPOF0Zrfiv+u5vNh0SuebMgncnGJfwAQcBidEN/4wuMA27g
stCJyQI6BiUmRYmscX9W4ZFrIFExF9e+ZvwkBCq9V5kqJz0whVGGejVimUDmmz9T
8p9he/GvZ/94HVCnBmZX
=ZxcQ
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
