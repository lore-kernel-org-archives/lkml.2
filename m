Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990Ab2DKQD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:03:26 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:58102 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759593Ab2DKQDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:03:25 -0400
Date: Wed, 11 Apr 2012 09:03:18 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Michel =?UTF-8?B?RMOkbnplcg==?= <michel@daenzer.net>
Cc: Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>, dri-devel@lists.freedesktop.org
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
Message-ID: <20120411090318.121a6d6b@jbarnes-desktop>
In-Reply-To: <1334125762.31776.4.camel@thor.local>
References: <4F717CE3.4040206@suse.cz>
	<4F717D80.9040207@suse.cz>
	<4F758400.3080907@suse.cz>
	<1333104359_155028@CP5-2952>
	<20120409101119.47e770b2@jbarnes-desktop>
	<4F83F3B5.8080704@suse.cz>
	<20120410092619.26a15165@jbarnes-desktop>
	<4F8477D1.4080102@suse.cz>
	<20120410113448.540e4c1d@jbarnes-desktop>
	<1334125762.31776.4.camel@thor.local>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xm_mHT.Nj.fNs1qNZd6cPgC"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/xm_mHT.Nj.fNs1qNZd6cPgC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Apr 2012 08:29:22 +0200
Michel D=C3=A4nzer <michel@daenzer.net> wrote:

> On Die, 2012-04-10 at 11:34 -0700, Jesse Barnes wrote:=20
> > On Tue, 10 Apr 2012 20:11:29 +0200
> > Jiri Slaby <jslaby@suse.cz> wrote:
> >=20
> > > On 04/10/2012 06:26 PM, Jesse Barnes wrote:
> > > > So port hotplug is always reporting that port C has a hotplug
> > > > interrupt though...  If you write 0x3 back to it does the interrupt
> > > > stop?
> > >=20
> > > I'm not sure I got it right. This doesn't help:
> > > --- a/drivers/gpu/drm/i915/i915_irq.c
> > > +++ b/drivers/gpu/drm/i915/i915_irq.c
> > > @@ -1416,6 +1416,17 @@ static irqreturn_t
> > > i915_driver_irq_handler(DRM_IRQ_ARGS)
> > >                 iir =3D new_iir;
> > >         }
> > >=20
> > > +       if (ret =3D=3D IRQ_NONE) {
> > > +               u32 hp =3D I915_READ(PORT_HOTPLUG_STAT);
> > > +               if (hp) {
> > > +                       I915_WRITE(PORT_HOTPLUG_STAT, hp);
> > > +                       I915_READ(PORT_HOTPLUG_STAT);
> > > +               }
> > > +
> > > +               if (printk_ratelimit())
> > > +                       printk(KERN_DEBUG "%s: %.8x\n", __func__, hp);
> > > +
> > > +       }
> > >=20
> > >         return ret;
> > >  }
> >=20
> > Yeah that looks right, you still get 0x300?
>=20
> You said 'If you write 0x3 back' above, but this code writes 0x300.
> Which is right?

0x300 is right, the bits are status bits with write 1 to clear
semantics.  But it looks like this one is just stuck high (probably
because port C isn't actually wired up fully).

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/xm_mHT.Nj.fNs1qNZd6cPgC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhatGAAoJEIEoDkX4Qk9haGIP/3vCZdlfo2BauTYnzk+/Spr/
HWs+o/5r02cIgCNTjoOJnr9hPW4xdKlnhni+n7wpCMe7D+4emxbc7Q/x5TP2GzHs
VTdTK1rL+/nFIMLyv5vv0WzSM8841C43uFSJavcJPhx0Vfwq5XmwtTt8UPC94F2c
mBhyujKk4xhW+htDpDIdR1uziiscNkNtXZBO1pkmpUmcDmMMFu3TiiQdryXGCyEs
HaWMZHJMwNz0uo3wvasPVz0paM+bmmREd8oV5FVbzJAPJzJ0ATvsqdW1LPzLHuNU
aFbgQhDRFc5kRWCYCmGR1fZ+HqF4f8HOHjEg85IqsnQoND5T3knOa6Xfi53IJa82
G0mvqBzr/GvbJ6PrHriWFVKKp3URxfFslv2Q7OCuConWeuX5mkWFqG3xwn03yJ6T
qc281D5wXN5cCp3mmDo4J62eECgjnFElcNJLG46wpGEIs+HBHl9AGVyZ27dW/GdZ
p+NDz7BA2OI2AK+A95czfn8PsTLhzYLc+mLmQN6v1YIAkz7LZSVs6XiciaFG8kNZ
B3Zx7boDySktzfGS9tPf1V5/hLPHwrwp88aL7RP0Efeu5771jHBLH6zXwb4TfKXX
bVs9OfQg3pZblvZsHIYpCKJXL6Ph3S7bbsi3EFmFBMay7i9lh3NMPe21PbC3SGpW
auijYA6vz6SaRlvFKrUA
=fLpB
-----END PGP SIGNATURE-----

--Sig_/xm_mHT.Nj.fNs1qNZd6cPgC--
