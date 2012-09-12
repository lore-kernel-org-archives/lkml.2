Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab2ILLUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 07:20:19 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:40434 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab2ILLUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 07:20:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArADAIhvUFBbdWObgWdsb2JhbABFhgetJiKHcSIBARYmJ4IgAQEFI1YQCxgqAgJXBogkB6kJkyuLEIUwgRIDqGY
X-IronPort-AV: E=Sophos;i="4.80,409,1344204000"; 
   d="asc'?scan'208";a="1042431277"
Message-ID: <1347448877.4539.164.camel@fourier.local.igalia.com>
Subject: Re: [PATCH 03/20] Staging: ipack/bridges/tpci200: provide new
 callbacks to tpci200
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jens Taprogge <jens.taprogge@taprogge.org>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Date: Wed, 12 Sep 2012 13:21:17 +0200
In-Reply-To: <20120912111330.GD19396@mwanda>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
	 <1347267118-9580-3-git-send-email-siglesias@igalia.com>
	 <20120911084702.GM19396@mwanda>
	 <20120912092833.GA24558@endeavour.taprogge.org>
	 <20120912111330.GD19396@mwanda>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-M2Z0oYTvCeZTv2OO92IQ"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-M2Z0oYTvCeZTv2OO92IQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-09-12 at 14:13 +0300, Dan Carpenter wrote:
> On Wed, Sep 12, 2012 at 11:28:33AM +0200, Jens Taprogge wrote:
> > On Tue, Sep 11, 2012 at 11:47:02AM +0300, Dan Carpenter wrote:
> > > > +static int tpci200_get_clockrate(struct ipack_device *dev)
> > > > +{
> > > > +	struct tpci200_board *tpci200 =3D check_slot(dev);
> > > > +	__le16 __iomem *addr;
> > >=20
> > > The point of the underscores in the __le16 is that you don't want to
> > > pollute user space headers in glibc with a bunch of kernel typedefs.
> > > It is not needed here.  (Or if it is, then we would need to replace
> > > the u16 uses as well).
> >=20
> > I was under the impression that "__le16" is used to indicate the
> > byteorder of the pointed to memory.  As far as I can see that
> > information is lost when we use u16.  Am I missing something?
> >=20
>=20
> Use the no-underscore version unless it's inside a header which is
> exported to userspace.
>=20
> 	le16 __iomem *addr;
>=20

But it is not declared in linux/types, it is?

I have found only this typedef in a quick search:

http://lxr.linux.no/#linux+v3.5.3/fs/ntfs/types.h#L28

Should we define them in ipack.h header file or they are defined in
other place?

Best regards,

Sam

--=-M2Z0oYTvCeZTv2OO92IQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlBQcC0ACgkQWrfbyfmd9eJRiACfeeZ4d9dyTjE6FqrpvSCH4LxK
gMIAoJh8iA9Z7WQPPfZlc7vJihbbqBKG
=0jsj
-----END PGP SIGNATURE-----

--=-M2Z0oYTvCeZTv2OO92IQ--

