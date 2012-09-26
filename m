Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab2IZQuC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 12:50:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59300 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab2IZQt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 12:49:59 -0400
Date: Wed, 26 Sep 2012 18:49:49 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "Philip, Avinash" <avinashphilip@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: Re: [PATCH v2] pwm_backlight: Add device tree support for Low
 Threshold Brightness
Message-ID: <20120926164949.GA24041@avionic-0098.mockup.avionic-design.de>
References: <1348203080-16348-1-git-send-email-avinashphilip@ti.com>
 <505BF83D.8040201@wwwdotorg.org>
 <518397C60809E147AF5323E0420B992E3E9A685B@DBDE01.ent.ti.com>
 <505CA74B.2090405@wwwdotorg.org>
 <518397C60809E147AF5323E0420B992E3E9A8449@DBDE01.ent.ti.com>
 <50614CE2.7010301@wwwdotorg.org>
 <518397C60809E147AF5323E0420B992E3E9A8FA7@DBDE01.ent.ti.com>
 <50631EF7.6040908@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <50631EF7.6040908@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:xKBcASMXTlwfpwvWQZjSbHPrcuKriDZxm5vpFOF+H5M
 QKSpEveN8xmiFWcyEqSnupD94+hBKQXu39jpg4F1N0yZ1Bz5XD
 h8sL44wGB22rLDcQEKXAN3cZ17yRXo+OYUWSnjjD7N7rC7n1e/
 Y6GStdWtRjzErGeFG2Opc/MwCe3+VqYyjw6Y09A12ky8t6AcM3
 d7LqHlcI66GNzVpNUY8qUBJb0PHP7Hm6YJ+MPg4xS28MVL/UP+
 VLcEKdAt/3M8hjLgaZdPiGqRVUsTHgfjlLLjBs52FegLJ6C8qR
 /T1AjHczOFbB97mtbLj2oZYxxRk0YhM8xF8pHSkJMSV7CbCkZQ
 YdupLvULWZrPcZ3fDBn4/FbqHn/kRbCeJLto1VHDChDDt/PhDk
 +nIDqJl7d4YISwEt52v/SoQ3bX/AfNZ9wo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 26, 2012 at 09:27:51AM -0600, Stephen Warren wrote:
> On 09/25/2012 10:35 PM, Philip, Avinash wrote:
> > On Tue, Sep 25, 2012 at 11:49:14, Stephen Warren wrote:
> >> On 09/24/2012 10:29 PM, Philip, Avinash wrote:
> >>> On Fri, Sep 21, 2012 at 23:13:39, Stephen Warren wrote:
> >>>> On 09/21/2012 12:03 AM, Philip, Avinash wrote:
> >>>>> Hi Stephen,
> >>>>>
> >>>>> On Fri, Sep 21, 2012 at 10:46:45, Stephen Warren wrote:
> >>>>>> On 09/20/2012 10:51 PM, Philip, Avinash wrote:
> >>>>>>> Some backlights perform poorly when driven by a PWM with a short
> >>>>>>> duty-cycle. For such devices, the low threshold can be used to sp=
ecify a
> >>>>>>> lower bound for the duty-cycle and should be chosen to exclude the
> >>>>>>> problematic range.
> >>>>>>>
> >>>>>>> This patch adds support for an optional low-threshold-brightness
> >>>>>>> property.
> >>>>>>
> >>>>>>> diff --git a/Documentation/devicetree/bindings/video/backlight/pw=
m-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-bac=
klight.txt
> >>>>>>
> >>>>>>>  Optional properties:
> >>>>>>>    - pwm-names: a list of names for the PWM devices specified in =
the
> >>>>>>>                 "pwms" property (see PWM binding[0])
> >>>>>>> +  - low-threshold-brightness: brightness threshold low level. Lo=
w threshold
> >>>>>>> +    brightness set to value so that backlight present on low end=
 of
> >>>>>>> +    brightness.
> >>>>>>
> >>>>>> For my education, why not just specify values above this value in =
the
> >>>>>> brightness-levels array; how do those two interact?
> >>>>>
> >>>>> Please find details from=20
> >>>>> https://lkml.org/lkml/2012/7/18/284
> >>>>
> >>>> Hmm. That still doesn't really explain what this property does.
> >>>>
> >>>> I'm going to guess that if this property is present, and values in t=
he
> >>>> brightness-levels property get scaled between the
> >>>> low-threshold-brightness and 255 instead of being used directly.
> >>>
> >>> This is correct.
> >>>
> >>>> But then, in the email you linked to, what does "But brightness-leve=
ls won't
> >>>> be uniformly divided" mean?
> >>>
> >>> For some panels, backlight would absent on low end of brightness due =
to low
> >>> percentage in duty_cycle. Consider following example where backlight =
absent
> >>> for brightness levels from 0 - 51.
> >>>
> >>> pwms =3D <&pwm 0 50000>;
> >>> brightness-levels =3D <0 51 53 56 62 75 101 152 255>;=20
> >>> default-brightness-level =3D <6>;
> >>>
> >>> So in the example, brightness-levels are set to have values for backl=
ight present.
> >>> Here levels are not uniformly divided.
> >>
> >> So why not just change the values so they /are/ what you want? After
> >> all, it's just data and you can put whatever values you want there. Wh=
at
> >> is preventing you from doing this?
> >=20
> > brightness_threshold_level was added to explore lth_brightness support =
already
> > present in non-DT case.
>=20
> I understand that. Given my discussion above, I would advocate removing
> lth_brightness from the non-DT case rather than adding it to the DT
> case, since it seems entirely pointless.

It is still required for the case where brightness levels are not used.
So we can't drop it right away. I agree however that we should plan to
get rid of the max_brightness and lth_brightness eventually. Since the
DT bindings don't use it yet we should keep only the brightness levels.
Once all users have been converted we can rename max_brightness to
something like num_levels and remove lth_brightness. dft_brightness can
probably be renamed to default_level.

Thierry

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQYzItAAoJEN0jrNd/PrOhiM4P/0ONn7BPpLQXwZ5AYQU5pX4s
Y/5mX7ks2w1iaoXCBF0AadKSt61F7HkNzvM/8gzKO6rkEqCcTYAk16k1wHcJFQD6
M6eyIiZ9ZK/HOImtRaeO06ouWTkpZRO598iS3Mn9D1lqsl7e+2t0BQk5RzrK8lA/
+JLdStsUWp1QYgGw/0oAvU8RAjHplqRx8hRU+vjG7lZA3omi6FRI8l/4WIrLdebj
bD+Ium60PEa6cIUgTn79wEpuUXk4a70u6EkxTcqDNDkbq/TbC0wHsoKSVbASePbI
QaVC3qRdYEIJTOO04NSuQFHGgI87C5djsAf426aO5u69pwnJ4rchQWYM7bV52zss
dT/kV7SqO8nOfxyiUWvYF5jUowzOBgcWFnNraj4G00I3tXA19r5j0yRNeW+8/M4Q
XuKAImiVuVoW3ZfeBLeAHV87jcpI6/o4Ffvyubj9foBs2VIQKaHS26gFCnmLhNv4
UIWRYtAGi53JEpRWrT5zDVW0SFCeAnkazFFTPKMv/eEhzJr2r3qwjMPoKYYT8gyB
VtQjIVL6H1/H4dacUtLsljOEDUgIyoCnNtXbWwwg7z/mjZRP4ZkhtCGAgQcyTqiO
NBYAfypm1KepZu4rrcDgOH1jcTwt8e34gPivjihquBbujwUpodE2ErQabgHQPRxL
Hefi0L2Z5Cw+fJ9m1X1V
=Z7h/
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
