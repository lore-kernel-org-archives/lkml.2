Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab2BQHZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 02:25:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47315 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750800Ab2BQHZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 02:25:50 -0500
Date: Thu, 16 Feb 2012 23:25:43 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] regulator: add set_pulldown in regulator operations
Message-ID: <20120217072542.GC11464@opensource.wolfsonmicro.com>
References: <B567DBAB974C0544994013492B949F8E381301284E@EXMAIL03.scwf.nsc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iFRdW5/EC4oqxDHL"
Content-Disposition: inline
In-Reply-To: <B567DBAB974C0544994013492B949F8E381301284E@EXMAIL03.scwf.nsc.com>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iFRdW5/EC4oqxDHL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 16, 2012 at 10:41:45PM -0800, Kim, Milo wrote:
> Some PMUs provide programmable active shutdown switches
> that help discharge the load if the supply is off.
> For providing this feature, set_pulldown() is added in the ops.

> The set_pulldown() is not exported function.
> This function is called internally when the regulator is disabled.
> Then pull-down bits can be programmed in each regulator driver.

There's several problems here.  One is that "pulldown" is a really
confusing name as a pulldown is usually a feature of open drain logic.
"Discharge" would be a better term.

> +			if (rdev->desc->ops->set_pulldown) {
> +				ret = rdev->desc->ops->set_pulldown(rdev);
> +				if (ret < 0) {
> +					rdev_err(rdev,
> +						"failed to set pulldown\n");
> +					return ret;
> +				}

Another is that since the operation is defined not to take any arguments
there's no need to have an operation - the driver may as well just
enable the discharge unconditionally at system startup as it can never
be disabled.  For a lot of hardware this is all that's needed anyway as
the device is smart enough to remove the discharge when the regulator is
enabled.

It's also not altogether clear that actively discharging regulators is
a good default - often it'll increase leakage current a tiny amount and
nothing really cares that much about how quickly the voltage collapses.

--iFRdW5/EC4oqxDHL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPPgDwAAoJEBus8iNuMP3dnRQP/2AYnXxBxssyzqcRIKTdqnRK
Nw+nw1vVPyjqx7Wg4KWa1tHaG4dvLL1gRj2lBJXQihS187lg3o4vgWU1Sne03Wza
1py7SWdnziiUyFU1ED4yUHAsufcG1GV3/COCEhFgBZ5budLG03W1ViisVGWP1K9J
EwJ4g36ZoWjsylKwKbvpxN9gFu3ErUXF2FfPA6lgiiZnWxV1ZWJP4xAgLXQMiNoS
XBezupqqX0U8+u9xHA+++EaKykwBPjmjGyU5XPL0XaVWNnnSsk2jji1ZR1hM84S+
j4YSMjBt0XeAoySLJWha8wLZJWQDhr01LRkQrgM+MwW5IwY/oeIlVLQIkKgNduHw
mJoyjSdpVH3opFZu4StQnfphb4VY9DYRIuIhNO24Mgeuv+aXNG8BxVfNXR79FqaI
8FjsIhG4BD8dOvDv+jSxpKLWs/UAwJp4D0Fve8/7/1T11cbq5J8gUPDhg6wYIEc0
BQtN5LGzo8vJg52FAA1GIk6gbahEgBBil/k5pqy7j8fIrk3msFX+lOxWvxl3KZES
OVCSArbhR/5Qnl2VzJ8dPdp/siuhQGRyOONKxZ6+snix+QzJyM1RtjT4mduqEUSD
ORj7U6vJtLrtEgjvSvr5/JXvJRS0Yvgv+0WGkpXIx3DUBi2sm2gq/hp+eElKHXEG
EDUaCs3VdIcmhWhdZ6Ns
=Mv1r
-----END PGP SIGNATURE-----

--iFRdW5/EC4oqxDHL--
