Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab2BCNwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 08:52:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49406 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134Ab2BCNwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 08:52:18 -0500
Date: Fri, 3 Feb 2012 13:52:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/07] ONKEY: OnKey module for DA9052/53 PMIC v1
Message-ID: <20120203135215.GO3151@opensource.wolfsonmicro.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED1FDDA575@KCHJEXMB02.kpit.com>
 <1328275446.19234.127.camel@dhruva>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c2gYorpyS4gG0T74"
Content-Disposition: inline
In-Reply-To: <1328275446.19234.127.camel@dhruva>
X-Cookie: You will be divorced within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--c2gYorpyS4gG0T74
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 03, 2012 at 06:54:06PM +0530, Ashish Jangam wrote:
> On Fri, 2012-02-03 at 17:28 +0530, Ashish Jangam wrote:

As *repeatetly* mentioned please fix the word wrapping in your mailer.

> > That doesn't seem to address the concern.  You're setting ret in exactly one place
> > and scheduling the work in exactly one place, why are these two things split?

> schedule_delayed_work() is conditional because it should get invoke
> when onkey button is pressed and not when released. For this reason
> onkey event is first queried and work is scheduled only when event is
> present. Now when work is scheduled, onkey event gets queried and in
> absence of the onkey event work will not get schedule again. By this
> logic I'm able to simulated the release of the onkey button.

You're once more completely missing my point.  You've got a conditional
which detects if the button is pressed in which you set a flag which is
checked later to see if you should also schedule the work.  Since the
only thing that ever sets that flag is the button being pressed having
the flag seems pointless, you may as well just schedule the work instead
of setting the flag.

--c2gYorpyS4gG0T74
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPK+aIAAoJEBus8iNuMP3dmlUP/3JZ/suLNSRWPE2CLF0H4ip0
kJM7wqBpxuSCuQPqc9IYXyj1tKsS8JUd321g9q9AN9Ty1s8/WUjs8hEP8p0+mzi6
JA6+T+c8cPpFOOQZYTMXSlzJ+NXOgqwdrlB+xWafDUEGu/uqX/I6L4DioRAQJkHA
dammG+jjJkTVgAfCCPu/8CHhUwm+w+ZogNV3Lq6/kS0Of/W//NMb8+yGEdjE2XIP
xd8whK41hYw1Wjk6zqXZDoctPbWS9QnEGKNJA1ZrVj11GXMJ8TNapSsx6clBIkPO
w8FITY1rDFEMI09FYR035mUHycP8R/NKXd/F3Y8LZx28RA0jJYQ2oy+oHQwian/r
349Xa4q3bLLc0FhQ7m2db9ezLkDqPywOOFCNZkKi4tOTA9JSCIMby6KJ+FI6EFdO
JQ63nTKRWayP+I37yg9Afh/pF1Ux3vaRUZHUi7L9Tvi9G9yhlbcjzKS1OkK4oX6o
S6yPoyJsaDltcvmg+X5KcdbJUwU+twc5qF8HWIrMSHfjpEn9sfnBumdGURfbRZxs
23pjQxxoyKAHxCv3F4cymsjEuPm+3aQpXjS+iwheksVBYJvA3BQ9lMDEa53sQvCl
mEFYGZfpr/pNT3RZ6eumuAUxa0FoK6Vdix5zfFmXPJj+Zz1cr/AiHkmToSOFOk+R
8CVIt+SDFlRXimiW/fPx
=j8tH
-----END PGP SIGNATURE-----

--c2gYorpyS4gG0T74--
