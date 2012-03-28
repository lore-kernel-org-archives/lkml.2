Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab2C1Tdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 15:33:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42250 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757996Ab2C1Tdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 15:33:44 -0400
Date: Wed, 28 Mar 2012 20:33:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Michael Bohan <mbohan@codeaurora.org>
Cc: rnayak@ti.com, lrg@ti.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: Regulator supplies when using Device Tree
Message-ID: <20120328193341.GD3232@opensource.wolfsonmicro.com>
References: <4F6BCF47.4090200@codeaurora.org>
 <20120326130005.GQ3098@opensource.wolfsonmicro.com>
 <4F726B96.8070508@codeaurora.org>
 <20120328100957.GD3232@opensource.wolfsonmicro.com>
 <4F736451.8020900@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bc2iwAtkAaXP8cWF"
Content-Disposition: inline
In-Reply-To: <4F736451.8020900@codeaurora.org>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bc2iwAtkAaXP8cWF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 28, 2012 at 12:19:45PM -0700, Michael Bohan wrote:
> On 3/28/2012 3:09 AM, Mark Brown wrote:
> >On Tue, Mar 27, 2012 at 06:38:30PM -0700, Michael Bohan wrote:

> >Absolutely not, that would be broken.  The whole point here is that
> >supplies of all kinds are always requested with the name the chip uses
> >for the supply.

> Within the regulator driver, we currently have to do an
> of_get_property(of_node, "foo-supply", NULL) to determine whether
> the device has a supply, and thus whether we should assign
> rdesc->supply_name to "foo" or not when calling

No, this would be completely idiotic.  Please think about what I'm
saying here.  To repeat, supplies of all kinds are always requested with
the name the chip uses for the supply.  This means that any machine
binding is *totally* irrelevant to the regulator driver.

> regulator_register(). Is there a better way to do this? If we don't
> do this check for the case where a device does not have a supply
> specified in the Device Tree, then regulator_register() will fail.

Obviously there's a better way to do this.  For one thing as soon as we
find ourselves saying "let's open code this in every single driver"
we've got a clear abstraction problem...

--bc2iwAtkAaXP8cWF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPc2eHAAoJEBus8iNuMP3dctMP/0RBA76PD0krRCwaNjtwRvW7
2BJFI1iY/b0NAjh7bi3MdU8lNxaxCSeamKJvAR7furXUv2GL2uUgXSGncb/UWzzt
JvgAOhGfg/75hR9tKrOOiRj6Tf0E4tB/foS//56ggage4J0TGtruXWnUtnlZw67k
iUdbHZ9otzHcu0rLE48r1PBMvqPjxyKnV0LCBcO3GcIe1QochfXzw51y85MIMRrw
2+fpvNxEOfTZavPgVpfM3wO/6tf0YgoYvCjmDsHl5IKSgoE0hS+2gRlPfjVBkzlN
YjCSjSCwnfr+DR6eSCAjfBPRDSk2aQ54ifUxRNbT+Iwuzx1KVCbm1EWVlG7HbTTg
mc9f+KDOv0b18cUNNJMYHwEDwqeS4rHmBTdPOwasttjGtQ8ZDIZurrWp7ucscHsN
r1N7halsGQiI+n/HZaFAiCOXk2C0PvMF71UZOixj4AS4wvOGTJY5t5rX3JfqvFaJ
fV4Rp9R5yjsRtXNSNOu3GObFcsc+7YmPeP6+POqtMYP2UiKZLjyxuXIHXDLfSvUN
mdJm9UThxkOFj78gX7sW0B2OH3ohRWti9IyqXwHFEtSppPIDtJ09+dpo1le8zfyJ
gp+U/27fQdAdPiBZvgQMrcFgqewWgS60svYFcbqmCHRDTxinqn0oZL+H1KUcrIOi
z0NE5RVwhFzKTMCPgq6j
=GSlo
-----END PGP SIGNATURE-----

--bc2iwAtkAaXP8cWF--
