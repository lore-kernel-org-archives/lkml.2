Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494Ab2DJSez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 14:34:55 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:51573 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754587Ab2DJSey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 14:34:54 -0400
Date: Tue, 10 Apr 2012 11:34:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Jiri Slaby <jirislaby@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        daniel@ffwll.ch
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
Message-ID: <20120410113448.540e4c1d@jbarnes-desktop>
In-Reply-To: <4F8477D1.4080102@suse.cz>
References: <4F717CE3.4040206@suse.cz>
	<4F717D80.9040207@suse.cz>
	<4F758400.3080907@suse.cz>
	<1333104359_155028@CP5-2952>
	<20120409101119.47e770b2@jbarnes-desktop>
	<4F83F3B5.8080704@suse.cz>
	<20120410092619.26a15165@jbarnes-desktop>
	<4F8477D1.4080102@suse.cz>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5DLX5Z3eBl3nWW4TdUBRjVk"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5DLX5Z3eBl3nWW4TdUBRjVk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Apr 2012 20:11:29 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> On 04/10/2012 06:26 PM, Jesse Barnes wrote:
> > So port hotplug is always reporting that port C has a hotplug
> > interrupt though...  If you write 0x3 back to it does the interrupt
> > stop?
>=20
> I'm not sure I got it right. This doesn't help:
> --- a/drivers/gpu/drm/i915/i915_irq.c
> +++ b/drivers/gpu/drm/i915/i915_irq.c
> @@ -1416,6 +1416,17 @@ static irqreturn_t
> i915_driver_irq_handler(DRM_IRQ_ARGS)
>                 iir =3D new_iir;
>         }
>=20
> +       if (ret =3D=3D IRQ_NONE) {
> +               u32 hp =3D I915_READ(PORT_HOTPLUG_STAT);
> +               if (hp) {
> +                       I915_WRITE(PORT_HOTPLUG_STAT, hp);
> +                       I915_READ(PORT_HOTPLUG_STAT);
> +               }
> +
> +               if (printk_ratelimit())
> +                       printk(KERN_DEBUG "%s: %.8x\n", __func__, hp);
> +
> +       }
>=20
>         return ret;
>  }

Yeah that looks right, you still get 0x300?

You could try masking hotplug interrupts altogether.

Also, just to sanity check things, can you look at the output of "lspci
-s 02.0 -vvv -xxx" and see if the "INTx" field is + or -?  If it's +,
then the interrupt is definitely coming from an un-acked IRQ source on
the gfx device.  If it's INTx-, it means something in one of the upper
MSI layers isn't getting handled right.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/5DLX5Z3eBl3nWW4TdUBRjVk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhH1IAAoJEIEoDkX4Qk9hjGoQAKoNbb+DvhrK0uCryUnbILS7
3A17hW9iWzHHbp1bO+TZjRDL91zq7mgtKnm6Eohz6vVvyHCqWWfNiMWgNWq+IKN2
DpIFnHl0Y0IcU1pUHYNvO9+t5f+DIRhfkGVo83R71k2MSXlyV93fOKHXZ3coNCnn
gUMKGAnj9YVhfqWgl+gjFt77IaMN4pnf0NhpM61D4XH8mLwsktsxuZQqNxAAHZZn
it0eJEqpIreXb4CPAIk3nbKuYJuieAr1lg07pA/CB2omKtML8exrWRubNqk5F9yX
s2tLSdcXp9hnakY5tBveRF8l5QboaJjEjNdlNw3MG2UEhv9Ls3eI65t6svRiwAZM
Plt+g1ha86AM/Of2YftOi+r/WnrUGqxQSzRe19v5FUg210TY+taWf2qxVARYXtjE
qFNT+kVYL0p/lk0pRt4RRS++e7pfknUUuAhrXklM5kYeQV6iY5b9lqoSJZvIJOoq
uFzSWmjBZj1Eej2b8VsSTDGyCsLs6WFdBlMTj9BJ6ASzLuQ4AEtKql6PzzdYfUxx
md6Yj0rALJsIe1lQMj9xyIKGxdCvdAtEJTrXrFa9+7bE2MrqXhfEV3kFUzjRM/2h
XKg5zfkvL9Bq/PKgfwoyXIvZnmCmuHyA3TgwqMBhxa8CoYtAjpnAkgQEY7rb3G7Q
0oyVQI6qTLgjDhd8meSp
=jzA0
-----END PGP SIGNATURE-----

--Sig_/5DLX5Z3eBl3nWW4TdUBRjVk--
