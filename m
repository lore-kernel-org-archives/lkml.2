Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab2DYK3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 06:29:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43553 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757111Ab2DYK3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 06:29:10 -0400
Date: Wed, 25 Apr 2012 20:29:02 +1000
From: NeilBrown <neilb@suse.de>
To: balbi@ti.com
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 6/6] twl4030-usb: Don't report EVENT_ID when there is
 VBUS.
Message-ID: <20120425202902.05890cca@notabene.brown>
In-Reply-To: <20120425080526.GA3777@arwen.pp.htv.fi>
References: <20120425072931.20124.56635.stgit@notabene.brown>
	<20120425073311.20124.58619.stgit@notabene.brown>
	<20120425080526.GA3777@arwen.pp.htv.fi>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OpguYR6x=Dedfco+oUfOsjx"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/OpguYR6x=Dedfco+oUfOsjx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Apr 2012 11:05:27 +0300 Felipe Balbi <balbi@ti.com> wrote:

> Hi,
>=20
> On Wed, Apr 25, 2012 at 05:33:11PM +1000, NeilBrown wrote:
> > Some USB chargers tie the ID pin low via various resistors.
> > So they can cause VBUS to be high and ID to be low.
> >=20
> > The 'A' end of an OTG cable never receives VBUS, it only ever generates=
 it.
>=20
> this isn't entirely true. Have you considered Accessory Charger
> Adapters ?

I confess that I probably did get lost amid the maze of twisty standards -
all different.

Looking at http://en.wikipedia.org/wiki/USB_On-The-Go

it seems that a USB Accessory Charger Adapter can present 3 states includin=
g:

   A charger and a B-device are attached. The OTG device is allowed to char=
ge
   and enter host mode.

which would mean that the TWL4030 would see that A end of an OTG cable, and
VBUS asserted.

However that appears to be selected if the ID resistance is 36.5Kohms, while
others are selected for 68Kohm and 124Kohm.
But the twl4030 cannot detect that distinction.  The cut-offs are
  Ground,  102K,  200K,  440K,  Floating

so it seems this is a standard that post-dates TWL4030.  It also seems to be
specific to OTG Micro plugs, and I have an OTG Mini plug (does TWL4030
support Micro plugs? Does it care?)

>=20
> > So if we see VBUS and are not generating it, this must be a charger,
> > not the A end of an OTG cable, so in that case, ignore the fact that
> > ID is low.
>=20
> wrong.
>=20

That may well be.  However we need some way to tell twl4030_charger.c
either USB_EVENT_VBUS or USB_EVENT_CHARGER when a charger is plugged in.
I guess we could just punt to user-space: provide all the measurements
through sysfs and allow user-space to enable the charger and select the
desired current?

Or should this just go in the too-hard basket for now?


Thanks,
NeilBrown


--Sig_/OpguYR6x=Dedfco+oUfOsjx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5fR7jnsnt1WYoG5AQJqGhAAsrtkkJyfHpybbxenpUpN/81xbKn4sSh6
HBVj7u5j0OVKaEoMUwKPFkur7cBBphISQf/XcX9j8UrU6C0hc6YZcC2Vz3sRpU34
QeUA2PSdzixCtbArilb7S7SdSO+HObxLe2sz3N3JCZGz3DfhDdFGlMhnqWzGzyrm
rO7rdMGvs+3UTkZPdIF7C+ZHNEsMj9iZxvFfCyvtNBmhtvrxrXf5Vo2jcIoxnjYG
4AYjAgy+h/OXMuGEs1ZF1RSkS8DKYldKaHvHRX2TuEfkz/kF80jBDJ9NWDkKr+ef
35GYiuxfTwS1XIEW0oyQm8W8dTTrOX2NCf7+fPcPTWJ9/mLewdVXU7YSwwcuIKUR
BarerCJNQXh8pupGzd+7Abmm1to1vjJ6PrKEIVtcwSnoG/rbPDUNdMTyGPuO6SUg
M2xlpK1IOBXRIUK+L0X76m1hnNYRDyZBovgMm23GqC+6FpgWQ6tuGB+1FcPvnNKw
z1uEilrmJ6VPQw+wmGItjmEKhWfBYpf7rHm5QfvfyOLi+C9FQQwXm4L8g2ZssWjv
DFywfP3KVCtu48tuSmmS5lT9IMt0Rqmc84+xsT5D4d3H6eiQWwgfH6zPy4jfN2wo
C9CjwJpu4j4ZgM3kt82LEc5/CDsWr3wwZycPH+b5qOBLT951lSo89NUhkdgy1J/q
mOqIwvefQCA=
=z91q
-----END PGP SIGNATURE-----

--Sig_/OpguYR6x=Dedfco+oUfOsjx--
