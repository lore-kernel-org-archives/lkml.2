Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab2JHFp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 01:45:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49514 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2JHFp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 01:45:56 -0400
Date: Mon, 8 Oct 2012 07:45:42 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Andrew Jones <drjones@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [PATCH] pwm: Get rid of HAVE_PWM
Message-ID: <20121008054542.GA14907@avionic-0098.mockup.avionic-design.de>
References: <1349330819-11924-1-git-send-email-thierry.reding@avionic-design.de>
 <506DA487.9070400@metafoo.de>
 <20121004182931.GA7228@avionic-0098.mockup.avionic-design.de>
 <506DDA16.8070604@metafoo.de>
 <20121004191308.GB7228@avionic-0098.mockup.avionic-design.de>
 <CAMPhdO-PiKwYstKrGwdhrUG3+KWhPioAtzPVqtk52vss-4M+iw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <CAMPhdO-PiKwYstKrGwdhrUG3+KWhPioAtzPVqtk52vss-4M+iw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:W+13vhBz1P9zWYvUc7e4+jJf4bGfj1GRyaIENeGipGf
 UHYAJQgPaLj4onTXtyfg4T0zrA4AF5vvGkX9pjcNQpN8otRfFf
 mjYREDIez7XyRbPKsouE48m2oHJQ9ehIIwH1j1yRgUAHJ9IlFh
 i0zgDPK+Hx4m9qRIbpYj7TNb/23bu/9EPGEZW3JK4CmF75lGFt
 uFO8zvm/d7nvihyQoMdtbeRpxLHuu8iEzpYCsjOqZ89TG5oLOU
 DlR6WkrSM62HWfLuEm3i8aoAbOlz76fDXHL463BGZrrDfSkAF6
 I7vUwaakG0Ogmmz6FxKn6vPDamEEXonw4hWg9kTeBt9herHBJl
 7NEMSixk4YFLP9cReGvQGOqwsbe1wXmabrJrQZwPVXe3NE+B+m
 0It9MLi54eWQJmFwRozyL4DciIpV/jNM9k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 08, 2012 at 10:45:44AM +0800, Eric Miao wrote:
> On Fri, Oct 5, 2012 at 3:13 AM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> > On Thu, Oct 04, 2012 at 08:48:54PM +0200, Lars-Peter Clausen wrote:
> >> On 10/04/2012 08:29 PM, Thierry Reding wrote:
> >> > On Thu, Oct 04, 2012 at 05:00:23PM +0200, Lars-Peter Clausen wrote:
> >> >> On 10/04/2012 08:06 AM, Thierry Reding wrote:
> >> >>> [...]
> >> >>> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> >> >>> index 331d574..b38f23d 100644
> >> >>> --- a/arch/mips/Kconfig
> >> >>> +++ b/arch/mips/Kconfig
> >> >>> @@ -219,7 +219,8 @@ config MACH_JZ4740
> >> >>>   select GENERIC_GPIO
> >> >>>   select ARCH_REQUIRE_GPIOLIB
> >> >>>   select SYS_HAS_EARLY_PRINTK
> >> >>> - select HAVE_PWM
> >> >>> + select PWM
> >> >>> + select PWM_JZ4740
> >> >>>   select HAVE_CLK
> >> >>>   select GENERIC_IRQ_CHIP
> >> >>
> >> >> I'm not sure if this is such a good idea, not all jz4740 based board
> >> >> necessarily require PWM.
> >> >
> >> > This really only restores previous behaviour. But I agree that this =
is
> >> > potentially not what we want. Maybe we should just not select this f=
or
> >> > any boards but rather leave it up to some default configuration. If =
so
> >> > the patch can be made simpler by just removing the HAVE_PWM entries.
> >>
> >> At least for JZ4740 I think that is the better solution.
> >
> > Okay, I'll give other people the chance to comment on this. Especially
> > for PXA there are many boards that use the PWM for backlight and it
> > would be interesting to hear from them how they want this to be handled.
>=20
> I'd say the original intention to introduce HAVE_PWM (although PXA
> makes a lot use of this, but I remember Russell was the first to propose
> this), is for board config to indicate its potential usage of the PWM or
> rather if PWM is available for use on the board, and then leave the
> developer another config option to build or not-to-build.

But with HAVE_PWM there was never a different configuration option to
enable the PWM driver. All architectures that used the HAVE_PWM symbol
built the driver based on its selection. The meaning seemed more like
"the PWM API is available" rather than anything else.

Given that, HAVE_PWM would now be replaced by just PWM since that makes
the API available. Client drivers would still be able to compile
properly but fail at runtime if no driver actually provided any PWM
devices.

Note that starting with 3.7 the API will even be available in the form
of dummy implementations if PWM is not selected.

> Personally I think removing HAVE_PWM will simplify the code a bit
> and that's a good thing, on the other hand, how to keep a certain level
> of flexibility mentioned above remains a small question. I guess with
> device tree, this can be mitigated a bit.

I think, given the above, that the best solution would be to not select
any PWM-related symbols from boards and handle this via the board
default configurations. I was just worrying that we were changing
existing behaviour. On the other hand behaviour was already changed by
making the drivers no longer conditional on HAVE_PWM.

If nobody has any objections, my tendency would be to just not replace
HAVE_PWM but just get rid of it. Of course, as I mentioned above, it
would require the board default configurations to be updated and select
the PWM and corresponding driver symbol in order to restore previous
behaviour.

Thierry

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQcmiGAAoJEN0jrNd/PrOhn34P/1eEvqotszDo06w1x1/nqglS
q76wtUA+NMkMRBAxggJKuzRCsCnA5O5qaU6hJfpIiXyRTRviDzanXV8FpQfMeJkG
xw8Z8MbU7JU1Nfb93+yKOoWpOn2nxO8Yu9QsIajSjxZfASx6n99Zx3sY3Ik27Odf
0zsfMR8puYVAVk6y8lNvNcLcedzsUp5qWIBrqo47ZZ0VSV4s0gASnEOyLGnCOEGJ
SwR7hFxoxNbaMPvLmwSp+NG+N4GgS+tlaz5X7tCsaPf43tNXqoea7yeE9vcw663Y
IkbOsizRGjVv/0jyjq0eSbD3RLPiAHVa4OUEBUSBBbGbzG7NdQINBMtrgl0qIsqd
1U2yPhsW9eCvfN3JUGYcWfKiYL5ZJbnVduKraUf89RFO6D17XRlKbK8JYesI6fl/
orNMZGO5DtcHlybX/D+tqyHVBsYFN/Mi8KumeY/bB5GJ91eu69nc/GfDEKyU/aCt
e1fbbtoCafBNElYC7AJgxhPAMTfxQu0Q4sPYEHWZ/g6e65pBxpQYyR+XP0azC3mD
3oObkYNK1jVd1GLdHbCdEMjhVYGp6GxtWK9LWw+HS7CRCtr9Z1AhBcl/q0sSjQZ4
GrYJxgjJdQFvecfOXKFX6ur7vr8PbdPrhRFo1EoidkJh25t4SBBgN7+jKskym+IG
7uBfn7cbOlYL6Q7mdZ/q
=FSef
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
