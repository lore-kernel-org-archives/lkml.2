Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab2JAI4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 04:56:01 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:38864 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751945Ab2JAIz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 04:55:58 -0400
Date: Mon, 1 Oct 2012 11:50:52 +0300
From: Felipe Balbi <balbi@ti.com>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Cc: balbi@ti.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rob@landley.net, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/6] usb: dwc3-omap: use of_platform API to create dwc3
 core pdev
Message-ID: <20121001085051.GA19346@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348836795-4783-1-git-send-email-kishon@ti.com>
 <1348836795-4783-2-git-send-email-kishon@ti.com>
 <20120928125758.GK31006@arwen.pp.htv.fi>
 <CAAe_U6JX8nqhZU-m+0Cfh1-xEkZhXNf2ecYcg_JX9mx5fv1b3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <CAAe_U6JX8nqhZU-m+0Cfh1-xEkZhXNf2ecYcg_JX9mx5fv1b3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 28, 2012 at 07:01:04PM +0530, ABRAHAM, KISHON VIJAY wrote:
> Hi,
>=20
> On Fri, Sep 28, 2012 at 6:27 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Fri, Sep 28, 2012 at 06:23:10PM +0530, Kishon Vijay Abraham I wrote:
> >> Used of_platform_populate() to populate dwc3 core platform_device
> >> from device tree data. Since now the allocation of unique device id is
> >> handled be of_*, removed the call to dwc3_get_device_id.
> >>
> >> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >
> > I think it's best if you split the use of device_for_each_child() from
> > this patch. So first do the device_for_each_child() part, then later use
> > of_platform_populate().
>=20
> I think it's better to have it both together as of_platform_populate
> will create the device and the device_for_each_child() part will
> delete it on error conditions and during driver removal.
> In this patch the first device_for_each_child() comes in error
> condition and it is not needed if we have not created the device using
> of_platform_populate.

We are already parent of a device and we already handle child removal
manually. You can change the current implementation to use
device_for_each_child() and on a later patch introduce
of_platform_populate().

--=20
balbi

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQaVlrAAoJEIaOsuA1yqREnPcP/3Sr7v7PldUaazkom6xUwMsq
lUYN4YzeYJbtS8wqdyf+AMU1bbAeBdKv8cirLgh8AxGE4ILJiGmiXYsjg3KbUgma
fi8aMBgwhovDYAiJU/VS029qLIJyGHlFA4thbdoHymSOYoTX7RMEi9V2hLlTqmBQ
M2UKmB2ep8HBUwhLgnGMJty6qGOhz8KXXxG7oO6lunwzHeqzlEresP/b1Gd3YpVm
vkvdgXoqErh8aMgL9S5AaV178eFEIoLsvR6iaPO8JeWaNGI2vhrR9ZMmwkXrd9vZ
soZnuk35VrNJH3eyFeDkIloTAGWjT0uB+96WdVOhjF4i3WV70Bji9z0Q9i5HLZDT
cymfjpDwwMryhqhAdqV8Rbz6zYHlb9xWkhUncOHuS7ladY06DPwUVdk6So9GUyCn
0SJz553i3H/JQv8458NdOek19c8W2H5wBAZ2VygFyVsTRqkwDndh2HRVme/WtMC9
VRc1pTc+3LRCX+40CeDXGjOru8ymukRChzRcFiXKrDpbrkOUe6DTbYGj9dSxt/R/
TItEoOwULYaAIGYMQLw9OAguxvvLVg+FAfFHdeU8FOExPo5I9FlrBQNSSEvUh1NS
se+Iqs+XC8S2yOQyREKFkSasBOduIWFhLUoTCNbkm979p9CFbpmtrcrxFlTAYzA7
PZYml2WxpR2/bslLgNKt
=JM55
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
