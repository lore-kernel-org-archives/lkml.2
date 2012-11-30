Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673Ab2K3Urj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 15:47:39 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50333 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186Ab2K3Urh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:47:37 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: "Andrianov\, Vitaly" <vitalya@ti.com>,
        "m.szyprowski\@samsung.com" <m.szyprowski@samsung.com>,
        "kyungmin.park\@samsung.com" <kyungmin.park@samsung.com>,
        "arnd\@arndb.de" <arnd@arndb.de>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-keystone\@list.ti.com - Linux developers for Keystone family of
	devices \(May contain non-TIers\)" <linux-keystone@list.ti.com>
Cc: "Chemparathy\, Cyril" <cyril@ti.com>
Subject: RE: [PATCH] drivers: cma: fix addressing on PAE machines
In-Reply-To: <C279DA448D408F43B343F09155C1EE9B0C223C7E@DFLE09.ent.ti.com>
Organization: http://mina86.com/
References: <1354280283-28365-1-git-send-email-vitalya@ti.com> <xa1tk3t36sq4.fsf@mina86.com> <C279DA448D408F43B343F09155C1EE9B0C223C7E@DFLE09.ent.ti.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Fri, 30 Nov 2012 21:47:29 +0100
Message-ID: <xa1t7gp27r8e.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

>> On Fri, Nov 30 2012, Vitaly Andrianov <vitalya@ti.com> wrote:
>> > This patch fixes a couple of bugs that otherwise impair CMA
>> > functionality on PAE machines:
>> >
>> >   - alignment must be a 64-bit type when running on systems with 64-
>> bit
>> >     physical addresses.  If this is not the case, the limit
>> calculation thunks
>> >     allocations down to an address range < 4G.
>> >
>> >   - The allocated range check is removed. On 32bit ARM kernel with
>> LPAE
>> >     enabled the base may be allocated outside the fist 4GB of
>> physical
>> >     memory (keystone SoC for example).
>> >
>> > Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
>> > Signed-off-by: Cyril Chemparathy <cyril@ti.com>
>>=20
>> To be consistent, you should also change the type in:
>>=20
>> static long size_cmdline =3D -1;
>> static const unsigned long size_bytes =3D CMA_SIZE_MBYTES * SZ_1M; static
>> unsigned long __init __maybe_unused cma_early_percent_memory(void)
>>=20
>> and in
>>=20
>> void __init dma_contiguous_reserve(phys_addr_t limit)

On Fri, Nov 30 2012, Andrianov, Vitaly wrote:
> Can you elaborate why we need to change type for size?=20

Like I've wrote, for consistency.  The size should use the same type as
alignment.  This most likely won't affect the way you use the code, but
it's the right thing to do.  It should be done that way from the start,
so it's really my mistake, but since you are touching the code, it'd
best to have the changes contained in a single commit.  Alternatively
I can just send my own patch with all those fixes (including yours).

>> > diff --git a/drivers/base/dma-contiguous.c
>> > b/drivers/base/dma-contiguous.c index 9a14694..7936b2e 100644
>> > --- a/drivers/base/dma-contiguous.c
>> > +++ b/drivers/base/dma-contiguous.c
>> > @@ -234,7 +234,7 @@ int __init dma_declare_contiguous(struct device
>> *dev, unsigned long size,
>> >  				  phys_addr_t base, phys_addr_t limit)  {
>> >  	struct cma_reserved *r =3D &cma_reserved[cma_reserved_count];
>> > -	unsigned long alignment;
>> > +	phys_addr_t alignment;
>> >
>> >  	pr_debug("%s(size %lx, base %08lx, limit %08lx)\n", __func__,
>> >  		 (unsigned long)size, (unsigned long)base, @@ -271,10 +271,6
>> @@ int
>> > __init dma_declare_contiguous(struct device *dev, unsigned long size,
>> >  		if (!addr) {
>> >  			base =3D -ENOMEM;
>> >  			goto err;
>> > -		} else if (addr + size > ~(unsigned long)0) {
>> > -			memblock_free(addr, size);
>> > -			base =3D -EINVAL;
>> > -			goto err;
>> >  		} else {
>> >  			base =3D addr;
>> >  		}

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQuRthAAoJECBgQBJQdR/0x7gQAIZpOLg6e7SawrQl81mNMXHc
9WtXshQ1wYPhCgQALBS93qCd0THk7NtrM0QSKxDboXopMx5fJMW3WjdGElBZBoZk
gN5shmH/uoFG7tHrNRsGZMn8U9O+N8wTZ3od2yzkyDSVum+0yzvnAMjTxTB0xrVO
cNW9vMMQedqQ5VidGgVhWPntBike4EjjIlPyDQaShS+/ZO05lk+4tmsmrz55V/79
nz5AFMoJl3Lz27owgkBb6jinn+oqegaB6fJIPZNmmyepU3PKI1TvGdYzgd3lApzg
VdHq9ekAfMwfsANDPolpj+rcIbV57o+MpyEL8pK1WArfs4t6nrTWWuLXGM5pDobn
N+CA0CBldJ6YpulJAC2FemHAbo2JMUbHS80brNOTsorOtNhg2SBBjBCGYb7Yjkly
zjlzwrteVFnK5ambmSvk2upN2tTyxYVf2cDydW0BqbC3Vqw/iYmv6jub1NKyxj0p
uCbcLabZ0qM1ed+5k9cld+rM5aYuHU9TI8W5YSALmqYX//Xr4MPi80iC823CNaxZ
Bx4dUoIBxCAwaI0rzxfFeZ+haNaf74GwZzEd1hT1di75OAKUxySGFC7etlAbzvjG
XcOyR3KxrfOkqx2urUoPsLB8Yzy5Ft63WPcIQwERfHPHIJvEbNKWD3+E605FE0dJ
seuOSI24LPUXP1wUbVYs
=a1kp
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
