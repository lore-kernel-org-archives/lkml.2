Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2DWB4X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 21:56:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45297 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab2DWB4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 21:56:22 -0400
Date: Mon, 23 Apr 2012 11:56:10 +1000
From: NeilBrown <neilb@suse.de>
To: shuahkhan@gmail.com
Cc: Jonas Bonn <jonas@southpole.se>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: Re: [PATCH ] leds: add new transient trigger for one shot timer
 support
Message-ID: <20120423115610.2da4d4d7@notabene.brown>
In-Reply-To: <1335138687.2882.20.camel@lorien2>
References: <1333310039.2879.4.camel@lorien2>
	<1334064283.10826.6.camel@ted>
	<1334507752.2723.3.camel@lorien2>
	<1334894674.3051.18.camel@lorien2>
	<1334983269.2435.90.camel@jerome.southpole.se>
	<1335138687.2882.20.camel@lorien2>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nNsEhl/JAU.MhpcP.ojCWQO"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/nNsEhl/JAU.MhpcP.ojCWQO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Apr 2012 17:51:27 -0600 Shuah Khan <shuahkhan@gmail.com> wrote:

> Hi Jonas,
>=20
> activate does sound better and having units in the property name is a
> good idea. Will make the changes including the 0200 change for activate.
> Will change the transient_time to transient_time_msec (no problem using
> duration, just that time is shorter :)

I'm not sure I agree.

I think there are two possible correct choices:

 1/ follow the established pattern:  use "delay_off" and assume millisecond=
s.
    Consistency is good.

 2/ Do the "right" thing which is to use seconds.  "seconds" are the SI=20
    unit for time and we should always use them (says Linus - I could
    probably hunt up a reference if you were interested).
    so "0.2" is 200ms.  In that case don't use "delay_off" - probably
    "duration" would be good.
    This doesn't mean you need to use floating point.  See
    "safe_delay_show" and "safe_delay_store" in drivers/md/md.c

But that is just my opinion.


>=20
> > A couple of questions:
> >=20
> > i)  Why is it important for you to maintain the LED state?
> One use-case that would be easier for user to comprehend would be to
> have a constant timer that runs periodically. time value doesn't change
> and by simply writing 1 or 0, timer with a value specified by the time
> file can be started. The following use-case is a good example for what I
> am talking about:

I agree that "delay" and "activate" should be separate interfaces.

I wonder if we should allow control of the brightness during the "on" time =
as
well.
You could set the brightness after enabling the timer, but awkward pauses or
races could then leave the "led" permanently on.

Possibly we could hook into led_set_brightness() and restart the timer
whenever the brightness was set - and remember the setting.


So
  echo 100 > brightness

set the current brightness, sets the future brightness, starts the timer.
Or maybe if we have to hook into led_set_brightness anyway, then we could
cause "echo 100 > brightness" *not* to set the current brightness but just
to record a value for later usage...

But these are just minor things.  I think you are close to something useful.

NeilBrown


--Sig_/nNsEhl/JAU.MhpcP.ojCWQO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5S2ujnsnt1WYoG5AQKkthAAmwl81Ymk7LKT57pVTLKKn68vlvJoMBAK
CNPo34A42XPdFf90Z31pFTsT7/xe7JHNVw6hzm4S3MTT9BZ7mJgjVZkBL44aZH2m
OOrlOIcNlbyDAM/IEBNGbUwTN7PnTEK8kG+pVb2CTEwlpx86m81TKiIgO4X/R1z2
oxjDIg/U+m4FNFuXTyO16TKvfj28firweSEazO7qjmtDsiaJ6tA6pRP+PPyHAP23
3i4UMHIrQuPNcchh9XcUg8mQpUVTsDtw2laYMY2qNfZrYJis7dr2QzAFGFCCv7AM
Kyh6tchDp0N3pf72hS+D9Gzc+JvilpHHgpOa+ocT1P/T+f00GaYguspbw/8IQ+Vs
EETKPMSoDzbxmmrEwVg5IaFCMi1AAlKUxzEiYSIjtUV/nsuFofi/OGBfnm+wvAID
OKzJ41BWEGS+o1HQMljzH5CwjXDgISQ44n7jqypayL07ps2AZ9En3amVutw5GpPE
b6HlaWk78v4iO1VwIYZGY1f47IOfYBzvQwhouNxc8fX/XNZKvlP71dEn8KnTFTKE
zNn4Ijexfm46Frp8KI3HrboZUxsooe8IYuJ14l6Kffb4s7uxP5x1uIjO1ULCxVrH
iwSzIL8QU9wUQhOnud62nnuiwj6QNk88Cc2gq+bFvXrUOvL9Z/uMK94yAF7tFZZq
tSX31UbJq6E=
=1MHB
-----END PGP SIGNATURE-----

--Sig_/nNsEhl/JAU.MhpcP.ojCWQO--
