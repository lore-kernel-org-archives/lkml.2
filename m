Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab2KNIti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:49:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:49348 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab2KNItg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:49:36 -0500
Date: Wed, 14 Nov 2012 09:49:31 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: tegra: Add Tegra20 host1x support
Message-ID: <20121114084931.GA31837@avionic-0098.mockup.avionic-design.de>
References: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de>
 <1352467202-27903-2-git-send-email-thierry.reding@avionic-design.de>
 <50A357D3.9080002@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <50A357D3.9080002@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:pBBpFwZkMsNWo0l9Jzn41cIhkjmF1TuTyXRwq8WRqN2
 a1HdqQX7WrrzdHxD2K0Wa8Ljhm+Y+89Vuj96dc+3c1iPJVxTTr
 wioudmqRo8wW6kR4ZIQsriEFEq2W5PMcpBx+crAjcq6WBjtgSi
 1aqLCPmb+1kJVjGYW0vvrud2O4v6SqRJ2xMhdINfC6WlTiH8Rs
 J9+FR7zB4KI2IijzgbwwraXuhPJ2/KDnsbwd/h9MoBwh83CteM
 ymW6ozDg0L9maZMcbo7pL+ddnmpGNkWinIZNbg+gQlAFF38tH0
 KB+OxJ5hIawGmxMadRJ9he5wLWun9lf7Inm2yPv+YR90JyKm9s
 vyovewuAtG2LS8/YXAnCWbJMhhagl5ZqYmbB7xYPkYouZw8i6B
 gndF/kmi5P4hoVet4cgDf21pQ2GoKBmw6Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 14, 2012 at 10:35:31AM +0200, Terje Bergstr=C3=B6m wrote:
> On 09.11.2012 15:20, Thierry Reding wrote:
> > This commit adds the host1x node along with its children to the Tegra20
> > DTSI. Furthermore the OF auxiliary data table is updated to have proper
> > names assigned to the platform devices instantiated from the device
> > tree. Moreover, the clocks required by host1x and the two display
> > controllers are initialized and the pll_d frequency table is completed
> > with a few entries to support common HDMI and LVDS display modes.
>=20
> I tried to add nvhost on top of your patches and I noticed a glitch.
>=20
> > +       { "host1x",     "pll_c",        144000000,      false },
>=20
> This line causes host1x not to operate correctly. I don't know why this
> is so, but when I try to initialize host1x, it hangs with this change,
> but everything works without this line.

Can you find out how the host1x clock is setup without this change? I
was told that freezes can occur when you try to access the registers
without the host1x clock being enabled. However, the host1x driver
should take care to properly setup the clock.

To find out if the non-running clock is the issue, can you try to patch
that line and make the final element true instead of false? That should
enable the clock on boot so that it should always be running.

Thierry

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQo1sbAAoJEN0jrNd/PrOhBEMP/R+ZfOpS19VL8zFHO8eIePZZ
bhNjifAOKbZJFY5UKBk85fxbGRKmzwafdUvEnyQSF1nXH+B4CdrVXKbIFZRbfqVb
MD0RNHpZR+8ntkVPxJ7UCA3+8wGL2B2UpXoZyAtsCGtwCxRfjClaHVR5kqgDEVBf
zZAV1aEI13G1pFVBYyLgmlbQUP93aI0mrTCVtA1myEheTDY1FicrHObS16eDuI/i
fuV0+lIH3dA9BszDDwIhcmonR3SwMlOPgiCYhWo0r0F1iRATuXZjSUp3eC2YY6br
3kOp9GhmIK4U9tPQnP5azBpn5etLAaMpqJx5LO7yNlkoD+l1NS5QYZEn1o1eHFLL
6H3lgE5HrB0Hq5P+OEnh232fcb6zUq0DCMdwOYIXJnc1SK+ggSJBEf0VU+34Ulxf
VMiCnYmoA/MAWSUWqoam+s4+xjBMVz8ug/O0HgYAco6SuBTCaqXtsADsg1qMorcg
6AADeRD7xLSdxbX9mkrBH/6lh9n92r24+FR1BbW1l5yHGcrr3rYvToNcHtaTno1v
GreKHaEYGTqv4mDOPIpCmKWurHKQFuonlGopr7Idzh/hjMApsdmzSP+WxQSdpB0B
gvfdT8abtSzhnQQHS97pFv8BBvlunq6KAns9OcHs2qBwc+pgdj/NI54VAeHxKlXe
3rBjb0kofbokf9pNB4xX
=8jic
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
