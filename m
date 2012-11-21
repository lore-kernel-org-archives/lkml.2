Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab2KUIOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 03:14:21 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59130 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab2KUIOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 03:14:17 -0500
Message-ID: <50AC8D3B.6040300@ti.com>
Date: Wed, 21 Nov 2012 10:13:47 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Alex Courbot <acourbot@nvidia.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
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
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com> <1353149747-31871-2-git-send-email-acourbot@nvidia.com> <50AB9832.90709@ti.com> <4316169.5QXVzv7peZ@percival>
In-Reply-To: <4316169.5QXVzv7peZ@percival>
X-Enigmail-Version: 1.4.5
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig403A57F02E04A77E078F8D06"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig403A57F02E04A77E078F8D06
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-11-21 03:56, Alex Courbot wrote:
> Hi Tomi,
>=20
> On Tuesday 20 November 2012 22:48:18 Tomi Valkeinen wrote:
>> I guess there's a reason, but the above looks a bit inconsistent. For
>> gpio you define the gpio resource inside the step. For power and pwm t=
he
>> resource is defined before the steps. Why wouldn't "pwm =3D <&pwm 2
>> 5000000>;" work in step2?
>=20
> That's mostly a framework issue. Most frameworks do not export a functi=
on that=20
> allow to dereference a phandle - they expect resources to be declared r=
ight=20
> under the device node and accessed by name through foo_get(device, name=
). So=20
> using phandles in power sequences would require to export these additio=
nal=20

Right, I expected something like that.

> functions and also opens the door to some inconsistencies - for instanc=
e, your=20
> PWM phandle could be referenced a second time in the sequence with a di=
fferent=20
> period - how do you know that these are actually referring the same PWM=
=20
> device?

This I didn't understand. Doesn't "<&pwm 2 xyz>" point to a single
device, no matter where and how many times it's used?

>>> +When a power sequence is run, its steps is executed one after the ot=
her
>>> until +one step fails or the end of the sequence is reached.
>>
>> The document doesn't give any hint of what the driver should do if
>> running the power sequence fails. Run the "opposite" power sequence?
>> Will that work for all resources? I'm mainly thinking of a case where
>> each enable of the resource should be matched by a disable, i.e. you
>> can't call disable if no enable was called.
>=20
> We discussed that issue already (around v5 I think) and the conclusion =
was=20
> that it should be up to the driver. When we simply enable/disable resou=
rces it=20
> is easy to revert, but in the future non-boolean properties will likely=
 be=20
> introduced, and these cannot easily be reverted. Moreover some drivers =
might=20
> have more complex recovery needs. This deserves more discussion I think=
, as=20
> I'd like to have some "generic" recovery mechanism that covers most of =
the=20
> cases.

Ok. I'll need to dig up the conversation. Did you consider any examples
of how some driver could handle the error cases?

What I'm worried about is that, as far as I understand, the power
sequence is kinda like black box to the driver. The driver just does
"power-up", without knowing what really goes on in there.

And if it doesn't know what goes on in there, nor what's in "power-down"
sequence, how can it do anything when an error happens? The only option
I see is that the driver doesn't do anything, which will leave some
resources enabled, or it can run the power-down sequence, which may or
may not work.

 Tomi



--------------enig403A57F02E04A77E078F8D06
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQrI0/AAoJEPo9qoy8lh712M0P+gIChgVfl7Gu5kAIKRNg10G8
rxxs1RmpSJFHATQJpteeLCpuQV+8HgyE0mAznCOxXymB+kM7qQ5E1VBY+COk2r2k
IoBc3kPYjeGzQHNwOYiS8+CTu7zveQN+7cCs4UOtCWHPX2MmkPHcv5B0uWX2Cx9j
BQdRDQb61xo3BhpG3M4krqW0wvemfYvlZYe3UL7DEFgHojvv3UBulOQlI7v7UeVd
SJ3UjET7CL3yRVPoKE+LAGLbDWN153hIKSBdsMGplL7iWseFlFSOncDcEyvgeJ/y
JljHXcjDDNEGrAXtrVZ+Mgmk68zm7uj/UzFdawShmsplL7jok9rvh/9zfKxjBW++
Xb7Yso89fytQM03ys8yJpFZS3zSTsGOXM0YD8QFldYnC09V4cuSM6G2uCKBd26Qa
EBPtKd4wgJOGHBkXAmI/4pj0cW/XJXvybLhlBKuBC7QElau86mT2ie7abfzFl6eY
jvfiIKg312QvnG/44TNUMDUQBcSnhoyodQMk/54D2xkZiKrgDNYsMHkohVGWQP7D
Y2W8WLrAqeSWdcG3dKp2nKua0c9O2UBn7QNqNtFivMafelAn74Q/PQDcLv5uMFz7
t95g7zl7isRneYCB5bVwXrHpr24lJ5PAirPrrDNxwP9/U1KOth0nK2oeCuKIn8XS
b99Gejfh3zdY0QTTEX5u
=g1w0
-----END PGP SIGNATURE-----

--------------enig403A57F02E04A77E078F8D06--
