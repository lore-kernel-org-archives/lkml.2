Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab2HBIpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 04:45:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53527 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2HBIps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 04:45:48 -0400
Date: Thu, 2 Aug 2012 10:45:41 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
Message-ID: <20120802084541.GA15042@avionic-0098.adnet.avionic-design.de>
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com>
 <1343390750-3642-2-git-send-email-acourbot@nvidia.com>
 <50170EA0.1010408@wwwdotorg.org>
 <501A338D.7080105@nvidia.com>
 <20120802082157.GA14866@avionic-0098.adnet.avionic-design.de>
 <501A3A00.7070207@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <501A3A00.7070207@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:5VIQVQOFr4Aimxfcpez98NVcluY/B+gRc6Lau6j18Ji
 eVGU5nfp0jqMkx2iv2CPFV0GoRN/7BPzAU/Sxn89kxjoVfitjp
 GPKVwTWwzDp8Tf4JzaynEeN66cIOHE+35dOn3xBC/viS73kNtj
 Vq+sPu1Loiu65MLU/P13Miaz4YE3fqOS0mq84Z4kowD1HFDBFu
 x2Ec389tqS8ZRBirbZc0PX1VBHbHg699YPfKevCcfL95egZpAh
 SV+XjdsBdS9wBs7v2YcveeRCWTzNR3ZcizMl4/BUCNshSGwxBS
 6c2/LKTLr1F8cReoWP+ntgks8sOQ0v4Ho8Qz9jnELi+CleRTR0
 RQFpJmPe7EiChwaPurZg1sxk67r/yjXBAHn46C9aTgn6KmLZdO
 KNKzZQWu45H4MjM6QqpeWu6DVG9YaypGug=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 02, 2012 at 05:27:44PM +0900, Alex Courbot wrote:
> On Thu 02 Aug 2012 05:21:57 PM JST, Thierry Reding wrote:
> >* PGP Signed by an unknown key
> >
> >On Thu, Aug 02, 2012 at 05:00:13PM +0900, Alex Courbot wrote:
> >>On 07/31/2012 07:45 AM, Stephen Warren wrote:
> >>>Oh I see. That's a little confusing. Why not just reference the releva=
nt
> >>>resources directly in each step; something more like:
> >>>
> >>>		gpio@1 {
> >>>			action =3D "enable-gpio";
> >>>			gpio =3D <&gpio 1 0>;
> >>>		};
> >>>
> >>>I guess that might make parsing/building a little harder, since you'd
> >>>have to detect when you'd already done gpio_request() on a given GPIO
> >>>and not repeat it or something like that, but to me this makes the DT a
> >>>lot easier to comprehend.
> >>
> >>I tried to move towards having the phandles directly in the
> >>sequences themselves - that reminded me why I did not do that in the
> >>first place. Let's say we have a sequence like this (reg property
> >>omitted on purpose):
> >>
> >>	power-on-sequence {
> >>		step@0 {
> >>			regulator =3D <&backlight_reg>;
> >>			enable;
> >>		};
> >>		step@1 {
> >>			delay =3D <10000>;
> >>		};
> >>		step@2 {
> >>			pwm =3D <&pwm 2 5000000>;
> >>			enable;
> >>		};
> >>		step@3 {
> >>			gpio =3D <&gpio 28 0>;
> >>			enable;
> >>		};
> >>	};
> >>
> >>The problem is, how do we turn these phandles into the resource of
> >>interest. The type of the resource can be infered by the name of the
> >>property. The hard part is resolving the resource from the phandle -
> >>it seems like the API just does not allow to do this. GPIO has
> >>of_get_named_gpio, but AFAIK there are no equivalent for regulator
> >>consumer and PWM: the only way to use the DT with them is through
> >>get_regulator and get_pwm which work at the device level.
> >>
> >>Or is there a way that I overlooked?
> >
> >No, you are right. Perhaps we should add exported functions that do the
> >equivalent of of_pwm_request() or the regulator_dev_lookup() and
> >of_get_regulator() pair.
>=20
> How would that be looked with respect to "good DT practices"? I can
> somehow understand the wish to restrain DT access to these functions
> that integrate well with current workflows. Aren't we going to be
> frowned upon if we make more low-level functions public?

Yes, I think that's exactly what will happen.

Thierry

--DocE+STaALJfprDB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQGj41AAoJEN0jrNd/PrOhmDwQAMEvzOjcnqnUhkvHRWK3SvID
9dVc3dGgPm3A+8b2HCUDkfkaaMTZyRr2iOM3gM33T6zXi821tdYibBOyPyOT1Ckj
PmuOaCG1NW8duDvbLnqAd5D58l9mVDJk2j3CNVF4XCiC+Ul+9qNLu3RngFf+t0z7
U8Q1Kq2tP51LPxYjK67IgFpRdQvzdq8XQA2jXlHSBkSmMqIt61dWcAvNqJvlqpa9
bFg18L3zQG1YzFrOXvfRKIX4hTblPkvBoxmrbn9j6oR/mAOJLNu8tpWtHs3SocnB
tCH1NowSgGjiLeFLXTQxnfD421YsPZhyjWi+WXvsRnMLIaM+IqRtm/jYcfu2Os5M
aiueERjqaGOnAq7k4gWPGzbhZ2a2fiuw26XUr3fIi2Ae+HnP8FYJLWyW7zAXOmYM
zyv98RRdkP3LscUlZOzWIglpwQgOq/NSySFS/WyeGtkvJYxZ+CQg+Q6pomwAiQsC
r86+koAUrtTHl4sO/FosDT9Q3/HCItF7j3Dw85PhszzZiIdg0PnW7XrQKsQZknch
MqbxNzOrKUf6+Nd1npjmZSkTdpLvpSm0rD+sO3ET4YJxhnQF1sFvRhyW62q5XyWM
Yp9yGbFgmLr8CKrBmlpkbaTqwS9372ZFTYsxb7ATqhGx+KHL2EPxLDXX/TFWCpeR
ZfG5wD9BuY7YT0BzesTT
=tJ1V
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
