Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab2GaVbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 17:31:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:61917 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab2GaVbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 17:31:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="200635514"
Message-ID: <1343770259.2230.31.camel@jtkirshe-mobl>
Subject: Re: [PATCH] igb: correct hardware type (i210/i211) check in
 igb_loopback_test()
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Jesper Juhl <jj@chaosbits.net>
Cc: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "Pieper, Jeffrey E" <jeffrey.e.pieper@intel.com>,
        Rick Jones <rick.jones2@hp.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>
Date: Tue, 31 Jul 2012 14:30:59 -0700
In-Reply-To: <alpine.LNX.2.00.1207312315310.7100@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1207252059320.11754@swampdragon.chaosbits.net>
	  <9BBC4E0CF881AA4299206E2E1412B62630D64753@ORSMSX102.amr.corp.intel.com>
	  <alpine.LNX.2.00.1207312219080.7100@swampdragon.chaosbits.net>
	 <1343769121.2230.28.camel@jtkirshe-mobl>
	 <alpine.LNX.2.00.1207312315310.7100@swampdragon.chaosbits.net>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-0xCSi6bLF8NmR8ZdBm5a"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0xCSi6bLF8NmR8ZdBm5a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-07-31 at 23:19 +0200, Jesper Juhl wrote:
> On Tue, 31 Jul 2012, Jeff Kirsher wrote:
>=20
> > On Tue, 2012-07-31 at 22:23 +0200, Jesper Juhl wrote:
> > > On Wed, 25 Jul 2012, Wyborny, Carolyn wrote:
> > >=20
> > > >=20
> > > > > -----Original Message-----
> > > > > From: Jesper Juhl [mailto:jj@chaosbits.net]=20
> > > > > Sent: Wednesday, July 25, 2012 12:06 PM
> > > > > To: linux-kernel@vger.kernel.org
> > > > > Cc: netdev@vger.kernel.org; e1000-devel@lists.sourceforge.net;
> > > Wyborny, Carolyn; Pieper, Jeffrey E; Kirsher, Jeffrey T; Rick Jones;
> > > Ronciak, John; Brandeburg, Jesse; Allan, Bruce W; Skidmore, Donald C;
> > > Rose, Gregory V; Waskiewicz Jr, Peter P; Duyck, Alexander H; David S.
> > > Miller
> > > > > Subject: [PATCH] igb: correct hardware type (i210/i211) check in
> > > igb_loopback_test()
> > > > >=20
> > > > > In the original code
> > > > > ...
> > > > >     if ((adapter->hw.mac.type =3D=3D e1000_i210)
> > > > >             || (adapter->hw.mac.type =3D=3D e1000_i210)) { ...
> > > > > the second check of 'adapter->hw.mac.type' is pointless since it
> > > tests for the exact same value as the first.
> > > > >=20
> > > > > After reading through a few other parts of the driver I believe
> > > that the second check was actually intended to check for 'e1000_i211'
> > > > > rather than 'e1000_i210', but I admit that I'm not certain so
> > > someone with more knowledge about this driver should ACK the patch
> > > before it gets merged.
> > > > >=20
> > > > > Unfortunately I have no hardware to actually test this on, so it
> > > is compile tested only.
> > > > >=20
> > > > > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > > > > ---
> > > > >  drivers/net/ethernet/intel/igb/igb_ethtool.c | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >=20
> > > > > diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> > > b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> > > > > index a19c84c..ad489b7 100644
> > > > > --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> > > > > +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> > > > > @@ -1783,7 +1783,7 @@ static int igb_loopback_test(struct
> > > igb_adapter *adapter, u64 *data)
> > > > >             goto out;
> > > > >     }
> > > > >     if ((adapter->hw.mac.type =3D=3D e1000_i210)
> > > > > -           || (adapter->hw.mac.type =3D=3D e1000_i210)) {
> > > > > +           || (adapter->hw.mac.type =3D=3D e1000_i211)) {
> > > > >             dev_err(&adapter->pdev->dev,
> > > > >                     "Loopback test not supported "
> > > > >                     "on this part at this time.\n");
> > > > > --
> > > > > 1.7.11.3
> > > > >=20
> > > >=20
> > > > ACK.
> > > >=20
> > > > Good catch.  Thanks Jesper!
> > > >=20
> > > > Carolyn
> > > >=20
> > > > Carolyn Wyborny
> > > > Linux Development
> > > > LAN Access Division
> > > > Intel Corporation
> > > >=20
> > > Thank you for the ack Carolyn.
> > >=20
> > > David: will you take this in the networking tree?=20
> >=20
> > I have a few igb patches already, so I will send a pull request for Dav=
e
> > with this patch added to the igb patches I already have.  Ok?
> >=20
> That's perfectly fine with me.
>=20
> Perhaps you could consider also picking up the other one I sent a few=20
> minutes after this one ?
>   Subject: [PATCH] igb: don't break user visible strings over multiple li=
nes in igb_ethtool.c
>   Message-ID: <alpine.LNX.2.00.1207252115321.11754@swampdragon.chaosbits.=
net>

Done.

--=-0xCSi6bLF8NmR8ZdBm5a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQGE6TAAoJEOVv75VaS+3Ohy0P/0bCz4lHjI8mkaTX6SCr+yuh
FikfmhCa6FKg0Kqm56yO6dOzApQcUR3CFiXl3m6LRIPMBfdKBdP/LFLwCPPmAfKH
fPX1gEfeV80mp04MT46GxmK0WPVUeODnBj/FNsTHtcosnupCzu4tZ1VxocDv7Ora
VHGsC6aFXl9b1l4w8e30RxzwRa0xDeM0EP9v2g/+ObE7/OD1pOHv1U4sZ3sjJwNI
t0hMw4ECf73D0RQwSvNVn07HbW8Qqvh9vaq+GiOcXoD62jQoFehQuNi9q3gR2S4S
cArDbsRHN46yWRPGWwzOJgtUQslFCD0jEIyNKMMUnGAz30N+DN49SE4P9XukKqfo
5y5Tr9gTdSocKnrwFKo4WLzksNtmVDQPX0cwWu4J4pqeysg/XQD51W0gDujqjcRw
x/W2N6Ik9wGJ7wSZtPCRLibuOvkCtg7HmjWqk1nqMzsuYhQcWqI05DEVKsD9AdUV
YWOvYPzEOGnZx9jELzPm2wLYspuInD2WV0uHjoDkMsJu5SBy3sl2oZCw4Lwootka
g59dy2R2vHejQQHmidsLU4r9JZD7QW9d09xpwW/UoZBKDPoJNhm9KIYVCpneyHEu
TXLfTAryegF/eQjj7ihs9T/58YxNM4vXegNR7YWSmCLlSSDtM27SPU0wujOhKoww
WZ9HKUhi9A2lN+7LsdeI
=l3/m
-----END PGP SIGNATURE-----

--=-0xCSi6bLF8NmR8ZdBm5a--

