Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab2KVS3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:29:18 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49948 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab2KVS3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:29:14 -0500
Date: Thu, 22 Nov 2012 14:22:23 +0200
From: Felipe Balbi <balbi@ti.com>
To: walter harms <wharms@bfs.de>
CC: Cyril Roelandt <tipecaml@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>, <laurent.pinchart@ideasonboard.com>,
        <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] UVC: use GFP_ATOMIC under spin lock.
Message-ID: <20121122122223.GC18022@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1353360842-18384-1-git-send-email-tipecaml@gmail.com>
 <50ADDDD5.1080709@bfs.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u65IjBhB3TIa72Vp"
Content-Disposition: inline
In-Reply-To: <50ADDDD5.1080709@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--u65IjBhB3TIa72Vp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 22, 2012 at 09:09:57AM +0100, walter harms wrote:
>=20
>=20
> Am 19.11.2012 22:34, schrieb Cyril Roelandt:
> > Found using the following semantic patch:
> > <spml>
> > @@
> > @@
> > spin_lock_irqsave(...);
> > ... when !=3D spin_unlock_irqrestore(...);
> > * GFP_KERNEL
> > </spml>
> >=20
> > Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
> > ---
> >  drivers/usb/gadget/uvc_video.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/usb/gadget/uvc_video.c b/drivers/usb/gadget/uvc_vi=
deo.c
> > index b0e53a8..79b4132 100644
> > --- a/drivers/usb/gadget/uvc_video.c
> > +++ b/drivers/usb/gadget/uvc_video.c
> > @@ -309,7 +309,7 @@ uvc_video_pump(struct uvc_video *video)
> >  		video->encode(req, video, buf);
> > =20
> >  		/* Queue the USB request */
> > -		if ((ret =3D usb_ep_queue(video->ep, req, GFP_KERNEL)) < 0) {
> > +		if ((ret =3D usb_ep_queue(video->ep, req, GFP_ATOMIC)) < 0) {
> >  			printk(KERN_INFO "Failed to queue request (%d)\n", ret);
> >  			usb_ep_set_halt(video->ep);
> >  			spin_unlock_irqrestore(&video->queue.irqlock, flags);
>=20
>=20
> IMHO, this should be two lines, aka:
>=20
> ret =3D usb_ep_queue(video->ep, req, GFP_KERNEL);
> if (ret<0)

correct, please resend with the fix.

--=20
balbi

--u65IjBhB3TIa72Vp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQrhj+AAoJEIaOsuA1yqREOfMQAKbctsaWRc3L+esWickU5pUe
lZPq73+gW1FYH2+oMd67/s260DO+gM1Z/HmKgOhdK+oDvqQ5v+PYSwCKKsksOPHw
2cmksQxSD5fCnmlXmx/JzbPoaSGpODCmGVuq2gUj7uyEf/KYsiKuBLK9hWLbMG0T
kOSktHfrYul2UeYaBvaQLGGl/20r2AgdoSLr1ljmtWKNFpvup5TNQWpxB6yq4ZlM
CX06iDwecU3uw6QDWBUZ5Ss+DDJQB4GgrMdM/ecOT+Bq7haXISdggulex+s2vYWy
ozkUj922KIfmddR9W0WxWxWo3MiGBsssVX2Taoasq/Sj2jUpujazOYkuBgqL6agl
EP5QFb5jT0l1Iu3lT2XoMF8XbA2smKQ4Z1dejOJ96AbIfgh5rB27Wes2QIzLIEwv
0mj7DXTYzuYV84fol6qMxUgsXwKzk609SLljMQwSmY5Y3q81TRlBUXj4FNzrCRHf
iD2jMoA2t/Cz7Z51IxYE6Ep/OtIbAtxwPM4aHYM5MZIzTnhS2osKxC6MKCSOQRX+
qYfKM+vZumzAps3F9THNHtpBKV02+4UpV9L/8JfXFZZ21UexW/Ej/b9kg1mbKa2W
669BJ6PjcI7bbauCTLKRnvghM4LFaHB90OyHu6vo2Uu+HY18QWjhnSCGWxw/qrVI
tJ5+i5H0XYFuk3f1jfxE
=gce8
-----END PGP SIGNATURE-----

--u65IjBhB3TIa72Vp--
