Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab2GNMzn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 08:55:43 -0400
Received: from mout.web.de ([212.227.15.4]:54372 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab2GNMzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 08:55:41 -0400
Message-ID: <50016C44.5000607@web.de>
Date: Sat, 14 Jul 2012 14:55:32 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] KVM fixes for 3.5-rc6
References: <4FFEBB39.8090308@redhat.com> <CA+55aFwAXbrQRKg_cJT04H_XnoEPjJ0O711C5uA6fRY35DVhKQ@mail.gmail.com> <CA+55aFy=ogfJu3WuoCCDseysxOOn_UEAnv_7Ldsa45VV7fMVPg@mail.gmail.com> <alpine.LFD.2.02.1207131928000.32033@ionos> <alpine.LFD.2.02.1207140208270.32033@ionos> <500118F1.8060300@web.de> <alpine.LFD.2.02.1207141253490.32033@ionos> <500156B3.6040205@web.de> <alpine.LFD.2.02.1207141402290.32033@ionos>
In-Reply-To: <alpine.LFD.2.02.1207141402290.32033@ionos>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig60C96A0097810C41B51DB757"
X-Provags-ID: V02:K0:RQJR61xWLBNdP6aq2Tyo7lqz8Pm13sZxY3YSuxCfMtB
 LgQhUSZQu2PKKvWgZXf+1IMH/cBBxQsxQhgNSm2jGHzUsoUDha
 MbwvKapYHqCEsZT4wOHKwmq/5U4g6DmPk09ffDFXdwjTZUYAnj
 1PyoXCB8eiOgUNBGWI223EK+trLgtzf4MAmZJ/r4uHAny0IaOX
 2+TT76bMJ5HgA238emJvg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig60C96A0097810C41B51DB757
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-07-14 14:33, Thomas Gleixner wrote:
> On Sat, 14 Jul 2012, Jan Kiszka wrote:
>> On 2012-07-14 13:16, Thomas Gleixner wrote:
>>> On Sat, 14 Jul 2012, Jan Kiszka wrote:
>>>> On 2012-07-14 04:25, Thomas Gleixner wrote:
>>>> This patch here is a workaround to unbreak devices assignment in 3.5=

>>>> after the IRQ layer changes without regressing noticeable /wrt overh=
ead.
>>>
>>> Yeah, workaround and regression are the proper marketing buzzwords to=

>>> excuse mindless hackery.
>>>
>>> It took me a minute to figure out that there is no reason at all to
>>> use a threaded interrupt handler for MSI and MSIX.
>>
>> Thomas, we also explained to you in the cited thread that your simple
>> approach for this doesn't work as is. We will have a proper solution
>> soon, but it takes a bit more than a minute - at least us.
>=20
> And I explained to you in that very thread that the proper solution to
> avoid the "overhead" of finalize_oneshot is exaclty the patch I sent
> to Linus yesterday:
>=20
>> The only way we can avoid that, is that we get a hint from the
>> underlying irq chip/ handler setup with an extra flag to tell the
>> core, that it's safe to avoid the ONESHOT/finalize magic.
>=20
> So now it took a full month of ignorance to come up with the
> mindboggling solution of working around the core change with a private
> hack instead of sitting down and doing what was said to be the correct
> solution.

We sat down and tried to avoid the core problem of our use case: IRQ
threading. That we now have to fall back to something else is
unfortunate and was surely not planned.

However, if you push your patch for 3.5, I'm sure Avi will happily drop
the disliked workaround and replace it with ordinary IRQF_ONESHOT tagging=
=2E

Jan


--------------enig60C96A0097810C41B51DB757
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlABbEcACgkQitSsb3rl5xSv6QCcDjFZCXo1GD42eQDcxXqlTC2F
7F8AoMR+b89TCXwEjS3TgglP+jMLxGTA
=IDhz
-----END PGP SIGNATURE-----

--------------enig60C96A0097810C41B51DB757--
