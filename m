Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab2K2GmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:42:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61755 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab2K2GmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:42:06 -0500
Date: Thu, 29 Nov 2012 07:41:53 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rtc: Add NXP PCF8523 support
Message-ID: <20121129064153.GA28582@avionic-0098.adnet.avionic-design.de>
References: <1354130486-24693-1-git-send-email-thierry.reding@avionic-design.de>
 <20121128153158.ba24124e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20121128153158.ba24124e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:CCyVqHF661Xbn0nay3OL3+9DmXETN4d7UomUgnIQf8p
 xHvVqKXLobTLf1nQC2X//etn4A5lq4PwsBj0h039x6XU7Sv+bG
 s0Qa2G+tb6MNDicG4a9BfeJR0euZH68/opu3m7utK63iBZ9QoP
 7rqEtPmXxOAfGVuWKfFWe3V/5H97gwUmSwSvYOdqbWpAs9LJSs
 PpmpvEMutVynfUYLQ/82O4Q1MxaTYnfFF5pKZRPXDMCX6KZAcR
 qLraDB1EBI3Wbd7gfdyf28ONCoQGv8kNMzflv8amwBTWgygA9o
 iXx19BAFHtik85lyHCdQsqIx55y7fqL9tYSyVqraqg91QwUi8a
 9n2m3YMHsS79myR5RYwb2PvNoOwszbIypeueanHeeljF9+UssE
 4SSyK1S7IypLYSAqQDsdO6CoaxlvXmp4WYPLj38RleHBeH5M/h
 J5XX9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 28, 2012 at 03:31:58PM -0800, Andrew Morton wrote:
> On Wed, 28 Nov 2012 20:21:26 +0100
> Thierry Reding <thierry.reding@avionic-design.de> wrote:
>=20
> > +	err =3D i2c_transfer(client->adapter, &msg, 1);
> > +	if (err < 0) {
> > +		/*
> > +		 * If the time cannot be set, restart the RTC anyway. Note
> > +		 * that errors are ignored if the RTC cannot be started so
> > +		 * that we have a chance to propagate the original error.
> > +		 */
> > +		pcf8523_start_rtc(client);
> > +		return err;
> > +	}
> > +
> > +	return pcf8523_start_rtc(client);
>=20
> hm, well, that is of course equivalent to
>=20
> 	err =3D i2c_transfer(client->adapter, &msg, 1);
> 	pcf8523_start_rtc(client);
> 	return err;

At the risk of sounding pedantic, it isn't quite the same thing. There
is a possibility that i2c_transfer() succeeds but pcf8523_start_rtc()
still fails. So in fact we catch errors in i2c_transfer() and from
starting the RTC in case the time was properly set. The only error we
might loose if if the RTC fails to start after the time cannot be set
but in that case there's probably not a whole lot we can do.

> but I suppose the code as proposed is clear, extensible, and not our
> worst-ever sin ;)

Yes, this is one of the cases where the gain in clarity justifies the
extra verbosity. =3D)

Thierry

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQtwOxAAoJEN0jrNd/PrOhXtsP/10ExG9EIlXjSXzgf2kXdbDj
3mIYJ6TnNn+R4BaziT8b5HSigloau6WBSMgEsp4prlBXzYbKoDBT+7qAHYUZk3Rs
WINzoc+D5AAm8FBOr7pDE7sxvj7iX74NEYg2VJ3fVJIQASbL9nSWmbyzBH/im42Z
GCyNm63/BQNxMq33Z7FBYT7f8HHqYKS5DjJjfbJZLUoaBWWzUDOWgOrMObEypcbv
Msvc+5NQmPAlMzuneJoLhNtLxksQgz8MPSX11a3DEhGtJCmY9ZuWxhQ8X/1B6RmX
Cd7YbSPALBSBrC3XkuT2XLKhJJMyFGVw3nsF7pQjfPua3GcEr0sAIB4H2PY3/hZZ
mYhvXhsUBpWsKKCFpFC1wcAIWOHLpCGNws6R3yATN0FsT6+VjQ22GChQBgKUmYmS
WlX9B8SZ9VHeBDD7jNf6JUYzF6Wj1jGUTAZhN+HYmlIkwL/txkjH2Ra0FI6fZLgI
5LIUJWv8ilp0hlLjQtsBHyYeN68L3zI67yVp1TX+Gbz28jze3NAxJKYnmGNy/BKy
XvxqV5OYx0Tr0sRf6RUsrwERyGOsmrN7WQ12/ZxOqMsNlK1DgGeCBNGzMmoYKWli
zSFDswscquh3Cu2OKFJoc4+NE0uN3G9+qkt38xHFe2AZ+LDQnWzf9nAO4sHHfmvu
EbD/YaEumhqJ8UVNV49E
=0xW0
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
