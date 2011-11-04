Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1KDTgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 15:36:05 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:41460 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab1KDTgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 15:36:03 -0400
Date: Fri, 4 Nov 2011 22:36:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg KH <gregkh@suse.de>, Xiaotian Feng <dfeng@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [050/107] block: check for proper length of iov entries earlier
 in blk_rq_map_user_iov()
Message-ID: <20111104193614.GJ4751@mwanda>
References: <20111102221600.GA26650@kroah.com>
 <20111102221454.703920975@clark.kroah.org>
 <1320420256.3079.172.camel@deadeye>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRtZRu2mMGBZ6YQ7"
Content-Disposition: inline
In-Reply-To: <1320420256.3079.172.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4EB43E88.0162,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRtZRu2mMGBZ6YQ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 04, 2011 at 03:24:16PM +0000, Ben Hutchings wrote:
> > --- a/block/blk-map.c
> > +++ b/block/blk-map.c
> > @@ -201,12 +201,13 @@ int blk_rq_map_user_iov(struct request_q
> >  	for (i =3D 0; i < iov_count; i++) {
> >  		unsigned long uaddr =3D (unsigned long)iov[i].iov_base;
> > =20
> > +		if (!iov[i].iov_len)
> > +			return -EINVAL;
> > +
> >  		if (uaddr & queue_dma_alignment(q)) {
> >  			unaligned =3D 1;
> >  			break;
>=20
> I think the correct fix is just to remove the 'break'.
>=20

Yeah.  I think you're right.  Are you going to send the patch?

regards,
dan carpenter


--wRtZRu2mMGBZ6YQ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOtD6tAAoJEOnZkXI/YHqRO+0QAJv+2InzXXP0c+DKrv1QT+FD
q8cZmfgkQ9qTGNrOnZo0Dhm9BCHdQEfWCswK+kjwFaYZem3xiMQ5M6b58qEXTu92
zBK5EYZuHoliBodxhIjwfRZ8TzY48QNgtaWrp7wuHPHsuyDuGaOKUsBfEkhx9jI1
V6ZewmbJo2YzFaM2BpJ/RB9wPtCVUBXWvIU7U/H7Hv5SLyept8tY2LF8f0FQ/7r4
Rm/U3J84+L/Md+ugQSWdJ7kTfZzdhaICyF25ohMtKFgnqNiW8rrg0l65snVrR4Fy
ZJ7vNZOKZ7nkcNICkSrsGIaGDvJUEI718d8xzg5A+mxR1w3uQaa1IS12WRPBspB5
mhFQTeHi2RkIhc4tyvnLYHxvHmckj2PL3foXNk58oUqFBcfsUQbAlnkMnt2Yiuam
du40xkx9C4p056/P7SET5iYt96WGN5S4VpaXfpvTpYNEVk+UYlJaYLRI9nQloG2I
N6pPqBJabDn+M8N57qX0P4caQ3jkzIAG6YZxqOe9Ca1DIVhiTtn9x3N9KGCyboRx
0Xa4eWuLVITI8MoU/AqKcAdJE1kZ3YmM1ByzDFBYDEFVeQ//2cBl6v2GZhZwl2Ig
tOVeJf3t7QTR2RwoajIiWiBGDUy6ezKY8us7/07/OhM4l+/VVFAKZoktWJ+PIl6s
9b/ofRCVpX8qJkZrM15R
=hC+w
-----END PGP SIGNATURE-----

--wRtZRu2mMGBZ6YQ7--
