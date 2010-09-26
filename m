Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab0IZPL6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 11:11:58 -0400
Received: from vps.mortis.eu ([79.99.135.181]:50542 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab0IZPL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 11:11:57 -0400
Date: Sun, 26 Sep 2010 17:11:55 +0200
From: Giel van Schijndel <me@mortis.eu>
To: Lutz Ballaschke <vegan.grindcore@googlemail.com>
Cc: Wim van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 0/3] watchdog: add f71862fg support
Message-ID: <20100926151155.GB7185@salidar.me.mortis.eu>
References: <20100926140629.GA2150@kreios.titan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Content-Disposition: inline
In-Reply-To: <20100926140629.GA2150@kreios.titan>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 26, 2010 at 04:06:29PM +0200, Lutz Ballaschke wrote:
> Furthermore i was thinking about modifying the WDIOC_GETTIMELEFT
> helper function since it simply returns the content of the WDT timer=20
> register without regarding whether the driver runs in minute-mode or not
> (thanks to Giel for pointing that out). This means if the driver is loade=
d=20
> with a timeout of >255 seconds (and switches to minute-mode) WDIOC_GETTIM=
ELEFT
> ioctl returns minutes instead of seconds and thus doesn't comply with=20
> watchdog-api (e.g. ioctl returns 6(min) not 360(sec)). It might be=20
> confusing if one loads the driver with a timeout of let's say 360 seconds=
=20
> and gets 6 minutes returned by ioctl. But imho it's not very accurate to
> return a value of seconds if the wdt doesn't count in seconds. That might
> be even more confusing. This inconsistency on the part of the hardware=20
> maybe can't get satisfyingly compensated by the driver. So i'd prefer the=
=20
> most simple solution.

IMO the worst option would be to just return minutes.  Returning
'minutes * 60 =3D seconds' would be significantly less bad.  So if these
are your options I'd suggest going with the lesser evil.

One other possible option could be returning '(minutes - 1) * 60 + 1'.
That way bad timing decisions based on the (wrong) assumption, that
there are still 60 seconds left until reset, can be averted.

I would however like Wim's opinion on this, as this affects the
Watchdog API's usage.

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel
--
"Good code is its own best documentation. As you're about to add a
 comment, ask yourself, 'How can I improve the code so that this comment
 isn't needed?' Improve the code and then document it to make it even
 clearer."
  -- Steve McConnell

--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyfYrsACgkQZBYm/87l50LZFQCgnMBoqeyXi+cjcQNN4KUJ7x5R
K4IAnjPeoC34piN21zWBFYw/WtNtehE3
=OvIT
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
