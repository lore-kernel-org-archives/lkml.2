Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974Ab1LPBiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 20:38:54 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:32906 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753413Ab1LPBix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 20:38:53 -0500
Date: Fri, 16 Dec 2011 03:38:47 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, stable@vger.kernel.org,
        Hema Kalliguddi <hemahk@ti.com>
Subject: Re: [PATCH] usb: musb: fix pm_runtime mismatch
Message-ID: <20111216013846.GB2344@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1323988934-11350-1-git-send-email-felipe.contreras@gmail.com>
 <20111215230143.GA2090@legolas.emea.dhcp.ti.com>
 <CAMP44s1JMwF95nOgZLvdL7ke6fYz-ar5SDv=Lu-5QJ==0bkH=Q@mail.gmail.com>
 <20111215235017.GA2242@legolas.emea.dhcp.ti.com>
 <CAMP44s1GCPRjV4weNN1GpboDPbzUobBLVP+u2Y4QvHrt2KoG_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Content-Disposition: inline
In-Reply-To: <CAMP44s1GCPRjV4weNN1GpboDPbzUobBLVP+u2Y4QvHrt2KoG_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Dec 16, 2011 at 03:13:13AM +0200, Felipe Contreras wrote:
> On Fri, Dec 16, 2011 at 1:50 AM, Felipe Balbi <balbi@ti.com> wrote:
> > On Fri, Dec 16, 2011 at 01:31:02AM +0200, Felipe Contreras wrote:
> >> On Fri, Dec 16, 2011 at 1:01 AM, Felipe Balbi <balbi@ti.com> wrote:
> >> > On Fri, Dec 16, 2011 at 12:42:14AM +0200, Felipe Contreras wrote:
> >> >> --- a/drivers/usb/musb/musb_core.c
> >> >> +++ b/drivers/usb/musb/musb_core.c
> >> >> @@ -2012,8 +2012,6 @@ musb_init_controller(struct device *dev, int =
nIrq, void __iomem *ctrl)
> >> >> =A0 =A0 =A0 if (status < 0)
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail3;
> >> >>
> >> >> - =A0 =A0 pm_runtime_put(musb->controller);
> >> >
> >> > To me the real fix would be add the missing pm_runtime_get_sync(). On
> >> > probe() we're actually accessing MUSB's address space which needs it=
's
> >> > clocks turned on. I guess it's only working now by chance, probably
> >> > because glue layer calls pm_runtime_get_sync() to access it's own
> >> > address space and that uses the same clocks.
> >>
> >> Are you sure it's "musb-hdrc", and not "musb-omap2430" the one
> >> accessing the relevant address-space? From the runtime_pm
> >> documentation it looks like only the probe function should deal with
> >> this.
> >>
> >> If "musb-hdrc" was truly accessing these registers, then I would get
> >> the same failure because the clocks are turned off, but I don't...
> >
> > see musb_core_init(); You don't see any problems when accessing those
> > addresses because musb_platform_init() will fall into
> > omap2430_musb_init() which calls pm_runtime_get_sync(), and the same
> > clock actually enables both address spaces (musb-omap2430 and
> > musb-hdrc).
>=20
> That's true, but how would I go test this theory? Call
> pm_runtime_put_sync() at the end of omap2430_musb_init()?

sounds like a plan... Not sure if it will work always though. If I
remember correctly, pm_runtime_put_sync() will only be synchronous to
the current device, but will go up the parent tree asynchronously. Which
means that dev->parent will be see a scheduled runtime_put

> Also, I think most pm_runtime_disable() calls shouldn't be there...
> That would tell PM to activate power for the device, which is not what
> we want. The core drivers code will take care of truly disabling the
> pm_runtime stuff _without_ activating the device.

true, sounds correct.

--=20
balbi

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO6qElAAoJEIaOsuA1yqRE+yMQAKD4aHsBi91ijs7cKBpzEOsp
70z1dJEEsMl1A2W3bDlisCAvKgS18XTawaxKKN+53MEg0flIC4yTN5qw2EkLdAkS
a4EmNY8ifKvtwet0Pcb/n/252EAMUpxNSe0+KcFCvwN1UX/DO7QU1f2k9MtSaCZs
C9tXqKSIgX6qJC9Nrxuw2dOM0Qk/nQElzTymE6HCJsa1vmCXQAFDFXMA7CclH6eQ
uFHkO24zhTQInVKgAKiBLnhCoH4p47kaf070PADlnZ9MWmWf8PcKxtuSYt7Bov9j
um3MirHrClmWewyPwR4yz0BJw1THSvJv5WkniGTJ4fd20jNWuwfHl4VJwxXdKsGy
yQIMUtm6io7Pkg81ClRLQhE9zheFbP6EY72XWLcuzxsffEOFkvsoIel/MpvoWYe2
tEZvATh0TN9u4NALN6Jpd79bbPgcNy+1+0KtZ3ZnA70dW1mqtEPZYCRV69F3vggD
ogf/8cRbkX79L137/q7Jt40DH/tI4MP+YYzy8She6+/xTwKXnQuuJfD4ht+/LM/a
JHBL2LWVj+gBCSckmuTZrun6fb1oQ349/kbRVJyHWfAYtEaUGWs8go3LrHgciodB
EK1p9YnTQxCXqS6eZ/m0lO1ka/S0yXE+Qz6RdOD/XB3J80Uy+TvQp9rg+5u+xgsA
UYCx7frmc/fIZVPEZJ1y
=RVGR
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--
