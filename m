Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab2DJR6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 13:58:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42229 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754505Ab2DJR6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 13:58:50 -0400
Date: Tue, 10 Apr 2012 18:58:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
Message-ID: <20120410175846.GQ7499@opensource.wolfsonmicro.com>
References: <20120410131930.28186.85370.stgit@bob.linux.org.uk>
 <20120410131206.GB31551@sirena.org.uk>
 <20120410142501.6045c6c0@pyramind.ukuu.org.uk>
 <20120410133339.GK7499@opensource.wolfsonmicro.com>
 <20120410144235.1e05efd4@pyramind.ukuu.org.uk>
 <20120410140749.GL7499@opensource.wolfsonmicro.com>
 <20120410151529.5bcc5ce6@pyramind.ukuu.org.uk>
 <20120410151943.GM7499@opensource.wolfsonmicro.com>
 <20120410175632.5c11c36e@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sBcizk6cgRZY6rnJ"
Content-Disposition: inline
In-Reply-To: <20120410175632.5c11c36e@pyramind.ukuu.org.uk>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sBcizk6cgRZY6rnJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 10, 2012 at 05:56:32PM +0100, Alan Cox wrote:
> > > We can't go around blocking entire platforms because of the IIO blob. I
> > > raised this point with the whole previous *generation* of Intel SoC
> > > devices about IIO and nothing has been done about it.

> > Including by Intel, of course.

> Given the responses I got to moving it out of staging were of the "not
> yet" and "no" variety it hardly got a request to be worked upon.

The "not yet" bit of it certainly seems like something that could be
worked on, presumably "not yet" included a "we need to do X first"
element.

> > That's not where the rest of the embedded community has been coming from
> > on this stuff and from a deployment point of view staging isn't really
> > that big a blocker to users

> Non-staging code cannot depend upon staging code. That is the rule GregKH
> laid down. The Intel drivers involved are established non staging drivers
> and the gpadc layer is basically cleaning up the fact they all do this
> themselves in private right now without any central co-ordination or
> abstraction.

So, that's a bit different and not at all obvious from your e-mail - the
diffstat shows only the code you're adding, not the code you've factored
out of the existing mainline drivers.  The diffstat you posted was:

| arch/x86/include/asm/intel_mid_gpadc.h   |   13 +
| arch/x86/platform/mrst/Makefile          |    1
| arch/x86/platform/mrst/intel_mid_gpadc.c |  645 ++++++++++++++++++++++++++++++
| arch/x86/platform/mrst/mrst.c            |    6
| 4 files changed, 665 insertions(+), 0 deletions(-)

which is a pure addition of code and I'm not seeing anything in the
changelog about this either.

> > Frankly at this point I don't understand why we can't just lift IIO out
> > of staging as-is, perhaps with the userspace ABI nobbled or moved into
> > debugfs for the time being if that's still a concern.  Alternatively
> > there is the option of you proposing some other generic framework.

> I've been saying this for over a year. It's still a huge blob of code

I've CCed in Greg and Jonathan here - guys, what is happening with
getting IIO out of staging?  It's been there since 2009 and from an
outside point of view it's really difficult to see progress here, the
time taken to merge the subsystem seems really long.

To me it really feels like the subsystem is pretty mature at this point
and that if anything staging is blocking things rather than helping
them, the subsystem feels like it's getting normal development rather
than work to integrate it into the rest of the kernel and being in
staging is discouraging users who don't absolutely need to use it.

For example, when we get extcon (or whatever it ends up being called)
merged we'll either have to start writing a raft of auxadc specific
drivers for it or we'll have to come up with *some* kind of subsystem to
use to abstract out the standard DC measurement pattern.

If the code was moved out of staging today what would go wrong?

> that isn't needed for pure low level stuff, but that's fixable and
> something which can eventually be worked upon.

We do have to be careful about this sort of "this is a little bit of low
level code" thing - it (along with "our hardware is unique") comes up
rather a lot and it's often missing a good chunk of the picture.

> You are trying to make the tail wag the dog. Staging is basically out of

You keep saying "you" here.  To repeat once more, this is pretty much
what the general embedded community has been pushing towards, this is
not particularly my personal opinion.

> kernel. The x86 stuff is *in kernel*, this driver is the basis of
> cleaning it up. We can sort out making it talk to IIO later. Right now
> all you are doing is blocking a pile of much needed code cleanups, and
> without them you *won't* have an API for the gpadc on Intel, it'll be
> hardcoded in each driver still. That will mean you have *zero* change of
> getting IIO support at all.

Like I said above you'd not posted the patches which factor the code out
of the existing users, if that's what you're trying to do that's a bit
different to what your patch looked like.

> Whether gpadc then adopts an IIO interface is a question to ask later,
> after (if) IIO is ever merged. If the platform ever starts using gpadc
> for non internal hardware stuff then I'm pretty sure it'll end up adopting
> whatever generic GPADC layer eventually emerges simply because we'll want
> to share drivers.

Again, this is the sort of thing that SoC vendors routinely say but
don't end up doing quite so routinely as one would hope.  This is
understandable as this sort of thing is more of a problem for people
working in off-SoC devices and system integration than the SoC vendors
themselves.

--sBcizk6cgRZY6rnJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhHTQAAoJEBus8iNuMP3dkJYQAJ3N6v5PYNUEXMxCL7m/EK2e
QBMYP7me1sEibYa7xOmJSsuAxHdQW0+b/Z5sG3jit53Ou6BBRaTr/BR0DSFH0ogT
9aO7xtocnKL245eoExK0/y727SbTo3eBZ2nx/l0xeaJsJbv2/ev3kw66OmekM1Nj
maHeOlRK2VMotOje3AUUpbuhiNM0wmRWl/mGd6OZ1vB7XDGJuQ1VXLJNJJ+pXZEw
dHDvICINbw9YmxMmLUptY9Jw0iPt72Q18K7ZCJQMMwVmWVBfzOZ88QviKk6+WmoV
J8744tkYmlq9oeKOrEs0CygPZoFwILrOjFh4ZlevClGr3mQbbYUIk52WQrMcYnOL
Pdg2yRo3RsOp7maSz4ZEFZL7s+DsrJQZQCtcZ5F/6ZgjPhM1TlP15bFBhwiMOcrr
6s2O/GtlTDaIH7yaxpdXci074SmeO1taYCd6JxSLduK4ayEwmJ2CpoibfAIwbyFC
Dd3Rn0GUm6LFCjJmf7xUvb968ot7foQvINhPaA23Mvw99FoI8PhrbvZvIUy0a6E7
LKSqhVrOTLT3H4wLmVMEaGOAHdui5kVSJx6MBMs9zJI1KO12MkErJdRI3/ZDGOwE
JnozqyGnwKcMW+z8MS/g5RQovnOgIvCTN43vInas9URWJ9CRB18Nd/B4aMG0Fe0f
H0cWgbSK4PRpV3uGz3lM
=k3H4
-----END PGP SIGNATURE-----

--sBcizk6cgRZY6rnJ--
