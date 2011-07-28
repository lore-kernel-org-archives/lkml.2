Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab1G1BRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 21:17:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50457 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab1G1BR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 21:17:26 -0400
Date: Thu, 28 Jul 2011 11:17:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Takashi Iwai <tiwai@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: Re: Build regressions/improvements in v3.0-rc7 (sound/isa/)
Message-Id: <20110728111709.8303f78c9b5f2b3aa3f391b0@canb.auug.org.au>
In-Reply-To: <20110727121320.f50b1e6b.rdunlap@xenotime.net>
References: <1310585610-434-1-git-send-email-geert@linux-m68k.org>
	<20110724122624.324d10dc.rdunlap@xenotime.net>
	<s5hy5zm3j5a.wl%tiwai@suse.de>
	<20110725091003.c3453b8b.rdunlap@xenotime.net>
	<20110727121320.f50b1e6b.rdunlap@xenotime.net>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_Jul_2011_11_17_09_+1000_18mNXdozpR74Xn4Q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Jul_2011_11_17_09_+1000_18mNXdozpR74Xn4Q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Wed, 27 Jul 2011 12:13:20 -0700 Randy Dunlap <rdunlap@xenotime.net> wrot=
e:
>
> On Mon, 25 Jul 2011 09:10:03 -0700 Randy Dunlap wrote:
>=20
> > On Mon, 25 Jul 2011 09:37:53 +0200 Takashi Iwai wrote:
> >=20
> > > At Sun, 24 Jul 2011 12:26:24 -0700,
> > > Randy Dunlap wrote:
> > > >=20
> > > > On Wed, 13 Jul 2011 21:33:30 +0200 Geert Uytterhoeven wrote:
> > > >=20
> > > > >   + src/sound/isa/ad1816a/ad1816a_lib.c: error: implicit declarat=
ion of function 'snd_dma_disable':  =3D> 544
> > > > >   + src/sound/isa/ad1816a/ad1816a_lib.c: error: implicit declarat=
ion of function 'snd_dma_pointer':  =3D> 302
> > > > >   + src/sound/isa/ad1816a/ad1816a_lib.c: error: implicit declarat=
ion of function 'snd_dma_program':  =3D> 244
> > > > >   + src/sound/isa/es1688/es1688_lib.c: error: implicit declaratio=
n of function 'snd_dma_pointer':  =3D> 509
> > > > >   + src/sound/isa/es1688/es1688_lib.c: error: implicit declaratio=
n of function 'snd_dma_program':  =3D> 417
> > > > >   + src/sound/isa/gus/gus_dma.c: error: implicit declaration of f=
unction 'snd_dma_disable':  =3D> 177
> > > > >   + src/sound/isa/gus/gus_dma.c: error: implicit declaration of f=
unction 'snd_dma_program':  =3D> 79
> > > > >   + src/sound/isa/gus/gus_pcm.c: error: implicit declaration of f=
unction 'snd_dma_pointer':  =3D> 619
> > > > >   + src/sound/isa/gus/gus_pcm.c: error: implicit declaration of f=
unction 'snd_dma_program':  =3D> 591
> > > > >   + src/sound/isa/sb/sb16_main.c: error: implicit declaration of =
function 'snd_dma_pointer':  =3D> 456
> > > > >   + src/sound/isa/sb/sb16_main.c: error: implicit declaration of =
function 'snd_dma_program':  =3D> 276
> > > > >   + src/sound/isa/sb/sb8_main.c: error: implicit declaration of f=
unction 'snd_dma_pointer':  =3D> 425
> > > > >   + src/sound/isa/sb/sb8_main.c: error: implicit declaration of f=
unction 'snd_dma_program':  =3D> 172
> > > > >   + src/sound/isa/sscape.c: error: implicit declaration of functi=
on 'snd_dma_program':  =3D> 481
> > > > >   + src/sound/isa/wss/wss_lib.c: error: implicit declaration of f=
unction 'snd_dma_disable':  =3D> 1695
> > > > >   + src/sound/isa/wss/wss_lib.c: error: implicit declaration of f=
unction 'snd_dma_pointer':  =3D> 1160
> > > > >   + src/sound/isa/wss/wss_lib.c: error: implicit declaration of f=
unction 'snd_dma_program':  =3D> 1025
> > > >=20
> > > > All of these source files do #include <sound/core.h>,
> > > > but these missing/implicit functions are conditional:
> > > >=20
> > > > #ifdef CONFIG_ISA_DMA_API
> > > > #define DMA_MODE_NO_ENABLE	0x0100
> > > >=20
> > > > void snd_dma_program(unsigned long dma, unsigned long addr, unsigne=
d int size, unsigned short mode);
> > > > void snd_dma_disable(unsigned long dma);
> > > > unsigned int snd_dma_pointer(unsigned long dma, unsigned int size);
> > > > #endif
> > > >=20
> > > > so should these drivers all depend on ISA_DMA_API ?
> > >=20
> > > Yes, these are ISA sound cards, so they must have CONFIG_ISA and
> > > CONFIG_ISA_DMA.  Although CONFIG_SND_SB8_DSP, CONFIG_SND_SB16_DSP
> > > and CONFIG_SND_WSS_LIB have no direct dependency, but the drivers
> > > selecting these are all in "if SND_ISA" in sound/isa/Kconfig.
> >=20
> > Hm, yes, they are.
> >=20
> > > > or should only pieces of each driver depend on ISA_DMA_API ?
> > >=20
> > > I wonder which configuration makes it possible.
> > > Did you see a similar problem with randconfig?
> >=20
> > No.  This parisc allmodconfig file from linux-next builds has
> > CONFIG_SND_ISA=3Dy but it does not have CONFIG_ISA_DMA_API enabled.  We=
ird.
> >=20
> > Geert, do you know how this happens?
> >=20
> > parisc config:  http://kisskb.ellerman.id.au/kisskb/buildresult/4323458=
/config/
> > from this failed build:  http://kisskb.ellerman.id.au/kisskb/buildresul=
t/4323458/
>=20
> How is CONFIG_ISA_DMA_API enabled in parisc allmodconfig?
> I don't see how that happens, and it's causing build errors...

Sorry, but I don't understand the question.  The problam is that
CONFIG_ISA_DMA_API is not enabled, right?  On parisc, it is just (from
arch/parisc/Kconfig)

config ISA_DMA_API
	bool

and nothing selects it.  However, I would have expected an allmodconfig
to set it to y.  Clearly I don't understan how allmodconfig works any
more :-(

Michal, is my understanding correct?  Is this a bug in allmodconfig?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__28_Jul_2011_11_17_09_+1000_18mNXdozpR74Xn4Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOMLiVAAoJEDMEi1NhKgbsJvQH/19hqB3HBqp9ks74jiuvNK7R
ClA99qR6uCG0UH4bjJujn3R2XeXpGzrgt67+nBl4D7EJtPaZJVi474nSwrZjyWa3
CstKqU2WT66fgOWezNV1ZjWsGy6gA7o1AQ1uz/mZegjSxweWc77pIhcQ+X3wCvQH
uEOabmrNSviDidQPi2lt21d2r4noV7idngId/IstsKu5wtyMVDNN9hilRbOq3YuU
dR3CoQpqqYfEIw2ORW9nSgZ1vTZOtb6Yd8pOXzLAzZT//lDDrr+TYEobDZg49GwN
jectT/FONcUh2Y/sy9a907MGeD0f1m64KPEDWrVxBghBF8HLYaAt2m2AqlCWtCY=
=jQ6m
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Jul_2011_11_17_09_+1000_18mNXdozpR74Xn4Q--
