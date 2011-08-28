Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab1H1PMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 11:12:48 -0400
Received: from serv132.fzu.cz ([147.231.26.132]:38741 "EHLO serv132.fzu.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab1H1PMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 11:12:44 -0400
X-Greylist: delayed 628 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Aug 2011 11:12:43 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIxXWk6T5xpZgWdsb2JhbABChEyUEY8aFAEBFiYlgWpNRSECEQJZCAEBh3CXX45akC+FO4ERBI4VhQqFDot4
X-IronPort-AV: E=Sophos;i="4.68,293,1312149600"; 
   d="asc'?scan'208";a="1698693"
Message-ID: <4E5A586E.90509@flaska.net>
Date: Sun, 28 Aug 2011 17:02:06 +0200
From: =?UTF-8?B?SmFuIEt1bmRyw6F0?= <jkt@flaska.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: IPv6: metrics of default routes on different interfaces (Ethernet
 vs. wifi)
X-Enigmail-Version: 1.1.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig79623584D23C00642C23D852"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig79623584D23C00642C23D852
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Dear LKML,
in the IPv4 world, the default routes on my wired interface have a
different metric than the WiFi ones:

velbloud ~ # ip r
default via 192.168.1.1 dev eth0  metric 3
default via 192.168.3.1 dev wlan0  metric 2004
127.0.0.0/8 via 127.0.0.1 dev lo
192.168.1.0/24 dev eth0  proto kernel  scope link  src 192.168.1.250
192.168.3.0/24 dev wlan0  proto kernel  scope link  src 192.168.3.250

I'm assuming here that the metrics of the default routes are somehow
derived from the "kind" of the underlying network interface, so that a
gigabit Ethernet is preferred over a 100Mbps one, which is preferred
over a 10Mbps one, etc. Please correct me if I'm wrong and the metrics
have a different origin, or if the wired-ethernet-preference it's just a
pure luck.

On the other hand, the IPv6 default routes, as auto-configured by kernel
with help from radvd running on my router both have the same metric:

velbloud ~ # ip -6 r
2a00:c500:215:23f5::/64 dev eth0  proto kernel  metric 256  expires 86394=
sec
2a00:c500:515:2336::/64 dev wlan0  proto kernel  metric 256  expires
86036sec
fe80::/64 dev eth0  proto kernel  metric 256
fe80::/64 dev wlan0  proto kernel  metric 256
ff00::/8 dev eth0  metric 256
ff00::/8 dev wlan0  metric 256
default via fe80::c63d:c7ff:fe90:d066 dev eth0  proto kernel  metric
1024  expires 1799sec hoplimit 64
default via fe80::c83d:c7ff:fe90:d066 dev wlan0  proto kernel  metric
1024  expires 1442sec hoplimit 64

(The router is the same box for both networks, and the radvd is
configured to advertise a high AdvRoutePreference on wired ethernet and
a medium one over wifi. This has no effect, which is -- I guess --
expected, as the preference shall affect only selection among routers on
the same interface.)

In this particular setup (e1000e and iwl3945 on an ancient Thinkpad T60
2007-FRG, kernel 2.6.39-gentoo-r2), the end result is general IPv4
traffic preferring wired gigabit Ethernet, with IPv6 data utilizing the
WiFi connection.

I've tried grepping my kernel sources, but wasn't able to find out the
place where the interface type is used in metric assignment. Could you
please point me to the right direction, so that I can come up with a
patch doing the same for IPv6? Or is this a flawed idea for some reason?

I'd appreciate a Cc on reply, as I'm not subscribed to this list. Or
just yell at me if that's wrong approach here.

Cheers,
Jan

--=20
Trojita, a fast e-mail client -- http://trojita.flaska.net/


--------------enig79623584D23C00642C23D852
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk5aWG4ACgkQamXfqERyJRcGSgCfcOdGgtipo6yix1ADHTH+mWnH
5HkAoIcc7Xd+8cfnFdVkez4MKgx7JBCZ
=CQ+U
-----END PGP SIGNATURE-----

--------------enig79623584D23C00642C23D852--
