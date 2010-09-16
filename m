Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab0IPHJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 03:09:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39278 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637Ab0IPHJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 03:09:49 -0400
Date: Thu, 16 Sep 2010 17:09:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (tip
 tree related)
Message-Id: <20100916170939.22e38e4c.sfr@canb.auug.org.au>
In-Reply-To: <20100916063922.GA17596@elte.hu>
References: <20100914002932.850d02f3.sfr@canb.auug.org.au>
	<20100916163218.e09be473.sfr@canb.auug.org.au>
	<20100916063922.GA17596@elte.hu>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Sep_2010_17_09_39_+1000_+hayyUBiuh83yv+C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Sep_2010_17_09_39_+1000_+hayyUBiuh83yv+C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Thu, 16 Sep 2010 08:39:22 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > On Tue, 14 Sep 2010 00:29:32 +1000 Stephen Rothwell <sfr@canb.auug.org.=
au> wrote:
> > >
> > > After merging the final tree, today's linux-next build (arm
> > > assabet_defconfig and serveral other arm configs) failed like this:
> > >=20
> > > arch/arm/mm/init.c: In function 'arm_memory_present':
> > > arch/arm/mm/init.c:260: warning: ISO C90 forbids mixed declarations a=
nd code
> > > arch/arm/mm/init.c:338: error: invalid storage class for function 'fr=
ee_area'
> > > arch/arm/mm/init.c:357: error: invalid storage class for function 'fr=
ee_memmap'
> > > arch/arm/mm/init.c:386: error: invalid storage class for function 'fr=
ee_unused_memmap'
> > > arch/arm/mm/init.c:601: error: invalid storage class for function 'ke=
epinitrd_setup'
> > > arch/arm/mm/init.c:606: error: initializer element is not constant
> > > arch/arm/mm/init.c:606: error: (near initialization for '__setup_keep=
initrd_setup.setup_func')
> > > arch/arm/mm/init.c:606: error: expected declaration or statement at e=
nd of input
> > > arch/arm/mm/init.c:252: warning: unused variable 'i'
> > >=20
> > > Caused by commit 719c1514f2fef5f01fcfa2bba81b7bb079c7c6a1 ("memblock/=
arm:
> > > Use new accessors") which forgot a closing brace on a new
> > > for_each_memblock() in arm_memory_present().
> >=20
> > So this commit is back in tip and the error is back in the builds ...
>=20
> The ARM defconfig build doesnt fail here:
>=20
>   WARNING: modpost: Found 5 section mismatch(es).
>   To see full details build your kernel with:
>   'make CONFIG_DEBUG_SECTION_MISMATCH=3Dy'

This is not a "defconfig" build, it is just some of the other arm
"_defconfig" builds (like the one I specified above - assabet_defconfig).

> Is there some integration artifact here perhaps? If yes then linux-next=20
> needs to resolve the integration artifact. If not then benh, Yinghai,=20
> hpa, please have a look ...

It is clear from the patch that a closing brace was missed (see above) ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Sep_2010_17_09_39_+1000_+hayyUBiuh83yv+C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMkcKzAAoJEDMEi1NhKgbsquEH/3ftHWaAFzsdBXvLmNPXJGj3
dJfGvllGjzC/iIl9hdSl6K73I6cP8bs7ddKtS8gqxfObxuUIuE9GrqHTGkosKbEq
sgzD6vrAeDyWvWAE/mkjZIMcYa5fy6KeVOA5sQEX3gwCHfDbGdsx4Zi4bYvkhbUD
0lETVO1dLdn4KqG4NxNXBRk16JJh/u4b/Ur3q226ck/TI06qXeTDne1SPVnyPRLW
NXxqaVzevIoKtPtcVJ30hA/LThS0tPBqZW1s1LQctsKCVOkLE3LTBNcGBskwtcZl
pbNi0hrHi0P82ZDG3GO7/KMca7XbYQQT/qNMopW2kVziHnd9ovEmdy1a3Aa72Qw=
=VGiX
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Sep_2010_17_09_39_+1000_+hayyUBiuh83yv+C--
