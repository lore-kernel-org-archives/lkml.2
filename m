Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1H2MXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 08:23:33 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:59478 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752455Ab1H2MXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 08:23:25 -0400
Date: Mon, 29 Aug 2011 15:23:21 +0300
From: Felipe Balbi <balbi@ti.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Felipe Balbi <balbi@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] sound: usb: mixer: increase control transfer timeout
Message-ID: <20110829122320.GX13925@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1314616226-15942-1-git-send-email-balbi@ti.com>
 <4E5B7EE7.6070103@ladisch.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1ar0NSVY9gjTGNA2"
Content-Disposition: inline
In-Reply-To: <4E5B7EE7.6070103@ladisch.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1ar0NSVY9gjTGNA2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Aug 29, 2011 at 01:58:31PM +0200, Clemens Ladisch wrote:
> Felipe Balbi wrote:
> > 100ms might not be enough for slower devices. Increasing
> > timeout to 1000ms doesn't seem like overkill.
> >=20
> > --- a/sound/usb/mixer.c
> > +++ b/sound/usb/mixer.c
> > @@ -296,7 +296,7 @@ static int get_ctl_value_v1(struct usb_mixer_elem_i=
nfo *cval, int request, int v
> >  		if (snd_usb_ctl_msg(chip->dev, usb_rcvctrlpipe(chip->dev, 0), reques=
t,
> >  				    USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_IN,
> >  				    validx, snd_usb_ctrl_intf(chip) | (cval->id << 8),
> > -				    buf, val_len, 100) >=3D val_len) {
> > +				    buf, val_len, 1000) >=3D val_len) {
>=20
> If the timeout for reading values needs to be increased, writing (in
> snd_usb_mixer_set_ctl_value) probably needs some attention too.

Ok, I'll increase all 100ms delays to 1000. Is that ok ?

--=20
balbi

--1ar0NSVY9gjTGNA2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOW4S4AAoJEAv8Txj19kN1KskIAJ9kmecPs9hb4koinHmNoB+X
adKJQU+1ZEGRICWRvbG7L/+TEv4RZJODDBH4nbwIgs+e4C9iK7SH/kkSmnV72Kun
C55PdktrDeJFKk7XaBPPGw++M+kzfrFcuW0fA+dcsKcLooBMEwKn9ngahbaX/bDS
W4oVTnf/rPGIQRMK3RyCIM6z3dS12mWUPoxYjeGfPaiuXVcf45qR2Rt3DQHd2rOh
ffepFWiUrKzm4el0hScPC+/5VWaHee46CXHPyGhrpKmXMrYPam/FQiCkaZj9qfrd
zOQc4rjuAf+QIp4wE2MN416hg5gWS/qvBxAGhU0aFmdRjca/yQxAgSLoReQbnok=
=5AmT
-----END PGP SIGNATURE-----

--1ar0NSVY9gjTGNA2--
