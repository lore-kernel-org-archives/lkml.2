Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab2BAJuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 04:50:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57371 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753913Ab2BAJuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 04:50:50 -0500
Date: Wed, 1 Feb 2012 09:50:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 07/07] ONKEY: OnKey module for DA9052/53 PMIC v1
Message-ID: <20120201095043.GB3150@opensource.wolfsonmicro.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED1FDDA3ED@KCHJEXMB02.kpit.com>
 <1328084935.19234.36.camel@dhruva>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <1328084935.19234.36.camel@dhruva>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 01, 2012 at 01:58:55PM +0530, Ashish Jangam wrote:
> On Wed, 2012-02-01 at 13:30 +0530, Ashish Jangam wrote:

> > > +	ret = da9052_reg_read(onkey->da9052, DA9052_EVENT_B_REG);
> > > +	if (ret < 0) {
> > > +		dev_err(onkey->da9052->dev,
> > > +			"da9052_onkey_report_event da9052_reg_read error %d\n",
> > > +			ret);
> > > +		ret = 1;
> > > +	} else {
> > > +		ret = ret & DA9052_EVENTB_ENONKEY;
> > > +		input_report_key(onkey->input, KEY_POWER, ret);
> > > +		input_sync(onkey->input);
> > > +	}

> > > +	if (ret)
> > > +		schedule_delayed_work(&onkey->work, msecs_to_jiffies(50));

> > Why not just schedule the work directly?  The use of ret took a bit of
> > thinking about to follow.

> schedule_dealyed_work simulates the release of the onkey button since event for release
> is not generated and ret & DA9052_EVENTB_ENONKEY is used to determine the release

That doesn't seem to address the concern.  You're setting ret in exactly
one place and scheduling the work in exactly one place, why are these
two things split?
> of the onkey button.
> > > +	error = request_threaded_irq(onkey->da9052->irq_base + onkey->irq, NULL,
> > > +				     da9052_onkey_irq,

> > This looks buggy, the resource should have the IRQ you need directly in
> > it.  The MFD core can do this for the chip core driver when it registers
> > children.

> As irq_base may get determined at runtime this will require modification to the
> defined resource struct for each mfd child in the device init function of the mfd core.
> Not sure if this is fine.

No, it really won't require that.  Please read what I wrote above: the
MFD core can do this for you.

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKQrGAAoJEBus8iNuMP3dX28QAI4y/6bVVq8zjYo/mUUuBMni
odqBelnm5gu6/7BRY33KOd0K0WmJmuJ2jm/NwdALhutfxeO1Oeova4Ffj9miiP5j
yuDeYqEq9HKDABm9mdJmRMR3xCkPIcpxzOmISslxYmbM+TDT34181ERYi2WxzZD1
FA24z297YsRuHI9fHQsXK5HGxsfp5rhBPQP6aC6/BoYsBUGx/tjw9qy6R2h6AwrJ
5LxbHGhiGfRhT8XTEmD6Ud9INmR6uo29XKkhsKfp3vZ1nH1XAepf3XK2SRQRdrnL
aqiv/HItjI8NyKXpEbeeL3WQS2AmAVz2H7GOX98CXcKjUQTxgrC5X2+dV6U9acwM
Owg3xKz2/s7+7CoQJTHT56AAntIpxfpOJGs4Ukxsn4fvZrCBPUKA+pG/wd9+k67F
Wu0TJVM+klS2VivcUusPSXc+IJTNDGzf2myUxSPgBOXcF2hQesf08olJ/cqUIEa9
CHx6kxp6kaWGS8AaYop6DbokAB/QkuyarI9BmNyfVPUcaTandSm2hgIuf6PwtnSE
eLtbVx/IAyR7JcjAaQZhAHha6wQCIeG+i3fUHLK8mvqQ/kHGODhzoSVG3LCwtPeQ
hIhgCqpU7h7+fh8GzzWBW0RO7wcEXYLMeqBAeCXLuqwW88cQGaj+BO+cfq4pROxs
xiUqc5ZByjPOEg1EsBTC
=tva1
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
