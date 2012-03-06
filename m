Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030449Ab2CFLww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 06:52:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34990 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030394Ab2CFLwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 06:52:50 -0500
Date: Tue, 6 Mar 2012 11:52:47 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH v3] sound/soc/lapis: add platform driver for ML7213
Message-ID: <20120306115246.GD19635@opensource.wolfsonmicro.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
 <1329976011-2251-2-git-send-email-tomoya.rohm@gmail.com>
 <20120302163915.GD6056@opensource.wolfsonmicro.com>
 <CANKRQni8hPoHEsV2VecbgKBdfS5+rit0-jXzz_d8F_nY5-dN3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0IvGJv3f9h+YhkrH"
Content-Disposition: inline
In-Reply-To: <CANKRQni8hPoHEsV2VecbgKBdfS5+rit0-jXzz_d8F_nY5-dN3g@mail.gmail.com>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0IvGJv3f9h+YhkrH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 06, 2012 at 02:48:05PM +0900, Tomoya MORINAGA wrote:
> 2012=E5=B9=B43=E6=9C=883=E6=97=A51:39 Mark Brown <broonie@opensource.wolf=
sonmicro.com>:

> > I just merged Lars-Peter's dmaengine library code which has been on the
> > list for a week or so - this should be updated to use that next time
> > it's posted.  That should save a lot of code from the driver and make
> > sure it's following best practices for dmaengine use.

> Sorry, we can't use this library.

This sort of response really isn't on.  Do you have some reason for
saying this?  Flat out refusing to do things with no reason is not
useful.

> >> +static struct ioh_i2s_data *i2s_data;
> >> +static struct ioh_i2s_dma dmadata[MAX_I2S_CH];

> > Why are these needed, aren't they dynamically allocated by the driver?

> You mean ASoC driver can't use global variable ?

In general no Linux driver should be using a global variable except for
things like this.

> >> +     case SNDRV_PCM_FORMAT_S32_LE:
> >> +             byte =3D 24;
> >> +             break;

> > That looks wrong...  are you sure you don't support S24_LE or something?

> This is correct.

> Because maximum transmit size of ML7213's I2S hw is 24bit.

Note we often lay out 24 bit audio in 32 bit blocks.

> >> +static struct platform_driver ioh_i2s_driver_plat =3D {
> >
> >> +static struct platform_driver ioh_dai_driver_plat =3D {
> >
> >> +static int ioh_i2s_pci_probe(struct pci_dev *pdev,
> >> +                          const struct pci_device_id *id)

> > Why are you creating these platform devices?  I don't understand the
> > function they serve.  The code handling them looks to have quite a few
> > problems but I'm not clear they should be there in the first place.

> if these platform devices aren't used, device detection doesn't work corr=
ectly.
> So, I added these.

You've not actually mentioned the problem you were seeing...

> >> +     rv =3D request_irq(pdev->irq, ioh_i2s_irq, IRQF_SHARED, "ml7213_=
ioh",
> >> +                      pdev);
> >> +     if (rv !=3D 0) {
> >> +             printk(KERN_ERR "Failed to allocate irq\n");
> >> +             goto out_irq;
> >> +     }

> > Are you *sure* you're ready to handle interrupts at this point?

> This is just registering interrupt handler.
> As long as interrupt register is not enabled, the interrupt handler is
> not called.
> This is common request_irq description.
> What's is your concern ?

Apart from anything else you've got the interrupt requested as
IRQF_SHARED so the interrupt could get called at any time.  It's also
not clear that you've got the hardware in a known good state.

--0IvGJv3f9h+YhkrH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPVfqBAAoJEBus8iNuMP3d8ZoP/RWLGgkvGTvC606+rtE3zHYZ
hkDHCs7tHFAMEcrm71lvgIaImEoTsHM/68zjGOtTGppVGHNuD6w+EX3R6Cm+XlkY
YL2WJRKvjth/GUoBUcFRQR2BCuIBMjzF61U4zdUlZhkGG85z3m5PzM3xeMDaWc7a
bu+ksVgVR4pI1disaP2iPKEIhUMzm+b3Twqrh1wgoJMEwGEmM9w1eDZbv171+lC9
4kaUT6zvGpfyA0IWBGKreBIVM56AOJOfaPa95qo5iwvd6vVxb2BoWuBh1AD94bvH
rhNvxmcEqebldnLR+xBd3LoxIy5sLzAmLxvpIAIO1+sbYomOJbQbJltr4EZ4fJt/
de9m6zToC+F4Crkp/0p6yXgeFCj2E1lc+OXddcOAVRtI8lrLfpNicr3yYd/dXPEm
i582J5NHAlqWEAx+ah+9lQ5v0D1mmuGJjPOgxYRFw2rsq6KPg+bbdlLXF1FJd9f0
EO8iVSQRh//eWVh2lbdysO77mfy5PoJUQoNglYsY6cDFKAcKqwjh62+djpkG4gv+
jNBFXOAsvUtHGcnGxi9TsERewePaG56UYXIyTHTiW+pTpG2tZvshhUxZETPAxqAs
Ma+6RcUl9GQ0NBTEZGUy6tO/K3FRpUBYBZleqP3aR7H6ClUYOufhYaemarnpDbaR
G6gO3kUfarFwHjyyEo8x
=l5Zf
-----END PGP SIGNATURE-----

--0IvGJv3f9h+YhkrH--
