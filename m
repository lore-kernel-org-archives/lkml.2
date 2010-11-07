Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab0KGXmM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 18:42:12 -0500
Received: from mail3.sea5.speakeasy.net ([69.17.117.42]:32977 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab0KGXmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 18:42:11 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Nov 2010 18:42:11 EST
From: Frank Mori Hess <fmhess@speakeasy.net>
Reply-To: fmhess@users.sourceforge.net
To: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH] staging, comedi, das16: das16_attach() needs to free allocated resources on failure
Date: Sun, 7 Nov 2010 18:35:23 -0500
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Gustavo Silva <silvagustavo@users.sourceforge.net>,
        Tejun Heo <tj@kernel.org>, Arun Thomas <arun.thomas@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        "Chris R. Baugher" <baugher@enteract.com>,
        "David A. Schleef" <ds@schleef.org>
References: <alpine.LNX.2.00.1011072126150.26247@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1011072126150.26247@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart26313492.Ld3SFGdR5A";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201011071835.28692.fmhess@speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart26313492.Ld3SFGdR5A
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 07 November 2010, Jesper Juhl wrote:
> Hi,
>
> In drivers/staging/comedi/drivers/das16.c::das16_attach() there are many
> potential failure scenarios. However, the driver neglects to free
> resources it has allocated if failures happen.

This patch appears to be wrong.  The driver's detach function will be=20
called by the core if the attach function returns with an error.  The=20
resources are freed there.


--nextPart26313492.Ld3SFGdR5A
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBM1ze95vihyNWuA4URApZrAKCDv6kCMz/3p6uV0v5BQtES2pvPfQCglB6A
ioqOJqWivOP9G51KduUA0Oo=
=HapF
-----END PGP SIGNATURE-----

--nextPart26313492.Ld3SFGdR5A--
