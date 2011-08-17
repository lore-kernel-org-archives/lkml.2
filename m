Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab1HQACA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 20:02:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40962 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab1HQAB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 20:01:58 -0400
Date: Wed, 17 Aug 2011 10:01:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: linux-next: boot test failure (net tree)
Message-Id: <20110817100146.3b557cf815a5a2ae09bc09a7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Aug_2011_10_01_46_+1000_DqzQb1=P662eBQRn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Aug_2011_10_01_46_+1000_DqzQb1=P662eBQRn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I do build and boot tests for various PowerPC servers I have access to.
Last night's test failed due to the fact that their ethernet drivers are
not longer being built.  In particular, CONFIG_TIGON3 newly depends on
CONFIG_NET_VENDOR_BROADCOM which will no be selected when doing a "make
oldconfig" from a working config.  Similarly for CONFIG_IBM_VETH and (the
new) CONFIG_VENDOR_IBM.  The original config had both CONFIG_TIGON3 and
CONFIG_IBM_VETH set (to y and m resp.) and the final config had neither.

These Kconfig changes need to be revised so that "make oldconfig" from a
working config builds the same set of drivers ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Aug_2011_10_01_46_+1000_DqzQb1=P662eBQRn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOSwTqAAoJEDMEi1NhKgbsYwgH/1JPwPg3Bgu/7suOANAjluWJ
FO7GCUZnON9YYgSAnorvkRYhbwG2UkiK7XV4du7pjjobI5KO2ZLRqygnSx0dAVKi
eqlRz5tSL+bfeiBGOX/+jF9oUenXbRjiv1KyO5FUNSRz9YOE9eBEqveRXuh9ypWy
oDfR7FAVr4fCc+0a3yLQBNyosq17E8i4zI8LhK4xUr9csnHh+ZZlooF2rzTPGRlK
6KoEA5r0ejxSwyRRvVm2p7of65Q2o5aHpNNOYf8U9qrk/YqKwFdGkWGY2JY8guwQ
DBCiLKANsid/K0MYhlxDMDsklHuEEkasuHBGdEqB3drTqeZwRR8EugyLoSZpCzQ=
=u8Vw
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Aug_2011_10_01_46_+1000_DqzQb1=P662eBQRn--
