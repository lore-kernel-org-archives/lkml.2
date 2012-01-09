Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab2AIOT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 09:19:57 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057Ab2AIOTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 09:19:55 -0500
Message-ID: <4F0AF77F.6010508@nod.at>
Date: Mon, 09 Jan 2012 15:19:43 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>,
        Thorsten Glaser <tg@mirbsd.de>,
        Debian kernel team <debian-kernel@lists.debian.org>,
        linux-m68k@vger.kernel.org, debian-68k@lists.debian.org
Subject: Re: [PATCH 1/2] topology: Check for missing CPU devices
References: <1326055714.13595.309.camel@deadeye>  <CA+55aFwwnJPpVY++Vgr6p3s47YjdYWV3sgLZzvCtiJp6DEu78Q@mail.gmail.com>  <CAFLxGvwJWrSRSNxHE620XZkc4w0ayzeqqxZOR1efkh1V+VBO1w@mail.gmail.com>  <CA+55aFwVnLE-DLRzS8G=8NxQZjF5M_O4kgrPoX+AOOEH-OZgog@mail.gmail.com> <1326077566.4097.7.camel@deadeye>
In-Reply-To: <1326077566.4097.7.camel@deadeye>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5D607656C9556ACAF6264795"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5D607656C9556ACAF6264795
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 09.01.2012 03:52, schrieb Ben Hutchings:
> On Sun, 2012-01-08 at 17:29 -0800, Linus Torvalds wrote:
>> On Sun, Jan 8, 2012 at 5:06 PM, richard -rw- weinberger
>> <richard.weinberger@gmail.com> wrote:
>>> On Mon, Jan 9, 2012 at 1:18 AM, Linus Torvalds
>>> <torvalds@linux-foundation.org> wrote:
>>>> Ok, both of the patches look sane to me, but it would really be nice=

>>>> to hear from somebody with the actual affected architectures, and ge=
t
>>>> a tested-by.
>>>
>>> UML is affected:
>>> https://lkml.org/lkml/2012/1/8/186
>>>
>>> I wasted an hour finding out why it is crashing.
>>> Instead of testing kernels I really should read more LKML. ;-)
>>
>> Hmm.
>>
>> Ben - how about that
>>
>>   static DEFINE_PER_CPU(struct cpu, cpu_devices);
>>
>> approach that Richard uses in his patch, instead of the kcalloc?
>=20
> That seems perfectly good.
>=20
>> And
>> clearly UM should also do that CONFIG_GENERIC_CPU_DEVICES thing with
>> your patch.
>>
>> Richard - does Ben's patch work for  you too if you just add "select
>> GENERIC_CPU_DEVICES" in the UM Kconfig too (Kconfig.common, probably)?=

>=20

Yeah, Ben's patch solves the problem too. :-)
Ben, please add the attached patch snippet to your patch.

--

diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index a923483..b37ae70 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -8,6 +8,7 @@ config UML
 	default y
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
+	select GENERIC_CPU_DEVICES

 config MMU
 	bool


--------------enig5D607656C9556ACAF6264795
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPCveDAAoJEN9758yqZn9ep3IIALdDqxHIXDb6auvLEnOIMmJI
Mk77iGatNiWl/OxISQE2WDTWF9ZG7LTVyFXvW3pvsC+imc9g0+Soz8g4MMUVEVhJ
7idIYSui+S6Evcs3FL8C174+CxGyQykZ/nxp50GY8vFeHVCnNa6VFvV2Yf/gd3YN
qSEG58aeYA26bm/vRqWZOqemrqcNKoVVsuetnXe6FOtEFh6wVab48Ilf9KFryVPw
YXZbLNSkCsbPdWvW4BX688OpBDQRHYjjPG8A2dqMCaSYhW0wPlRpdGRjGraP5mn4
5MxNkXat5RD7JO9fEfmkhBHCjWT9obnP15b0T3SJjIGvw4StUTgSH6B/LCALWR4=
=yL8o
-----END PGP SIGNATURE-----

--------------enig5D607656C9556ACAF6264795--
