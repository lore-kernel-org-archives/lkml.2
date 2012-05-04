Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab2EDJnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 05:43:17 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:58674 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754150Ab2EDJnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 05:43:14 -0400
Date: Fri, 4 May 2012 12:41:43 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        target-devel@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: Re: linux-next: Tree for Apr 20 (usb & target)
Message-ID: <20120504094141.GC1156@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <20120420155151.3fcac4c2d1002ade5ccf44ac@canb.auug.org.au>
 <4F91D9D9.6020609@xenotime.net>
 <1334999263.30707.129.camel@haakon2.linux-iscsi.org>
 <20120421153402.GA22953@kroah.com>
 <20120422190136.GA31242@linutronix.de>
 <1336102463.22393.121.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
Content-Disposition: inline
In-Reply-To: <1336102463.22393.121.camel@haakon2.linux-iscsi.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, May 03, 2012 at 08:34:23PM -0700, Nicholas A. Bellinger wrote:
> On Sun, 2012-04-22 at 21:01 +0200, Sebastian Andrzej Siewior wrote:
> > * Greg KH | 2012-04-21 08:34:02 [-0700]:
> >=20
> > >> > CONFIG_MODULES is not enabled.
> > >> > CONFIG_TCM_USB_GADGET=3Dy
> > >> > CONFIG_USB_GADGET=3Dy
> > >>=20
> > >> Sebastian + Greg-KH (Cc'ed), any ideas why this is the case here..?
> > >
> > >I have no idea, sorry.
> >=20
> > The short version:
> > in order to fix this either move the usb-target-gadget to
> > drivers/usb/gadget/Kconfig and make sure only one gadget can be compiled
> > at a time or add some kind of depends.
> >=20
> > The longer version:
> > This is a short comming of the gadget framework. We are able to build
> > multiple UDCs at a time and we can build multiple gadgets _as_ modules.
> > Since we can not bind & configure via an interface the whole thing works
> > right now via "modprobe $gadget. There is some infrastructure to accept
> > multiple UDCs/gadget but the *whole* thing is not complete.
> > In non-modules mode you can only select one gadget at a time. With the
> > target gadget living outside of usb/gadget selection it is possible to
> > select both at the same time which causes the duplicate symbols here.
> > A "quick" fix is not to define all the functions static and put
> > maybe_unsued on each function to avoid warnings. This is only duct tape
> > on top and I would prefer that nobody is sending such a patch. The
> > result is hardly usefull by a user.
> > A real fix would to get rid of the "#includes foo.c" and use a helper
> > module/library instead.
> > I tried this once and notice that the whole thing relies on
> > static/global variables which are initialized once on modprobe. So
> > with the second module loaded (read as rmmod $mod1 && modprobe $mod2)
> > the gadget framework explodes. Once I noticed that, the patches got out
> > of Felipe's tree before anyone noticed something. That means we should
> > first get rid of the global variables and then maybe try again :)
> >=20
>=20
> Hey Sebastian & USB folks,
>=20
> So I'm catching up on for-next-merge stuff after being away last week,
> and ended up following your advice to just move tcm_usb_gadget code into
> drivers/usb/gadget/ in to address the legacy requirements above..
>=20
> After the recommended change, the in-kernel config using a single gadget
> driver (the target) are able to build.  Thanks for the detailed
> explanation btw.. ;)
>=20
> I've made the same change for tcm_usb_gadget in lio-core, and updated
> for-next-merge with the following merge patch:
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/nab/target-pending.git;a=3Dco=
mmit;h=3D0c41520201bc0933d65b8644173802778f426234
>=20
> Please let me know if you have any other changes that should go into
> sunday's linux-next build.

It looks ok to me. You can add my Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPo6RVAAoJEIaOsuA1yqRE9i8P/R49Eub5B9FfajNOVFy62md1
X/bXRL2RFP928cQ2lAUZOBuqzn0kgbzqxomwfXKIbyEhlp3XY3cqAJff0oRb1q1P
0LQEyiJh9b6NyD6vX7yHZMVbliM2ELJL7ptkRZAckOoWB7Xf+EfBjTo6TjRdM7E5
Yhjxg/8TjecacJWM5+h7+NI+Jtmv5w0huAQAavJo2Ko+ls/eZZ9JA0CLfvnEj+kq
AbSx+DRIWNXoeJ0/BxsEojIphYefQ58sUiDf815Lv5bwfX7kaPdRFCAIS/hSh9W9
7Bh86brSkGQ8UTT80iZNBGDYKiVI4zxNijhquKekxrHZ/JXzuNb/L/shp5DdtMQ+
PsaMx4yoBSfDknoaOpAiHBRGMNduiPq0/6g21/k3RFI7oRaUxPTgv1VcGa1DWevI
aAcfzxiKck23V+NppTBJJQXSj9G5aGLsFeiZDkQWmn0zgdkTy2nBD5WvzcHJvuMl
9NDyur1E4GSpSjOvEYnEo6DsrHozq4GCFpqfi5dYr+REbKWDNj7C+FI1OrhQk2ja
vJrjdBmYIw0yyCDx7f4ghIFvXYhdXQemRJ4HRBztwCNZjwPgEKSF6U+1jJ3rzs+5
RQhXZlQNZCV+7p1u4om8K7Wqr0xlvxgyIc+R7NN7UwTkv8pRAc6cH+hdgpFGghys
tPPV1SEJeAXNHoh9Q04I
=9R3u
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--
