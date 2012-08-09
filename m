Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab2HIHvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 03:51:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57279 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab2HIHvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 03:51:33 -0400
Date: Thu, 9 Aug 2012 09:51:28 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>,
        David Henningsson <david.henningsson@canonical.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: hda/realtek - Keep analog bypass muted on ALC892
Message-ID: <20120809075128.GA24808@avionic-0098.mockup.avionic-design.de>
References: <1344494839-6942-1-git-send-email-thierry.reding@avionic-design.de>
 <s5hfw7wfszx.wl%tiwai@suse.de>
 <20120809071848.GB6979@avionic-0098.mockup.avionic-design.de>
 <s5hboikfrjc.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <s5hboikfrjc.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:srDzhFuQHq8UbbpgVaa8XnFVyxM95hj/XYu2LlGQgrY
 D7+CQP+eyNYkw/Y6/C9QczEHC8twlLUSoW9Uk5kXvLimND9bly
 UssL4AlwyVY02iPGkUR/yHM7KS+exjCYLgtCBa7eIAuf4xRRqk
 PE67zUYG8C8rKl+FtfSwo9uTS/5YbklwKF7z2olxvOG5I4AseL
 qS5TMtm1mg+L2HnCPBt0xmy5YzG9+y+vYWkmsRo1i5h0McvJ7J
 aU1EPKWJ14w7wnTUsCFx/qNxEjIgz+/LdcY8AH4Qwq49NGwNRw
 Jzova7XW7V2bxr932Ygm0+KG5eRr37ruH+HLyYCkp537ujr66t
 X+A5C/XXv3h90aUHJhFp9997eZrPl7ZZHAOPEsqmn/K7xXc2/1
 z2LQqg8Stx6CUDnxA3ARrEPi0L+k2gr1zQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 09, 2012 at 09:33:43AM +0200, Takashi Iwai wrote:
> At Thu, 9 Aug 2012 09:18:48 +0200,
> Thierry Reding wrote:
> >=20
> > On Thu, Aug 09, 2012 at 09:02:10AM +0200, Takashi Iwai wrote:
> > > At Thu,  9 Aug 2012 08:47:19 +0200,
> > > Thierry Reding wrote:
> > > >=20
> > > > Unmuting the analog bypass causes any input to be directly bypassed=
 to
> > > > the outputs, which is usually not expected by the user.
> > > >=20
> > > > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > > > ---
> > > > Note that this patch could be generalized to include all codec vari=
ants
> > > > that have this second channel. As I don't have access to all the da=
ta
> > > > sheets I'll leave that decision up to somebody with more hardware
> > > > available.
> > >=20
> > > Hmm, are you really sure that this is exclusive switch between two?
> > > All Realtek codecs with this mixer widget mixes two sources up.
> > > Otherwise it must not be a "mixer" widget at all but it must be a
> > > "selector" widget.
> >=20
> > It's not an exclusive switch. But the second input is the analog bypass
> > that basically takes the signal directly from the input path and routes
> > it to the output.
>=20
> Ah so you mean it as the analog loopback path.

Yes.

> > > And I haven't received a bug report regarding this although ALC892 is
> > > no new chip and the auto-parser has been enabled for so long time.
> >=20
> > I've seen this happen when feeding a signal into the CD-IN (NID 0x1c),
> > which is then directly routed to the output, so I actually hear that
> > signal at the output, even if there is no software loopback to capture
> > the input and play it back via the DAC.
> >=20
> > This is probably not a very common use-case, so maybe nobody else has
> > come across it. Looking at the block diagram in the ALC892 datasheet
> > (page 5) clearly shows where the input of this second switch comes from.
> > I don't think this is intended to be unmuted by default, but only in
> > very special cases where you actually want to pass the analog input
> > signal directly to the output without going through the ADC and back out
> > the DAC.
>=20
> Each input has the analog loopback mixer switch (and off as default).
> Why it doesn't suffice?

I hadn't thought about that. I'll need to recheck if that solves the
issue that I was seeing.

Thierry

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQI2wAAAoJEN0jrNd/PrOhhVgQAJK+zqS2HvMHS0LLuuvSGwOn
Pqjktc21vhDMZeufm7kJutnPiqtsWv8cD1b5sXqfZeCzUgXBvDAUnrMuI03jMcGh
PbrYLvan9cJdjgYwy3t8keY78rpbYFhXpLioI4p4L7PJh/sFyjU/1amOzD6mmpXJ
o6X9UcSDzci+e/3TX/cEwkBecFCNY3oMnzjcYXpz0xNNqPxCWuolq6e4ATyvGSDv
7Cb8f5tMcOfqgFmbLtf9te0jg325Yy8g3X2dVq9LI6EUARXiZh03kMzwDfkFMN9E
9FpC85QPJJTIEu/U18lWcn3NiIqREdUE0gA83q/4Tl/+4RTplIgI43VK4CC0zhN+
S325lFp4JkfQHZUpHiSPwuBcal2od157kx7TdH40uY3mTKIbDpotSdAb+pd6jcn/
tWBS2DwFAE94Ao44RR8VcRZ/U2KedKSn+cNXkoHKWnXdnvfFyAOLz2/0iZf8p7xA
v5+YK1M6/ei/kO+5V/eZQG1ThYXtiFpHm8+FK/bnryNUfsDEJYSfzyHgFT8hNtlk
nPOeULCn3bcHHqBO3kSAvuWVWi3yFdNAjU4UiZs+7wwFPatwActHKsUwyp9g18lV
HmsEhoJwWSmXjrHvXVrQEZ8IvwDKqdVTvMqQXJRw0lA+o6Ca6eB/UXa/yNyrD8Kg
RcvxveeOQsChbZb4AY1E
=KIGW
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
