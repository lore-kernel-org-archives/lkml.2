Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab2DBVWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:22:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37705 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752097Ab2DBVWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:22:37 -0400
Date: Mon, 2 Apr 2012 22:22:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Michael Bohan <mbohan@codeaurora.org>
Cc: rnayak@ti.com, lrg@ti.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: Regulator supplies when using Device Tree
Message-ID: <20120402212232.GA3160@opensource.wolfsonmicro.com>
References: <20120326130005.GQ3098@opensource.wolfsonmicro.com>
 <4F726B96.8070508@codeaurora.org>
 <20120328100957.GD3232@opensource.wolfsonmicro.com>
 <4F736451.8020900@codeaurora.org>
 <20120328193341.GD3232@opensource.wolfsonmicro.com>
 <4F73A798.6030607@codeaurora.org>
 <20120329111159.GJ3668@opensource.wolfsonmicro.com>
 <4F7509F4.6010303@codeaurora.org>
 <20120330103602.GE21950@opensource.wolfsonmicro.com>
 <4F79E35A.5040908@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <4F79E35A.5040908@codeaurora.org>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 02, 2012 at 10:35:22AM -0700, Michael Bohan wrote:
> On 3/30/2012 3:36 AM, Mark Brown wrote:

> >The support for regulator-regulator supplies has always been problematic
> >and infrequently used -

> Hmm, I'd be interested to know the history there.

git logs should be instructive.  The use part is just because most board
designs end up thinking of better things to do with their DCDCs than
drop the supply for LDOs.

> >Please be more specific about what you're actually trying to physically
> >accomplish here.  It would be *extremely* unusual to see a regulator

> Some of our regulators take inputs from other regulators. Some
> regulators take their input from the battery. We support both types

Oh, if that's all it is that's totally normal and unsurprising.  Just
tell the regulator API about the battery supply, typically people use
a fixed regulator for this.  You don't have to specify a voltage when
you use them.

> I don't disagree that the new scheme makes supplies more like normal
> supplies. I'm just pointing out the solution doesn't appear perfect
> since extraneous code is put in the driver in this case.

To repeat yet again if you're putting code for this in the driver you've
got a clear abstraction failure.

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPehiSAAoJEBus8iNuMP3dWysP/0/OTN7/ruQ8jYPCkT1z50kM
jTqdiT1k5b12EbuJnxRamIsbdEeAg8+v2B21CQfcry/1e7KXb9ayJuvSX3o46zOe
xMqY+eD6bbvK2+xQUjhm5q5eHRbv1hzuvPLzx3B3MQU+peSp66ncd7a/gvmuIE/Z
NUvan0uNvwNJbTl4nH0fluIwoWlO6nbH92iYpw8TRxEAqiiocdTaVtaXPoUx/TxW
B4ZLRKiKOjmTudvESCrh5FnSyk3Uy3WkEXiqZX5iy3s1R7kqLs9NDggatNwxZuG8
ksID9p+fSs+Jn8RqoQqS3ve261V+w6XTKJlgB3WtbtAjPnBnE44PGgmU5cuFxW7L
QhmuSs54EEa58O4XA+LvH8D8DraeUzAXgAacu2sh9UQEM27OzDvnF4fra2buvze5
7SFJGvrvHWWhIc/lUjLieebW3HFTItLUVgYh9bK4L1mdWsgYQfFM/IpNrhfuJuXW
khBQ6HtC85S2D7gxYao+TDkQbBhzB0kMrCcNPDHiV9ASDTzxMq51Iilk4rD5wpJh
DzB06DMi289FJhSJjLl/JUh+7s5j0z+l7sndIVReWQloJRtFFWFUT3U78SwhB0/9
9LYNV1G3XQ3GPRB53SZQcW0QRfeVUdB8BADWd88th4o/jy/Mrb3ec1XRtpmom7N0
5Gdlbie11QkGPC0cDWXg
=UXui
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
