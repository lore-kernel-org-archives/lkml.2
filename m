Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab1JJUmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 16:42:10 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:50249 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1JJUmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 16:42:09 -0400
Date: Mon, 10 Oct 2011 14:42:08 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
cc: "Kristo, Tero" <t-kristo@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv9 03/18] TEMP: OMAP3xxx: hwmod data: add PRM hwmod
In-Reply-To: <4E934D79.4080000@ti.com>
Message-ID: <alpine.DEB.2.00.1110101416530.5205@utopia.booyaka.com>
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com> <1316781986-30642-4-git-send-email-t-kristo@ti.com> <alpine.DEB.2.00.1110101320180.5205@utopia.booyaka.com> <4E934D79.4080000@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="155748971-1016028621-1318278494=:5205"
Content-ID: <alpine.DEB.2.00.1110101429040.5205@utopia.booyaka.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--155748971-1016028621-1318278494=:5205
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.00.1110101429041.5205@utopia.booyaka.com>

Hi Beno=EEt

On Mon, 10 Oct 2011, Cousson, Benoit wrote:

> On 10/10/2011 9:24 PM, Paul Walmsley wrote:
> > On Fri, 23 Sep 2011, Tero Kristo wrote:
> >=20
> > > This patch is temporary until Paul can provide a final version.
> > >=20
> > > Signed-off-by: Tero Kristo<t-kristo@ti.com>
> >=20
> > Here's an updated version of this one.  The one change is that the hwmo=
d's
> > name is now "prm3xxx" to reflect that the register layout of this IP bl=
ock
> > is quite different from its OMAP2 predecessors and OMAP4 successors.
> > This should avoid some of the special-purpose driver probing code.
>=20
> This is not really aligned with the naming convention we've been using so=
 far.
> In both cases, the hwmod should just be named "prm". If a version informa=
tion
> is needed, then it should be added in the revision class field.
>=20
> It will make the device creation even simpler and not dependent of the So=
C
> version.

The problem in this case is that we should be using a completely different=
=20
device driver for the PRM that's in the OMAP3 chips, from the driver used=
=20
for OMAP2 or OMAP4 PRM blocks, due to the completely different register=20
layout.  As far as I know, we haven't yet used the hwmod IP version to=20
probe a different device driver when the version number changes.  There's=
=20
no support for that in the current Linux platform* code, so we'd need=20
special-purpose code for that.

In an ideal world, we'd have an omap_bus, etc., which would include an=20
additional interface version number as part of its driver matching=20
criteria.  Device drivers would then specify which interface version=20
numbers they supported.  The device data would specify that interface=20
version number should be matched.

But as it is right now in the current platform_device/platform_driver=20
based system, we have only the name to match.  We could implement=20
something where we concatenate the existing IP version number onto the=20
hwmod name, and modify the device drivers to use that name.  But that=20
seems like a lot of potential churn in light of a future DT and/or=20
omap_bus migration.

So I'm proposing to use the IP version number field that's in the hwmod=20
data to indicate evolutionary revisions of an IP block -- rather than=20
revolutionary revisions that would require a new driver.  Then, since we=20
use the hwmod name for driver matching, we'd use a different name for=20
radically different IPs.

If it's the "3xxx" that you're objecting to in the name, we could call it=
=20
"prm2" or "prmxyz" - the '3xxx' just seemed like the most logical=20
approach.  The name of the hwmod class in the patch is still "prm", of=20
course.=20

Thoughts?

=2E..

N.B., it's true that by waiting, this problem will presumably go away,=20
with DT, in which the driver matching data would go into the=20
"compatible" string in the DT.

But I guess it would be good to figure out a clean approach in the=20
meantime.


- Paul
--155748971-1016028621-1318278494=:5205--
