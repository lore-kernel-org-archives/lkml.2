Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab2LKKAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 05:00:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61444 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab2LKKAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 05:00:49 -0500
Date: Tue, 11 Dec 2012 11:00:32 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-leds@vger.kernel.org
Subject: Re: [PATCH v3 1/4] leds: leds-pwm: Convert to use devm_get_pwm
Message-ID: <20121211100032.GA8907@avionic-0098.adnet.avionic-design.de>
References: <1355133637-2784-1-git-send-email-peter.ujfalusi@ti.com>
 <3193669.Hv54bBklsP@barack>
 <20121211083632.GC27084@avionic-0098.adnet.avionic-design.de>
 <1406670.ryvqfkiNXS@barack>
 <20121211093100.GA8437@avionic-0098.adnet.avionic-design.de>
 <50C6FF69.3030001@ti.com>
 <20121211094812.GA22222@avionic-0098.adnet.avionic-design.de>
 <50C70287.1060006@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <50C70287.1060006@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:9Xw+8awhfeFKg7ZC8x4KRuF/wXMNuEytsHCbarRzW76
 zXbRbH0QmKF1fq/UA4aMzUF/KPFiYC4Ph10l6s105xY6ooCKP6
 dRf7Qxgx21+9fFITIqpzdeSrytJpzDdBT7e7RT9nA1SABF69HS
 48xfcswhahUMr9cTtIZMmfufVFVbHwFhxVGcf0I/DoJ5pT7JI9
 KzhzQGClzLKA5ovHHmUU9azgLlH3r8DXH4TEkbT20XDDovwS0R
 JC5kLaIIXofAULCZOy73kD0Kgs+Q+fQG9DeS+lukU6HgqbGhyk
 24jLEnScw+n0ShdfwvmNQ5ZAOZxrPeI9HJD4rbuh3R6nEVMwJe
 ryCrObTTVHmkr/XF8xI66cDTfl0ILcCyzFx+l9uDrEU5E+v5V9
 Ink/SQ2B694k4ZxDBerhf7jyc2SCcCHn0g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 11, 2012 at 10:53:11AM +0100, Peter Ujfalusi wrote:
> On 12/11/2012 10:48 AM, Thierry Reding wrote:
> > On Tue, Dec 11, 2012 at 10:39:53AM +0100, Peter Ujfalusi wrote:
> >> On 12/11/2012 10:31 AM, Thierry Reding wrote:
> >>> On Tue, Dec 11, 2012 at 09:57:51AM +0100, Peter Ujfalusi wrote:
> >>> Okay, if there are no intree users that may be broken, then it should=
 be
> >>> fine to remove it. In that case you might want to remove the pwm_id
> >>> field as well instead of deprecating it in this patch.
> >>
> >> The reason I marked the pwm_id as deprecated is to signal to out of tr=
ee users
> >> (if any) that they should stop using it since it is going to go away i=
n the
> >> next cycle.
> >> If we remove it right away the sdp4030 board file will not going to co=
mpile in
> >> subsystem trees, only in linux-next.
> >=20
> > Okay, go ahead then. As long as the field will be removed eventually
> > that's fine with me.
>=20
> Thank you and yes, it will be removed.
>=20
> Probably it would be a good thing to check other places for legacy
> pwm_request() users and prepare them to move to (devm_)pwm_get gracefully=
 over
> coming kernel releases.

Yes, I have a local patch that deprecates pwm_request() and pwm_free()
to make it easy to spot them (though git grep does a better job actually
as it doesn't require compilation). I originally planned to replace all
pwm_request()/pwm_free() usage by pwm_get()/pwm_put() already for 3.8
but got side-tracked with other stuff but I hope I can make it for 3.9.
If that works out we could remove pwm_request() and pwm_free()
completely for 3.10.

Thierry

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQxwRAAAoJEN0jrNd/PrOhAgUQAJGP29h4E13zOyQDgnvS/azA
/B8wCXN4hr9TkFDJOK7X8bt/Cq/u3ALHqCQKLzl8RxS293vsra50pBk7LOHoBGTR
+pqnIKoWU/fqZrGaGKN+FNPXmBskpL9cpbc9gSDe4Y2DffOAbZKdbKh8cOgO5NCD
0qxLFr1mdsTKu+3/yhx714Kt5Ki16WB+3oIctEswyP7/tvxMyECx/88TImQjT3DH
VzY2DdlUwt7Xq36iLx9QJUS182fgfFI2g6N921QQoxY77/thOkgaYIlG1BhKoATl
7/8fa5KrR3KEBbmnnA4AD/kzc4IlfFMTkpJQd2ZnwJCeMahtABbfLPZsO2Namuc6
O1bP8xb4XohhwrG/Th4JkshqDI999y/sgPpw85WFrdFlKKogNodz1radaCtPY3Yl
w1478QG6qExWlL8Aaxc/OHBbUv6hKwV/S50928afl3xDVcYuLm+Vhm9L86IMGNEo
61A9aesoVa3Oyu6wYuBVrgDi/j/m/tAagAgohv2iRvehdOAJ0rRpkvfb9pHHBY9K
7aotIWW9nLIs2rKcyc1vcO/hfmzKiBZewWrjZh5PJfq7rqwWtSfJA0v4jWLWboVh
rrKYMjIVbWLHDkf9ifpfVgW9dn8wUMhgm6LRSVP1IYcWh2KwQrh4x027dYPVFBEL
sAUV2/zm7VcDPZgmyHmo
=7MQE
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
