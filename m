Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab2KUNcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:32:52 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42410 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab2KUNcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:32:50 -0500
Message-ID: <50ACD7DC.5060405@ti.com>
Date: Wed, 21 Nov 2012 15:32:12 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Tomi Valkeinen <tomba@iki.fi>, Alex Courbot <acourbot@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, Mark Zhang <markz@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com> <1353149747-31871-2-git-send-email-acourbot@nvidia.com> <20121120215429.B621F3E1821@localhost> <13540495.epaCf4JVn9@percival> <50ACB59B.4090404@iki.fi> <20121121114018.GA31576@avionic-0098.adnet.avionic-design.de> <50ACC341.3090204@ti.com> <20121121130039.GA12191@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121121130039.GA12191@avionic-0098.adnet.avionic-design.de>
X-Enigmail-Version: 1.4.5
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig91DDA03DDFA9C8D1442FCECF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig91DDA03DDFA9C8D1442FCECF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-11-21 15:00, Thierry Reding wrote:
> On Wed, Nov 21, 2012 at 02:04:17PM +0200, Tomi Valkeinen wrote:
>> On 2012-11-21 13:40, Thierry Reding wrote:
>>> On Wed, Nov 21, 2012 at 01:06:03PM +0200, Tomi Valkeinen wrote:
>>
>> (sorry for bouncing back and forth with my private and my @ti addresse=
s.
>> I can't find an option in thunderbird to only use one sender address,
>> and I always forget to change it when responding...)
>>
>>>> My suggestion would be to go forward with an in-driver solution, and=

>>>> look at the DT based solution later if we are seeing an increasing b=
loat
>>>> in the drivers.
>>>
>>> Assuming we go with your approach, what's the plan? We're actually
>>> facing this problem right now for Tegra. Basically we have a DRM driv=
er
>>> that can drive the panel, but we're still missing a way to hook up th=
e
>>> backlight and panel enabling code. So we effectively can't support an=
y
>>> of the LVDS devices out there without this series.
>>
>> Could you describe the hardware setup you have related to the LCD and
>> backlight? Is it a public board with public schematics?
>=20
> I don't think any of the schematics are public. The Tamonten Evaluation=

> Carrier is available publicly from our website and the schematics are
> available on demand as well. If required I can probably arrange to send=

> you a copy.

No need, I think your answer below is enough.

>> I've understood that you don't have anything special in your board, ju=
st
>> an LCD and a backlight, and the power sequences are related to powerin=
g
>> up the LCD and the backlight, without anything board specific. If so,
>> there's no need for board specific code, but just improving the panel
>> and backlight drivers to support the models you use.
>=20
> Correct. Basically we have two GPIOs that each enable the panel or the
> backlight respectively and one PWM to control the brightness. Are the

The panel GPIO goes to the panel hardware device, and enables the panel?
And similarly for the PWM GPIO, it goes to the PWM hardware device? Just
making sure there are no other components involved.

> panel drivers that you refer to those in drivers/video? I'm not sure if=

> adding more ad-hoc drivers there just to move them to a generic
> framework in the next cycle is a good idea. I'd rather spend some time
> on helping to get the framework right and have drivers for that instead=
=2E

We have panel drivers for omap in drivers/video/omap2/displays/. I'm not
sure if other platforms have their own versions of panel drivers, but
probably adding a simple panel driver system for a platform would not be
too difficult. It could even be quite hardcoded, i.e. embedded directly
into the display subsystem driver, just to get something working until
the common panel framework is available.

Yes, I agree it's not good idea to add more platform specific panel
drivers. But it's unclear when CPF will be merged, so if you need to get
the panel working now, I don't see a simple ad-hoc driver as too
horrible. But, of course, I'm not the one making the decision whether to
merge or not =3D).

> From what I understand by looking at the OMAP display drivers, they als=
o
> provide the timings for the displays. Steffen's videomode helpers can b=
e
> used to represent these easily in DT, but I suppose if all of those per=
-

Right. Note that I didn't present omap panel drivers as perfect
examples, just examples =3D).

> panel specifics are represented in the drivers then that won't be neede=
d
> anymore either.

Yes, for most panels with just one native mode and nothing else, the
panel driver can contain the timings.

However, this subject has been discussed earlier a few times. If the
panel in question doesn't need any special power-on/off sequences, just,
perhaps, one gpio or such, we could still use DT video modes. This would
simplify the cases where you have lots of different very simple panels.

Obviously the same questions apply to DT video modes than to the power
sequences, and while I do think it's better to handle the timings inside
the driver, I'm not too much against video timings in DT. The reason
being that the video modes are quite clear, simple and stable data,
versus the much more complex and open-ended power sequences.

>> I don't see any problem with adding small Tegra specific panel drivers=

>> for the time being, with the intention of converting to common panel
>> framework when that's available.
>=20
> I can take a look at how such a driver could be implemented, but again,=


Don't look at the mainline omap panel drivers, at least not too closely
=3D). They contain hackery that will be cleaned up with CPF.

I think there are two methods to implements simple panel drivers:

The hardcoded one, where the display subsystem driver manages a few
different panel models. This is obviously not very expandable or
"correct", but should probably work just fine for a few models, until
CPF is usable.

Something like CPF will have: have the panel device/driver as a platform
device/driver, which will register itself to the display subsystem. And
with "itself" I mean some kind of struct panel_entity, with a few ops
implemented by the panel driver.

Well, this goes a bit out of subject. If you want to discuss panel
drivers more, please start a new thread. Laurent's upcoming CPF v2
should give you good ideas what the model will be.

 Tomi



--------------enig91DDA03DDFA9C8D1442FCECF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQrNfcAAoJEPo9qoy8lh71IlcP/2e373cTihIOiVdzzOTAVq3p
k3S9dA4YbjztPYoxYNVZ1yytKkRVehR4SMJfJzQHcruf37ZqALrM1rw7w92L3fAx
CJfx54JtnPpkaRZCawyT6EhvqcBJnivoRTOoi0sGtqe+QoZMEUR/7BHBymPS9nFh
BWtuPdMa7lpZqdX93oYJaz+aU/hFuv+0agzAR6OoMXM1XfXfEn6xhJ17LImfdUpF
Zi6xaOb6WEx1bOm943vr54tG6XbnsmTjwWjU/d3BMKR5JRjQdyVPU75DOp6ETpmT
xasCbblyVuXPSw6cObfB9yDygPHNUNJpzUTSzT67JFVqH7Az9aRNB25iBepmsI+H
O+K9xMvQKGqf1q+/Vgl9FByv4rzAuihPpX3kdV9X3v2b/UdkAITz77s6u6k62WSm
byOQv50zhKOLtP67WMfCPJoUb0i6KqpnLwAvq+6h8CMaAvaCVhlLuNVi31DXxknY
4344nBZ98Z3oVb10mGH8QBkA2LRUF1v6u2l7WSZxL3/0N171yAk2aB/3/NZWq40q
/FHtpUtaTQQ1+U8UZ4MKiG9L35/LHYgnlnQeU2ddizyXigQqAqbCZHle8+RJoaHF
tbSXACTCEie0LjB6biwGahk91bmoRfo7JUMX4Tj5gmPujwLF5P+0WfUlFIGuQwgs
PIid/tpaMy6mhLbEQLcI
=M0Lp
-----END PGP SIGNATURE-----

--------------enig91DDA03DDFA9C8D1442FCECF--
