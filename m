Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab0GVHX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 03:23:57 -0400
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:42024 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752004Ab0GVHXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 03:23:55 -0400
X-Greylist: delayed 695 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jul 2010 03:23:55 EDT
From: Ian Campbell <ijc@hellion.org.uk>
To: David Miller <davem@davemloft.net>
Cc: gregory.v.rose@intel.com, leedom@chelsio.com, shemminger@vyatta.com,
        andy@greyhouse.net, harald@redhat.com, bhutchings@solarflare.com,
        sassmann@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gospo@redhat.com,
        alexander.h.duyck@intel.com
In-Reply-To: <20100721.123324.237334251.davem@davemloft.net>
References: <20100721.114851.200597269.davem@davemloft.net>
	 <20100721.115023.69942880.davem@davemloft.net>
	 <43F901BD926A4E43B106BF17856F0755F1846247@orsmsx508.amr.corp.intel.com>
	 <20100721.123324.237334251.davem@davemloft.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rOsVGoJeHDpnXys+MrKX"
Date: Thu, 22 Jul 2010 08:12:07 +0100
Message-ID: <1279782727.13417.198.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
X-SA-Exim-Connect-IP: 192.168.1.7
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH net-next] sysfs: add entry to indicate network
 interfaces with random MAC address
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=4QByPj+6Iq2k/6L54d+eVKTdgQxdscpRskJJReCfdXo= c=1 sm=0 a=RDfjDOL2Cn0A:10 a=QyXUC8HyAAAA:8 a=J1Y8HTJGAAAA:8 a=KqkpAJVTuq6RUB2taQ4A:9 a=4PSPb-VWQW0ZTU95Qc0A:7 a=O1Aq2qvEMWj0YtftdXfQwEQT03kA:4 a=wPNLvfGTeEIA:10 a=dGJ0OcVc7YAA:10 a=4N9Db7Z2_RYA:10 a=ndGRI7Y2c1IfLjVE:21 a=eR4nMBmkN17OczYm:21 a=OqbPO-30fQY-8ycwAicA:9 a=HpWx1HoX1d4ew29C6r9ghzSq8G8A:4 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rOsVGoJeHDpnXys+MrKX
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-07-21 at 12:33 -0700, David Miller wrote:
> From: "Rose, Gregory V" <gregory.v.rose@intel.com>
> Date: Wed, 21 Jul 2010 12:02:17 -0700
>=20
> >>From: David Miller <davem@davemloft.net>
> >>Date: Wed, 21 Jul 2010 11:48:51 -0700 (PDT)
> >>
> >>> You could do things like have the PF controller use the root
> >>filesystem
> >>> ID label to construct the VF's MAC address, or something like that.
> >>
> >>And here I of course mean the root filesystem of the guest the VF will
> >>be given to.
> >=20
> > I suppose you could do that but then the VM is going to have to be
> > allowed to set its own MAC address.  There is a lot of opposition
> > and concern about allowing VMs to set their own MAC address.
>=20
> Why would that be necessary?  The host with the PF creating the guest
> has access to the "device" and thus the root filesystem of the guest,
> and thus could pull in the root filesystem "key" and instantiate the
> VF's MAC before booting the guest.

Most VM host toolstacks allow you to store a MAC address for each
virtual NIC in the metadata associated with the VM. This MAC address is
either given by the user when they create the virtual NIC, random with
locally administered bit set or random in the VM vendors OID space. This
ensures the VM configuration remains consistent with time.

Why would they not continue to do the same for SR-IOV passthrough NICs?

As a fallback some toolstacks will generate a random address if the NIC
configuration doesn't specify one but if you want a persistent address
for a guest why would you not just configure it that way? Accessing the
guest root filesystem might be a nicer fallback than random generation
when users haven't explicitly configured a MAC but isn't there a chance
of a VM admin controlling the MAC address by manipulating the root
filesystem? What do you do if there is an address clash in this case,
relabelling the root filesystem is a bit of a faff. Also the root
filesystem could be contained within an LVM volume or encrypted or
whatever.

Ian.
--=20
Ian Campbell

Military intelligence is a contradiction in terms.
		-- Groucho Marx

--=-rOsVGoJeHDpnXys+MrKX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkxH70cACgkQM0+0qS9rzVm5XwCfc2PEnB+Ilmu7tBtwEhazzvNq
SgAAoL2ZZD0fAAsgNt+FXiL+lf49fIsw
=dlid
-----END PGP SIGNATURE-----

--=-rOsVGoJeHDpnXys+MrKX--

