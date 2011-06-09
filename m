Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1FIRB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 13:01:29 -0400
Received: from home.keithp.com ([63.227.221.253]:57055 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab1FIRB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 13:01:26 -0400
From: Keith Packard <keithp@keithp.com>
To: Johan Hedberg <johan.hedberg@gmail.com>, Waldemar.Rymarkiewicz@tieto.com
Cc: padovan@profusion.mobi, marcel@holtmann.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Regression caused by "Bluetooth: Map sec_level to link key requirements"
In-Reply-To: <20110609083345.GA2894@dell.ccr.corp.intel.com>
References: <yunboy7a2so.fsf@aiko.keithp.com> <99B09243E1A5DA4898CDD8B700111448175AA2DB2A@EXMB04.eu.tieto.com> <20110609083345.GA2894@dell.ccr.corp.intel.com>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 09 Jun 2011 10:01:17 -0700
Message-ID: <yuny61b3pnm.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 9 Jun 2011 17:33:45 +0900, Johan Hedberg <johan.hedberg@gmail.com> =
wrote:

> The patch was not only fine but actually *needed* by the BITE. So
> reverting it will make some qualification tests fail.

Yeah, it seemed pretty obvious that the patch added some useful security
checks.

> There's no DUN support in the N900 by default and the only package I'm
> aware that provides it uses the command line rfcomm tool with high
> security on the socket to block just-works SSP pairing (since the rfcomm
> tool doesn't use the authorization framework to guarantee a user pop-up
> dialog). The SyncML code I can't comment on since I haven't seen it.

Service Name: Dial-Up Networking
Service RecHandle: 0x10000
Service Class ID List:
  "Dialup Networking" (0x1103)
  "Generic Networking" (0x1201)
Protocol Descriptor List:
  "L2CAP" (0x0100)
  "RFCOMM" (0x0003)
    Channel: 1
Profile Descriptor List:
  "Dialup Networking" (0x1103)
    Version: 0x0100

> So potentially this might be limited to high security sockets.
> Speculating further, if the device connecting to the N900 has a pre-2.1
> Bluetooth controller this could simply be about not having a 16-digit
> PIN which high security services require.

> So could whoever is able to
> reproduce the issue try repairing and entering a 16-digit PIN to see if
> the problem goes away?

I re-pair'ed using a manually entered a 16 digit pin, but now DUN setup
doesn't succeed at all.

> And if this is in fact the case then the kernel
> code is working exactly as it should; the only issue is that these
> services should really be using medium security level instead of high.

I cannot figure out how to reconfigure things so that they work again.

> hcidump -Rt > foo.log  from your test session will help as well

here's a dump of trying to start the syncml session:

HCI sniffer - Bluetooth packet analyzer ver 2.0
device: hci0 snap_len: 1028 filter: 0xffffffff
2011-06-09 09:36:27.729606 < 01 05 04 0D 6E F5 C1 5B 9B EC 18 CC 02 00 00 0=
0 01=20
2011-06-09 09:36:27.731045 > 04 0F 04 00 01 05 04=20
2011-06-09 09:36:28.281075 > 04 12 08 00 6E F5 C1 5B 9B EC 01=20
2011-06-09 09:36:28.435069 > 04 03 0B 00 0C 00 6E F5 C1 5B 9B EC 01 00=20
2011-06-09 09:36:28.435115 < 01 1B 04 02 0C 00=20
2011-06-09 09:36:28.437015 > 04 1B 03 0C 00 05=20
2011-06-09 09:36:28.438023 > 04 0F 04 00 01 1B 04=20
2011-06-09 09:36:28.439017 > 04 0B 0B 00 0C 00 BF EE 0F C6 98 3D 59 82=20
2011-06-09 09:36:28.439051 < 01 1C 04 03 0C 00 01=20
2011-06-09 09:36:28.441060 > 04 1B 03 0C 00 03=20
2011-06-09 09:36:28.443060 > 04 0F 04 00 01 1C 04=20
2011-06-09 09:36:28.448100 > 04 23 0D 00 0C 00 01 01 01 00 00 00 00 00 00 0=
0=20
2011-06-09 09:36:28.448133 < 01 19 04 0A 6E F5 C1 5B 9B EC 02 00 00 00=20
2011-06-09 09:36:28.450059 > 04 0F 04 00 01 19 04=20
2011-06-09 09:36:28.470089 > 04 07 FF 00 6E F5 C1 5B 9B EC 6E 61 6D 69 00 0=
0 00 00 00 00=20
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
2011-06-09 09:36:28.470129 < 01 11 04 02 0C 00=20
2011-06-09 09:36:28.472099 > 04 0F 04 00 01 11 04=20
2011-06-09 09:36:28.473061 > 04 17 06 6E F5 C1 5B 9B EC=20
2011-06-09 09:36:28.473193 < 01 0B 04 16 6E F5 C1 5B 9B EC CC CB 2A 77 3C 2=
E 5E 6B 75 87=20
  67 EC 03 40 67 8E=20
2011-06-09 09:36:28.485125 > 04 0E 0A 01 0B 04 00 6E F5 C1 5B 9B EC=20
2011-06-09 09:36:28.503097 > 04 06 03 00 0C 00=20
2011-06-09 09:36:28.503134 < 01 13 04 03 0C 00 01=20
2011-06-09 09:36:28.505069 > 04 0F 04 00 01 13 04=20
2011-06-09 09:36:28.533086 > 04 08 04 00 0C 00 01=20
2011-06-09 09:36:28.533133 < 02 0C 00 0A 00 06 00 01 00 0A 01 02 00 02 00=20
2011-06-09 09:36:28.539338 > 02 0C 20 10 00 0C 00 01 00 0B 01 08 00 02 00 0=
0 00 00 00 00=20
  00=20
2011-06-09 09:36:28.672083 > 04 13 05 01 0C 00 01 00=20
2011-06-09 09:36:36.509207 > 04 05 04 00 0C 00 13=20

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN8PxdQp8BWwlsTdMRAp57AJ9vQQeWnp776t7FsWn5jrXK5p1YuACgxkbe
+ocUydVcizTrRLi4jYd65os=
=7nM8
-----END PGP SIGNATURE-----
--=-=-=--
