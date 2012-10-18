Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab2JRNmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:42:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61388 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab2JRNmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:42:51 -0400
Date: Thu, 18 Oct 2012 15:42:45 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Shiraz Hashim <shiraz.hashim@st.com>
Cc: spear--sw-devel@lists.codex.cro.st.com, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] pwm: add spear pwm driver support
Message-ID: <20121018134245.GA30997@avionic-0098.mockup.avionic-design.de>
References: <1350559712-8514-1-git-send-email-shiraz.hashim@st.com>
 <20121018120820.GA17980@avionic-0098.mockup.avionic-design.de>
 <20121018132928.GG16835@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20121018132928.GG16835@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:K1fez018++vtpk+TjCO/McKkTsVWFT0VEJ5KPq+pkO9
 WnvxE71gHHAzM2Ohi3r4MeRxAXR67HdSDNOQ0MMZL4WJu3pRrJ
 +9P34m7ZCGPek7f7zkF0pyyt0SqoZDwUzsiUVaJwVUd65Z/gmz
 +UlUY4YKNME3q0nZfSM860trnRLpocvHb5HrkBxc9mqrrKcgs1
 3zBNEfdE4NwEPNMqVwMg8Oi9Gokba18LFRzq6xnPcZZlmZBjO8
 Y9UVrr75LxzIAIUr+68sNNHK6skb+ypPwhZuY9DWe9vqiNgPhm
 N47O48M+9xYN1Zp37Q92iRs6H+d+0X3jNeWrr5h57+h1/dEvoW
 RfJpsc6qr1wj4BIDApCYBVDD+RVeApXZ6BXZGI6iITetPuJRL/
 zrT4j4jYi/FbWMShgYhpf8c9ytYNoHYE4E7dWoxrakMMQNfqG2
 T/7g+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 18, 2012 at 06:59:28PM +0530, Shiraz Hashim wrote:
> Hi Thierry,
>=20
> Thanks for the quick review.
>=20
> On Thu, Oct 18, 2012 at 02:08:20PM +0200, Thierry Reding wrote:
> > On Thu, Oct 18, 2012 at 04:58:32PM +0530, Shiraz Hashim wrote:
[...]
> > > +  first cell specifies the per-chip index of the PWM to use and the =
second
> > > +  cell is the duty cycle in nanoseconds.
> >=20
> > This should be "period in nanoseconds". I know this is wrong in the
> > binding documentation for other drivers but I've recently committed a
> > patch that fixes it.
>=20
> Okay but I couldn't see use of pwm->period set by of_pwm_simple_xlate
> anywhere. Am I missing something ?

It's set by the call to pwm_set_period().

> > > +/* PWM registers and bits definitions */
> > > +#define PWMCR			0x00	/* Control Register */
> > > +#define PWMDCR			0x04	/* Duty Cycle Register */
> > > +#define PWMPCR			0x08	/* Period Register */
> > > +/* Following only available on 13xx SoCs */
> > > +#define PWMMCR			0x3C	/* Master Control Register */
> > > +
> > > +#define PWM_ENABLE		0x1
> > > +
> > > +#define MIN_PRESCALE		0x00
> > > +#define MAX_PRESCALE		0x3FFF
> > > +#define PRESCALE_SHIFT		2
> > > +
> > > +#define MIN_DUTY		0x0001
> > > +#define MAX_DUTY		0xFFFF
> > > +
> > > +#define MIN_PERIOD		0x0001
> > > +#define MAX_PERIOD		0xFFFF
> >=20
> > Would it make sense to perhaps group the bitfields with the matching
> > register definitions to make their use more obvious. Also I prefer
> > lowercase hexadecimal digits, but that's pure bikeshedding.
> >=20
>=20
> Sure I would group them, but uppercase hexadecimal digits clearly
> seperate the value (number) which otherwise can be mixed (while
> reading) with normal letters. Isn't it ?

As I said, this is really very subjective, so if you prefer uppercase,
feel free to keep it. =3D)

> > > +static inline u32 spear_pwm_readl(struct spear_pwm_chip *chip, unsig=
ned int num,
> > > +		unsigned long offset)
> >=20
> > I personally like it better to have function arguments aligned, like so:
> >=20
> > static inline u32 spear_pwm_readl(struct spear_pwm_chip *chip, unsigned=
 int num,
> > 				  unsigned long offset)
> >=20
> > Note, those are as many 8-spaces tabs with only spaces to align them
> > properly. But again, pure bikeshedding and I won't force the issue.
> >=20
>=20
> Would do that. Are you aware of some (vim) configuration which can
> autmatically do this while editing code ?

I'm not aware of any such setting, but the idea is interesting. I
usually do that automatically out of habit, but having the editor do it
would be nice as well.

> > __devinit will go away sometime soon, so please don't use it in new
> > code.
> >=20
>=20
> Okay. You mean all init sections would eventually be removed. I
> would read more about it.

Yes, commit 45f035a (only in linux-next I think) has some details.

> > > +MODULE_LICENSE("GPL");
> > > +MODULE_AUTHOR("Shiraz Hashim <shiraz.hashim@st.com>");
> > > +MODULE_AUTHOR("Viresh Kumar <viresh.kumar@linaro.com>");
> >=20
> > I don't think this works: the second entry will replace the first. Have
> > you verified that both authors appear in the output of modinfo?
>=20
> This is the output of modinfo (compiled for linux-3.5)
>=20
> $ modinfo pwm-spear.ko
> filename:       drivers/pwm/pwm-spear.ko
> alias:          platform:st-pwm
> author:         Viresh Kumar <viresh.kumar@linaro.com>
> author:         Shiraz Hashim <shiraz.hashim@st.com>
> license:        GPL
> alias:          of:N*T*Cst,spear13xx-pwm*
> alias:          of:N*T*Cst,spear-pwm*
> depends:       =20
> intree:         Y
> vermagic:       3.5.0-test-00138-g08e3584 SMP mod_unload modversions ARMv=
7 p2v8=20

Interesting. I thought I'd seen this fail only recently. Will need to
investigate.

> > > +MODULE_ALIAS("platform:st-pwm");
> >=20
> > Should this not rather be "platform:spear-pwm"?
>=20
> Yes, I would double check these kind of small issues before
> sending patches next time.

No biggie. That's why we have reviews.

Thierry

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQgAdVAAoJEN0jrNd/PrOhJSgQAJBFfEDXcHHdpr5eXq7mZ/yf
ycAmN02RVjXl1d3AHu9EaYgsEh6DplXCo5mbF37esXAPHTLlAB1/DwnGndi1OtEZ
VxEYiD43sPoKKBU0HszQpXK+qx2jFpwFpghz/F3kgOrbkojVTzVU27Xo1ymG1pW3
EMHGZ7Xrvqs9KwD59iI7G2i7gUccqrH5AEBNNlZvzrJXysxVp5pvGiZkj4b/VRJD
LQtGPhMpLbegDaiOCDZQ6HDZYDF+SqkR/enBgfV+poawYtPxjx0ZKG2nB+7ttOZX
EB9vBDVAdbZnzK58YCafSU6C83MxqB3CfIUmicf9/lp7k78sqbaMmu3MdGqTik3g
VODASIj23OsyjvRwK2nsziudRnvB2c99mZ2XDteIzZkLC73laDLEGi96/YG5iQA/
cGMhxAPDQI2twQ6d8vZUe44vKRcN5at0RHIPg/7f6HnhAwbEVGnfoOSvvO+mUsyX
GgYv2MMyTqPIyIOiqNHCDwGg1gk+7ATwKg1Gg2NQf/Zw/sfQyFm8mmpoQyfmACml
lf7jFRz8kiyAb8bVwiCiVXrvXWBOXVT/8rUMKHJFBrsmoh4I6l46kDBu2nh+CS3t
8kMlUDD1BUVcYPLx+fywIFX24e6W6Y+o6/jML7CBDBcW/BM5sM5oSVmNNepo+cNC
SxBOS8qNqYZg+F6z4+Ub
=/ZVN
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
