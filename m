Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233Ab2GVGeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 02:34:21 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57165 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab2GVGeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 02:34:17 -0400
Date: Sun, 22 Jul 2012 16:34:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>
Subject: linux-next: build failure after merge of the final tree (net-next
 tree related)
Message-Id: <20120722163408.6f2b74d31f05d45a88ed49de@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__22_Jul_2012_16_34_08_+1000_zAdJ5gA9mk9fluvX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__22_Jul_2012_16_34_08_+1000_zAdJ5gA9mk9fluvX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the final tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

net/core/rtnetlink.c: In function 'rtnl_fill_ifinfo':
net/core/rtnetlink.c:895:46: error: 'struct net_device' has no member named=
 'num_rx_queues'

Caused by commit 76ff5cc91935 ("rtnl: allow to specify number of rx and
tx queues on device creation").  This build does not have CONFIG_RPS set.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__22_Jul_2012_16_34_08_+1000_zAdJ5gA9mk9fluvX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQC57gAAoJEECxmPOUX5FE7bIP/Rwg1pDnVHSxv6uT6JUZggxm
F1shMEsknWcWlKerOoM1VvVTbvlbZZcG0vVahFEWqaEXAPu1zqeUqU3hrG+suGRk
kogT01Cy4eTndayBOFpvz8bhjQ0C807vcPPMyGtxkZMoeR5rHs9e+Do8fL6IMycB
mNUoBVQlab6kKxBWq4S5UzxsEC79tgvQbswbYYaKOQFOE+AK16w/8I8+vDRsq3F+
oSXPz3klyawBa/RWqx3WytrYCmw9nItLTOskE/Pl63vp5176xL9EK5pdQC0HxZ+6
UCKi8D9CHiTETeW9fJtXbXaBfD/BYEoUAb9JRkK5yX9brrjDO2UL4cIQJPgKtOHD
Q14FEswkF/5GXn9fONi3QfZzabOhOIgwWGEpHpQY/LsA1ouD1WLZEtSlzV0VxLmI
jaAZ5KWYF6rrqacwnmb0dtty5HvmagWS/VkcOxwayE2G18Js5wJf/3TdgfkOv8Ku
mIqtQHCIMH9nxsTSwLWr6idzqLr5f83Q/vaVP2HaGmSGYWR02n3N9ccPzHJgfAHc
ihmVg7bWXu/QNXJVavn9IJt0x4T2LFzKQoGXH7BLB6rJxKmnLrDJh/3/B2Iu8tUY
eVx8nn+OguY3LOebIPefUkHUWp7XNMUViyUeVgGpXcypYfdMKTrs48kvhVw/8ocO
Ng8jxTs/Tnu4Zd81q4RA
=IlPD
-----END PGP SIGNATURE-----

--Signature=_Sun__22_Jul_2012_16_34_08_+1000_zAdJ5gA9mk9fluvX--
