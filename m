Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911Ab2J3P60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:58:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46032 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933862Ab2J3P6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:58:23 -0400
Date: Tue, 30 Oct 2012 15:58:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121030155821.GU4511@opensource.wolfsonmicro.com>
References: <4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
 <20121024185818.GB772@arwen.pp.htv.fi>
 <20121025205901.GA3827@sirena.org.uk>
 <20121026062008.GA21734@arwen.pp.htv.fi>
 <20121026160316.GY18814@opensource.wolfsonmicro.com>
 <20121029194901.GA30152@arwen.pp.htv.fi>
 <20121030112410.GM4511@opensource.wolfsonmicro.com>
 <20121030114949.GC28722@arwen.pp.htv.fi>
 <20121030140714.GO4511@opensource.wolfsonmicro.com>
 <20121030151642.GE29159@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3dBJfKlFjfsS/piO"
Content-Disposition: inline
In-Reply-To: <20121030151642.GE29159@arwen.pp.htv.fi>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3dBJfKlFjfsS/piO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 30, 2012 at 05:16:42PM +0200, Felipe Balbi wrote:
> On Tue, Oct 30, 2012 at 02:07:15PM +0000, Mark Brown wrote:

> > > and all of that SoC-specific detail is already hidden behind power
> > > domains, runtime PM, pinctrl, clk API, regulator framework, etc.

> > That's all getting rather open coded, especially if you're going to get
> > down to a situation where you have varying ordering constraints between
> > the different APIs on different SoCs.

> however we need to consider those cases right ? Otherwise we will endup
> pushing something to mainline which will have to be reverted couple
> weeks later after a big rant from Linus ;-)

I'm not sure there's much risk of that either way; if anything it seems
like it ought to be cleaner to have the stuff owned by the SoCs.

> > > and this is one of the issues we're all trying to solve today so we h=
ave
> > > single zImage approach for the ARM port.

> > I don't see the relevance of single zImage here; device tree is supposed
> > to solve that one.

> DT is part of the deal. DT alone will solve nothing.

If DT isn't relevant I'm not sure what you're saying about single
zImage?  The only relevance I can see for that is the data and
configuration bloating the kernel, something that DT is supposed to
address - this is the main use case where DT has benefits.

> > Well, nothing's going to stop that happening if people are determined
> > enough - one could equally see that there'll be flags getting passed to
> > control the ordering of calls if things are open coded.  I would expect
> > that with a power domain style approach any data would be being passed
> > directly and bypassing the driver completely.

> situations like that would be a lot more rare in open coded case, don't
> you think ? Also a lot more local, since they will show up on a driver
> source code which is used in a small set of use cases, instead of being
> part of the pm domain implementation for the entire platform.

I don't see how open coding helps prevent people doing silly things, it
seems like it'd have at most neutral impact (and of course it does
require going round all the drivers every time someone comes up with a
new idea for doing things which is a bit tedious).

> > Essentially all the patches I'm seeing adding pinctrl are totally
> > mindless, most of them are just doing the initial setup on boot and not
> > doing any active management at runtime at all.

> have you considered that might be just a first step ? I have mentioned
> this before. We first add the bare minimum and work on PM optimizations
> later. You can be sure most likely those mindless patches you're seeing
> are probably building blocks for upcoming patches adding sleep/idle
> modes.

The sleep/idle modes are just a basic extension of the same idea, I'd
not anticipate much difference there (and indeed anything where pinmux
power saving makes a meaningful impact will I suspect need to be using
runtime PM to allow SoC wide power savings anyway).

> > A big part of my point here is that it's not at all clear to me that it
> > is the driver which knows what's going on.  For SoC-specific IPs you can
> > be confident about how the SoC integration looks but for IPs that get
> > reused widely this becomes less true. =20

> I don't think so. As long as we keep the meaning of the 'default'
> pinctrl state to mean that this is the working state for the IP,
> underlying pinctrl-$arch implementation should know how to set muxing up
> properly, no ?

But then this comes round to the mindless code that ought to be factored
out :)  Only the more interesting cases that do something unusual really
register here.

--3dBJfKlFjfsS/piO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQj/kRAAoJELSic+t+oim9GPYP/imsXbaUv7NIjxeoK5+Iyg44
V0flqg9XnP5t9zH6/5LJjJg0oU8yqHbgLwTPoF6FnoweDGxgIofhxPIW7dtoLoUa
ESP3vb/lg2iGxXb5XN82MwqNnE8ertdTVy5YyBz4N4Sr8d/u1bixToGyQVDyGOzk
HYnB6tKuVMQznUjbc6o5P/qDHodaTPE+fbv1RwsPN4Ip/H/q2eG6m4/B8QaUSZR8
kmX7PmFF9LXyvKQp/HffoGiUVK6/gplFn6jJcnj4GiCEr10VhxOZPFC4M2nOFTZ6
aHwnTvHrNXO9Z+DsJMiB5DyJFzMajRJFCL6+fAY80mz4BOl5ZWOmllXfvq7dvEEh
Sn8JEmmY1KCPeRk6p0guxwHUnppGHHXOHxHBxIzYRTOyEW32e/APi9e/uAkB+iJ2
hVAcc8tNqLLeYBbzMuttJ7AJbkMO80Ef4d9QWHXl4bicMfFhvCqMRXufaX0BocoW
pckLO6UEpO+L1NlSTKCA26Fgpqj/t6W4T7U8d2VILbn0mMJvQK6cSoeChQscGB7g
6DUKOfDzuBYtNBRTm99sQTlB3f05T+4Iuk040WeotVneSCqvso1zZ6f1xLvaau89
RUys7DFasJpyUpSms4A71H/WJIHsgUYp43zU8bv+UIu3j2YJHh16jAo4KEJ3mxb0
xLkfLAcMLe7UwHhqvLcy
=xopv
-----END PGP SIGNATURE-----

--3dBJfKlFjfsS/piO--
