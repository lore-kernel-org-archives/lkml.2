Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2HFIxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 04:53:16 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:50535 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753958Ab2HFIxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 04:53:04 -0400
Date: Mon, 6 Aug 2012 11:49:30 +0300
From: Felipe Balbi <balbi@ti.com>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Cc: balbi@ti.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rob@landley.net, linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        b-cousson@ti.com, rnayak@ti.com, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v6 01/11] drivers: usb: otg: add a new driver for omap
 usb2 phy
Message-ID: <20120806084928.GD17551@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1343639400-28725-1-git-send-email-kishon@ti.com>
 <1343639400-28725-2-git-send-email-kishon@ti.com>
 <20120803132708.GC8269@arwen.pp.htv.fi>
 <CAAe_U6K15Nm5aNs2Vn71G7ELZWka1zB2E3VGZWTc0VjyViJ6Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VMt1DrMGOVs3KQwf"
Content-Disposition: inline
In-Reply-To: <CAAe_U6K15Nm5aNs2Vn71G7ELZWka1zB2E3VGZWTc0VjyViJ6Yw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VMt1DrMGOVs3KQwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 03, 2012 at 08:01:44PM +0530, ABRAHAM, KISHON VIJAY wrote:
> >> +     return 0;
> >> +}
> >> +
> >> +#ifdef CONFIG_PM_RUNTIME
> >> +
> >> +static int omap_usb2_runtime_suspend(struct device *dev)
> >> +{
> >> +     struct platform_device  *pdev =3D to_platform_device(dev);
> >> +     struct omap_usb *phy =3D platform_get_drvdata(pdev);
> >> +
> >> +     clk_disable(phy->wkupclk);
> >
> > weird. I would expect the wakeup clock to be enabled on suspend and
> > disabled on resume. Isn't this causing any unbalanced disable warnings ?
>=20
> Even I was expecting the wakeup clock to be enabled on suspend but if
> we have this enabled coreaon domain is never
> gated and core does not hit low power state. btw Why do think this is
> unbalanced?

because you never do a clk_enable() on probe(), so on your first
suspend, you will disable the clock without having enabled it before,
no? Unless pm_runtime forces a runtime_resume() when you call
pm_runtime_enable()...

> >> +static int omap_usb2_runtime_resume(struct device *dev)
> >> +{
> >> +     u32 ret =3D 0;
> >> +     struct platform_device  *pdev =3D to_platform_device(dev);
> >> +     struct omap_usb *phy =3D platform_get_drvdata(pdev);
> >> +
> >> +     ret =3D clk_enable(phy->wkupclk);
> >> +     if (ret < 0)
> >> +             dev_err(phy->dev, "Failed to enable wkupclk %d\n", ret);
> >> +
> >> +     return ret;
> >> +}
> >> +
> >> +static const struct dev_pm_ops omap_usb2_pm_ops =3D {
> >> +     SET_RUNTIME_PM_OPS(omap_usb2_runtime_suspend, omap_usb2_runtime_=
resume,
> >> +             NULL)
> >
> > only runtime ? What about static suspend ? We need this to work also
> > after a traditional echo mem > /sys/power/state ;-)
>=20
> The static suspend case is handled by users of this phy using
> set_suspend hooks.

I'm not sure if that's too wise, what if your user enabled USB, but
for whatever reason loaded only the phy driver and not musb or dwc3. It
will fail, right ?

--=20
balbi

--VMt1DrMGOVs3KQwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQH4UYAAoJEIaOsuA1yqREFocP/i8C2ZsJXeF15dc8ODbWtT5L
1K3bFJwKZCqXIxLi/vpOgMYrpcCmv0EpYx4rwYtnDwXL3cd/t9i6XcjiJz6bBv7W
EwVfK185DNSf/nLM1lbiKiDSmNDZiMDe2MNYR6rts4jes9DjOr40mT2dhO1Xok5G
L8LXNifwjb/YUYXhvQ99iFN9Z5wj8wY0V6xJypP+fhjcx9TQac8p7aQmpi3/vayt
gXN8N3eXOozQeBACOprnhcQ6SXgOPWVojYE99gzjgYPaY0SD3LU1Hi2JjUT1ty0v
fj6P82ykMVYBjQBuJp5ShKVKFRCchoA07mNs96S1cZGx6sv75fmGyyS5MOPWh0iM
LmD8281A0Mw0oF6gP58iTSS5hyrAEgU6R7UVCJyYQsy5gTXIqy81pVaLJu5KSB5E
T0F3ncojFbnCde46hRpPTVQdCQde7uubrwmm5/C1MVYob/yh9ibxPznNMygGFGmp
/7pHw1we1wGE9J5MP8Im/1c6D8tWeI3yJogeUrf5YqCeYQz9ANuNyiZmGBezS+Oe
jMqw35b/aaUfSU6PkMWj8c3wkCkTGhxwSbdB29+W4Ee1Q9m/DHRJND1OIOpaYTNX
t4tOsLSjvYt4VyBli6rek6ehW2Jp/pY/2z0R8PGiwzPto6gKeh3/ASzu/J60Lr2P
gCgnC/x8JY1a9/hc7VS5
=8Oyd
-----END PGP SIGNATURE-----

--VMt1DrMGOVs3KQwf--
