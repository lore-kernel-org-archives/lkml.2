Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab0DUBEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 21:04:49 -0400
Received: from bertrand.catalyst.net.nz ([202.78.240.40]:41646 "EHLO
	mail.catalyst.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab0DUBEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 21:04:48 -0400
Subject: Re: IPv6 duplicate address detection erroneously marking address
 as duplicate when a host receives its own multicast packets?
From: Sam Cannell <sam.cannell@catalyst.net.nz>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1271811145.5214.17.camel@spathi>
References: <1271811145.5214.17.camel@spathi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MoNBJ2Uvl9Fq6lZhAY6L"
Organization: Catalyst IT Ltd
Date: Wed, 21 Apr 2010 13:03:18 +1200
Message-ID: <1271811798.5214.18.camel@spathi>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MoNBJ2Uvl9Fq6lZhAY6L
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry, just realised I forgot to note that this behaviour occurs in
2.6.33.

On Wed, 2010-04-21 at 12:52 +1200, Sam Cannell wrote:
> Hi,
>=20
> I've been having some trouble with ip6 duplicate address detection in a
> Linux VM (under XVM on OpenSolaris).  It seems that the ethernet bridge
> in XVM sends a host's own multicast packets back to it, which the
> duplicate address detection code in linux decide that another host on
> the network is using the same address.
>=20
> For instance, running:
>=20
> router4:~ # ip addr add fe80::216:36ff:fe4e:461c/64 dev eth0
>=20
>=20
> I get the following output in tcpdump:
>=20
> router4:~ # tcpdump -nevpi eth0 ip6=20
> tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 96
> bytes
> 12:33:03.755897 00:16:36:4e:46:1c > 33:33:00:00:00:16, ethertype IPv6
> (0x86dd), length 90: (hlim 1, next-header Options (0) payload length:
> 36) :: > ff02::16: HBH (rtalert: 0x0000) (padn)[icmp6 sum ok] ICMP6,
> multicast listener report v2, length 28, 1 group record(s) [gaddr
> ff02::1:ff4e:461c to_ex, 0 source(s)]
> 12:33:04.551772 00:16:36:4e:46:1c > 33:33:ff:4e:46:1c, ethertype IPv6
> (0x86dd), length 78: (hlim 255, next-header ICMPv6 (58) payload length:
> 24) :: > ff02::1:ff4e:461c: [icmp6 sum ok] ICMP6, neighbor solicitation,
> length 24, who has fe80::216:36ff:fe4e:461c
> 12:33:04.551998 00:16:36:4e:46:1c > 33:33:ff:4e:46:1c, ethertype IPv6
> (0x86dd), length 78: (hlim 255, next-header ICMPv6 (58) payload length:
> 24) :: > ff02::1:ff4e:461c: [icmp6 sum ok] ICMP6, neighbor solicitation,
> length 24, who has fe80::216:36ff:fe4e:461c
> ^C
> 3 packets captured
> 3 packets received by filter
> 0 packets dropped by kernel
>=20
>=20
> And dmesg says:
>=20
> router4:~ # dmesg
> [  371.024287] eth0: IPv6 duplicate address fe80::216:36ff:fe4e:461c
> detected!
>=20
>=20
> And the address sits in 'tentative' mode:
>=20
> router4:~ # ip addr show dev eth0
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast
> state UP qlen 1000
>     link/ether 00:16:36:4e:46:1c brd ff:ff:ff:ff:ff:ff
>     inet 192.168.2.128/24 brd 192.168.2.255 scope global eth0
>     inet6 fe80::216:36ff:fe4e:461c/64 scope link tentative flags 08=20
>        valid_lft forever preferred_lft forever
>=20
>=20
> This happens for link-local and global scope address, both when they try
> to auto-configure and when set by hand:
>=20
> [  463.500328] eth0: IPv6 duplicate address
> 2404:130:0:1000:216:36ff:fe4e:461c detected!
> [  732.428312] eth0: IPv6 duplicate address
> 2404:130:0:1000:216:36ff:fe4e:461c detected!
> [  883.812328] eth0: IPv6 duplicate address 2404:130::3:2:1 detected!
>=20
>=20
> I'd happily put this down to a failing in XVM, however the stateless
> autoconfiguration RFC (4862) states that the stack shouldn't decide an
> address is duplicate based on receipt of a neighbor solicitation message
> that it sent itself:
>=20
> 5.4.3.  Receiving Neighbor Solicitation Messages
> [...]
> If the source address of the Neighbor Solicitation is the unspecified
>    address, the solicitation is from a node performing Duplicate Address
>    Detection.  If the solicitation is from another node, the tentative
>    address is a duplicate and should not be used (by either node).  If
>    the solicitation is from the node itself (because the node loops back
>    multicast packets), the solicitation does not indicate the presence
>    of a duplicate address.
>=20
>=20
> Assuming my understanding of the RFC is correct, this suggests to me that=
 duplicate address detection in Linux is being a little too hasty to mark t=
he address as invalid.  Thoughts?
>=20
>=20
> Thanks,
>=20
> Sam Cannell
>=20
>=20


--=-MoNBJ2Uvl9Fq6lZhAY6L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (SunOS)

iEYEABECAAYFAkvOTtAACgkQcuIanIzWkBLkQQCfTZZ7exc453BjXaqtJdDxsbqE
WMIAnAqg2XcIS87CNy3ozHkvFyO5dnBt
=0cKR
-----END PGP SIGNATURE-----

--=-MoNBJ2Uvl9Fq6lZhAY6L--

