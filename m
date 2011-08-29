Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab1H2NA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 09:00:28 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:54261 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750839Ab1H2NAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 09:00:19 -0400
Date: Mon, 29 Aug 2011 16:00:14 +0300
From: Felipe Balbi <balbi@ti.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>, clemens@ladisch.de
Subject: Re: [PATCH v2] sound: usb: mixer: increase control transfer timeout
Message-ID: <20110829130014.GB13925@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110829122320.GX13925@legolas.emea.dhcp.ti.com>
 <1314621110-19367-1-git-send-email-balbi@ti.com>
 <CABb+yY15qrszsbJSGGFra7mrVRO_oQPUhNT=U7TNpyoYikABPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lg8eXa+brxrbjAbR"
Content-Disposition: inline
In-Reply-To: <CABb+yY15qrszsbJSGGFra7mrVRO_oQPUhNT=U7TNpyoYikABPw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Lg8eXa+brxrbjAbR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Aug 29, 2011 at 06:07:30PM +0530, Jassi Brar wrote:
> On Mon, Aug 29, 2011 at 6:01 PM, Felipe Balbi <balbi@ti.com> wrote:
> > 100ms might not be enough for slower devices. Increasing
> > timeout to 1000ms doesn't seem like overkill.
> >
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >
> > Changes since v1:
> > =A0. Increase all 100ms timeout to 1000ms
> >
> > =A0sound/usb/mixer.c =A0 =A0 =A0 =A0| =A0 =A04 ++--
> > =A0sound/usb/mixer_quirks.c | =A0 10 +++++-----
> > =A02 files changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
> > index cdd19d7..1c9d443 100644
> > --- a/sound/usb/mixer.c
> > +++ b/sound/usb/mixer.c
> > @@ -296,7 +296,7 @@ static int get_ctl_value_v1(struct usb_mixer_elem_i=
nfo *cval, int request, int v
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (snd_usb_ctl_msg(chip->dev, usb_rcvct=
rlpipe(chip->dev, 0), request,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_IN,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
validx, snd_usb_ctrl_intf(chip) | (cval->id << 8),
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 b=
uf, val_len, 100) >=3D val_len) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 b=
uf, val_len, 1000) >=3D val_len) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*value_ret =3D convert_s=
igned_value(cval, snd_usb_combine_bytes(buf, val_len));
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0snd_usb_autosuspend(cval=
->mixer->chip);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> > @@ -445,7 +445,7 @@ int snd_usb_mixer_set_ctl_value(struct usb_mixer_el=
em_info *cval,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
usb_sndctrlpipe(chip->dev, 0), request,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_OUT,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
validx, snd_usb_ctrl_intf(chip) | (cval->id << 8),
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 b=
uf, val_len, 100) >=3D 0) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 b=
uf, val_len, 1000) >=3D 0) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0snd_usb_autosuspend(chip=
);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
> > index 3d0f487..7c41399 100644
> > --- a/sound/usb/mixer_quirks.c
> > +++ b/sound/usb/mixer_quirks.c
> > @@ -190,18 +190,18 @@ static int snd_audigy2nx_led_put(struct snd_kcont=
rol *kcontrol, struct snd_ctl_e
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D snd_usb_ctl_msg(mixer->chip->dev,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0usb_sndctrlp=
ipe(mixer->chip->dev, 0), 0x24,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0USB_DIR_OUT =
| USB_TYPE_VENDOR | USB_RECIP_OTHER,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !value, 0, NU=
LL, 0, 100);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !value, 0, NU=
LL, 0, 1000);
> > =A0 =A0 =A0 =A0/* USB X-Fi S51 Pro */
> > =A0 =A0 =A0 =A0if (mixer->chip->usb_id =3D=3D USB_ID(0x041e, 0x30df))
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D snd_usb_ctl_msg(mixer->chip->dev,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0usb_sndctrlp=
ipe(mixer->chip->dev, 0), 0x24,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0USB_DIR_OUT =
| USB_TYPE_VENDOR | USB_RECIP_OTHER,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !value, 0, NU=
LL, 0, 100);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !value, 0, NU=
LL, 0, 1000);
> > =A0 =A0 =A0 =A0else
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D snd_usb_ctl_msg(mixer->chip->dev,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0usb_sndctrlp=
ipe(mixer->chip->dev, 0), 0x24,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0USB_DIR_OUT =
| USB_TYPE_VENDOR | USB_RECIP_OTHER,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 value, index =
+ 2, NULL, 0, 100);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 value, index =
+ 2, NULL, 0, 1000);
> > =A0 =A0 =A0 =A0if (err < 0)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return err;
> > =A0 =A0 =A0 =A0mixer->audigy2nx_leds[index] =3D value;
> > @@ -299,7 +299,7 @@ static void snd_audigy2nx_proc_read(struct snd_info=
_entry *entry,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0usb_rcvctrlpipe(mixer->chip->dev, 0),
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0UAC_GET_MEM, USB_DIR_IN | USB_TYPE_CLASS |
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0USB_RECIP_INTERFACE, 0,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 jacks[i].unitid << 8, buf, 3, 100);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 jacks[i].unitid << 8, buf, 3, 1000);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err =3D=3D 3 && (buf[0] =3D=3D 3 || =
buf[0] =3D=3D 6))
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0snd_iprintf(buffer, "%02=
x %02x\n", buf[1], buf[2]);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> > @@ -332,7 +332,7 @@ static int snd_xonar_u1_switch_put(struct snd_kcont=
rol *kcontrol,
> > =A0 =A0 =A0 =A0err =3D snd_usb_ctl_msg(mixer->chip->dev,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0usb_sndctrlp=
ipe(mixer->chip->dev, 0), 0x08,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0USB_DIR_OUT =
| USB_TYPE_VENDOR | USB_RECIP_OTHER,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 50, 0, &new_s=
tatus, 1, 100);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 50, 0, &new_s=
tatus, 1, 1000);
>=20
> How about also converting to use a local define for timeout value ?

should it be part of another patch ? The current code has no defines at
all and $SUBJECT is just changing what's currently there to another
value.

--=20
balbi

--Lg8eXa+brxrbjAbR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOW41dAAoJEAv8Txj19kN1v5cH/21q9SBYXnXJQQxah0/jADpv
qyDvSMdnClHF23kXbKXAGlBvdk4B53Vwm/jszF8gHs6b7CKpVY/1mYoC4czEWvLQ
DzjOeYJSpUUL2dTw1CrXfw2tYjYMowJQVpQbFbTeMpktTlRJU8dKzavu9L0/dKDa
Lfdy8lLxMreDv9NGZCFk+Aj7Gj3X+bPZq2nugTCeulKuhTkAN1t0v471WRvYrxtR
54++YYaWHdLOVsI9SC0n0XlliO5WYZV6ctdTopt8b/42fj+jxI6tl2OWUhXifnBk
h//dZhIV/9uBYtQ6K7BiF5Lpqv/XmXa5F/50GD4yMoC36ednKQB6GmRsJtn1YSQ=
=JRQ+
-----END PGP SIGNATURE-----

--Lg8eXa+brxrbjAbR--
