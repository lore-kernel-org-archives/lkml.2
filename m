Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab2HIKem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 06:34:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56012 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764Ab2HIKel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 06:34:41 -0400
Date: Thu, 9 Aug 2012 12:34:30 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>,
        David Henningsson <david.henningsson@canonical.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: hda - Defer probe when loading patch firmware
Message-ID: <20120809103430.GA1560@avionic-0098.mockup.avionic-design.de>
References: <1344494723-6827-1-git-send-email-thierry.reding@avionic-design.de>
 <s5hhascft86.wl%tiwai@suse.de>
 <20120809070813.GA6979@avionic-0098.mockup.avionic-design.de>
 <s5hd330frn1.wl%tiwai@suse.de>
 <20120809073642.GA24695@avionic-0098.mockup.avionic-design.de>
 <s5h7gt8fr47.wl%tiwai@suse.de>
 <20120809080713.GC24808@avionic-0098.mockup.avionic-design.de>
 <s5hzk64earo.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <s5hzk64earo.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:xkXZ+2XuSfaJ1cAl5WKMWoH5+rOIX8dmZlXvw5Rcty6
 nviBX26NU3G+HG70FlLhzWVjCgZn/0tSfPoCvJmy/46fPUdDui
 K0nSY6DhT6G+7R+Zja9rC+qVGtcNLasIxd3OuN7zqu/LuYkUJS
 y8rSOAJIRTQdRhL96qPfitovetejP+S5px7gW1X0ZZkM6BQAqR
 +HPJXJLB0OxG4liNm8gNomRsY6jkkC4mwZndqMynuAKU5Y8Z5E
 3wuFNpa06ZQ46ffSxOnWg4ztUUB4QBiLW00UIFIAfd4aRcBPH0
 rkauqwNTDJUTH9XKiN+kmF1Q2SR+dcXhFulywptPZ19H7bfHvt
 p7R1mXL9HWvsC+rIfeo0tae3CY0LYGSBXtqidd9OzOoCCqBH5V
 rhC+uG1Y9QTwJSbSHzkSwKYkf08PT2M3e4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 09, 2012 at 10:21:15AM +0200, Takashi Iwai wrote:
> At Thu, 9 Aug 2012 10:07:13 +0200,
> Thierry Reding wrote:
> >=20
> > On Thu, Aug 09, 2012 at 09:42:48AM +0200, Takashi Iwai wrote:
> > > At Thu, 9 Aug 2012 09:36:42 +0200,
> > > Thierry Reding wrote:
> > > >=20
> > > > On Thu, Aug 09, 2012 at 09:31:30AM +0200, Takashi Iwai wrote:
> > > > > At Thu, 9 Aug 2012 09:08:13 +0200,
> > > > > Thierry Reding wrote:
> > > > > >=20
> > > > > > On Thu, Aug 09, 2012 at 08:57:13AM +0200, Takashi Iwai wrote:
> > > > > > > At Thu,  9 Aug 2012 08:45:23 +0200,
> > > > > > > Thierry Reding wrote:
> > > > > > > >=20
> > > > > > > > Recent changes to the firmware loading helpers cause driver=
s to stall
> > > > > > > > when firmware is loaded during the module_init() call. The =
snd-hda-intel
> > > > > > > > module requests firmware if the patch=3D parameter is used =
to load a patch
> > > > > > > > file. This patch works around the problem by deferring the =
probe in such
> > > > > > > > cases, which will cause the module to load successfully and=
 the driver
> > > > > > > > binding to the device outside the module_init() call.
> > > > > > >=20
> > > > > > > Is the "recent" change meant 3.6 kernel, or in linux-next?
> > > > > > >=20
> > > > > > > In anyway, I don't understand why such a change was allowed. =
 Most
> > > > > > > drivers do call request_firmware() at the device probing time.
> > > > > > > If this really has to be resolved in the driver side, it must=
 be a bug
> > > > > > > in the firmware loader core code.
> > > > > >=20
> > > > > > A good explanation of the problem and subsequent discussion can=
 be found
> > > > > > here:
> > > > > >=20
> > > > > > 	http://article.gmane.org/gmane.linux.drivers.video-input-infra=
structure/49975
> > > > >=20
> > > > > Yeah, but it doesn't justify this ugly module option.
> > > > > It's a simple bug.  Papering over it with this option doesn't fix
> > > > > anything.
> > > >=20
> > > > It's not an option, all it does is defer probing if and only if the
> > > > patch parameter was specified to make sure the firmware load won't
> > > > stall. I realize that this may not be an optimal solution, but at l=
east
> > > > it fixes the problem with no fallout.
> > >=20
> > > Ah sorry, I misread the patch.
> > >=20
> > > Then it shouldn't be checked at that point.  Since 3.5 kernel, the
> > > probing code was already split for vga_switcheroo support.
> >=20
> > Yes, I saw that. But unless you actually use vga_switcheroo, the second
> > stage, azx_probe_continue(), will still be called from azx_probe() and
> > therefore ultimately from module_init().
>=20
> Yeah, but this could be easily delayed.  The split was already done,
> so the next step would be to return after the first half at probe,
> then call the second half later.
>=20
> > Before coming up with this patch I actually did play around a bit with
> > using the asynchronous firmware load functions but it turned out to be
> > rather difficult to do so I opted for the easy way. The biggest problem
> > I faced was that since patch loading needs to be done very early on, a
> > lot of the initialization would need to be done after .probe() and many
> > things could still fail, so cleaning up after errors would become
> > increasingly difficult.
>=20
> async probe is also on my TODO list, but it's deferred ;)
>=20
> > > The point you added is the second stage.
> >=20
> > I don't understand this sentence.
>=20
> I meant that your patch added the check at the second-half probing
> function (azx_probe_contine()).  That is, it could be already the
> point triggered by vga_switcheroo handler, not via module_init any
> longer.
>=20
> So, after rethinking what you suggested, I wrote a quick patch below.
> Could you check whether this works?

It oopses, though I can't quite tell where. I need to test some more
later to see where it goes wrong.

Thierry

>=20
>=20
> Takashi
>=20
> ---
> diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
> index c8aced1..4e5839a 100644
> --- a/sound/pci/hda/hda_intel.c
> +++ b/sound/pci/hda/hda_intel.c
> @@ -559,13 +559,17 @@ enum {
>   * VGA-switcher support
>   */
>  #ifdef SUPPORT_VGA_SWITCHEROO
> +#define use_vga_switcheroo(chip)	((chip)->use_vga_switcheroo)
> +#else
> +#define use_vga_switcheroo(chip)	0
> +#endif
> +
> +#if defined(SUPPORT_VGA_SWITCHEROO) || defined(CONFIG_SND_HDA_PATCH_LOAD=
ER)
>  #define DELAYED_INIT_MARK
>  #define DELAYED_INITDATA_MARK
> -#define use_vga_switcheroo(chip)	((chip)->use_vga_switcheroo)
>  #else
>  #define DELAYED_INIT_MARK	__devinit
>  #define DELAYED_INITDATA_MARK	__devinitdata
> -#define use_vga_switcheroo(chip)	0
>  #endif
> =20
>  static char *driver_short_names[] DELAYED_INITDATA_MARK =3D {
> @@ -3154,6 +3158,20 @@ static int __devinit azx_probe(struct pci_dev *pci,
>  	struct azx *chip;
>  	int err;
> =20
> +#ifdef CONFIG_SND_HDA_PATCH_LOADER
> +	/* delayed probe */
> +	card =3D pci_get_drvdata(pci);
> +	if (card) {
> +		struct azx *chip =3D card->private_data;
> +		if (chip->disabled)
> +			return 0; /* will be loaded via vga_switcheroo */
> +		err =3D azx_probe_continue(chip);
> +		if (err < 0)
> +			goto out_free;
> +		return 0;
> +	}
> +#endif
> +
>  	if (dev >=3D SNDRV_CARDS)
>  		return -ENODEV;
>  	if (!enable[dev]) {
> @@ -3175,19 +3193,28 @@ static int __devinit azx_probe(struct pci_dev *pc=
i,
>  		goto out_free;
>  	card->private_data =3D chip;
> =20
> +#ifndef CONFIG_SND_HDA_PATCH_LOADER
> +	/* continue probing if no patch loader is required */
>  	if (!chip->disabled) {
>  		err =3D azx_probe_continue(chip);
>  		if (err < 0)
>  			goto out_free;
>  	}
> +#endif
> =20
>  	pci_set_drvdata(pci, card);
> =20
>  	dev++;
> +
> +#ifdef CONFIG_SND_HDA_PATCH_LOADER
> +	return -EPROBE_DEFER; /* continue probing later for request_firmware() =
*/
> +#else
>  	return 0;
> +#endif
> =20
>  out_free:
>  	snd_card_free(card);
> +	pci_set_drvdata(pci, NULL);
>  	return err;
>  }
> =20
>=20
>=20

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQI5I2AAoJEN0jrNd/PrOhVy4QALgpZpYeCef+oqNu0RcVMHv3
bjj8ibtLwLDx81wmyTPnzK/BxbFPxJRW6m5zMFyVIkP/zAK0Q4/4lXvdKLu08M8O
zsTYi20xhyoCARj6NxFqZWjuFPSxlWW1amn67JiHkkb7R8VxgrH+gabUMOdNGT33
OtTPxDdS0loSTS9NHHW/J/hbAwxBU1A3LxrmsvOJKnOhOaAHXGmdHzMTZQ9PXsa1
2l9k7gSILyVUesecWTusIkVOvUfGMdsh8r5jTlO085Mw7OE22mYZmIs7coQf2Hd7
1YV4JsHSW0CGeiJTJU2NhcJfLwanzV9ZdiFO/JtqSlX1eDrjBYtHst9C1TVZbNiC
JsKYYxQOze4yjTaJ5ycxyuQNV+bRr0oE1FU//j8BMIbRwYt4LY9BHfUQzMc7QmWe
JNJTqXUJC5+5fiyifp9bWgfSoJLnma1mQ29xTyBXdnaMO8RptvyycgmDhoL6uJ3D
kXLYrfjd7QgaF2scyTpjdmtKgnqH6EgiIJzd8f8gygnehu8269Rq/dGDPqhbGfrr
db/M9PArvqb+33haW+PkChOp0gTtPKEg5JAA4wWZrlIUmr5tbplk/tJGrYJDfzxp
j1IR28bUHJaNkowZwd+LnZOiBdDNnH6dl4WQhv0l0CU+VMhLrSmHMVzaRAkOZscz
079YdHlawHQIKcZuII2x
=Eel5
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
