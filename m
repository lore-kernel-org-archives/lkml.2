Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab2INGlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:41:35 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49346 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab2INGld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:41:33 -0400
Date: Fri, 14 Sep 2012 16:41:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Jeff Garzik <jeff@garzik.org>, Rob Herring <rob.herring@calxeda.com>
Subject: linux-next: manual merge of the dma-mapping tree with the libata
 tree
Message-Id: <20120914164122.51b19b8796752399e287af5a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Sep_2012_16_41_22_+1000_m1b8P_87P/sd0ckJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Sep_2012_16_41_22_+1000_m1b8P_87P/sd0ckJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the dma-mapping tree got a conflict in
Documentation/devicetree/bindings/ata/ahci-platform.txt between commit
8996b89d6bc9 ("ata: add platform driver for Calxeda AHCI controller")
from the  tree and commit 33e4628cc333 ("ARM: highbank: add coherent DMA
setup") from the dma-mapping tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/devicetree/bindings/ata/ahci-platform.txt
index 147c1f6,6c1ad01..0000000
--- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
+++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
@@@ -9,9 -9,7 +9,10 @@@ Required properties
  - reg               : <registers mapping>
 =20
  Optional properties:
 +- calxeda,port-phys: phandle-combophy and lane assignment, which maps each
 +			SATA port to a combophy and a lane within that
 +			combophy
+ - dma-coherent      : Present if dma operations are coherent
 =20
  Example:
          sata@ffe08000 {

--Signature=_Fri__14_Sep_2012_16_41_22_+1000_m1b8P_87P/sd0ckJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUtGSAAoJEECxmPOUX5FEXS4P/29hgGMNpWNll4xRlxt7hZq6
mfP6Lap/YcKW34MTldhQuHUHfLu9N08K7bPeQPTWQi/NWQGOaBzuLdnddb0Zlepa
ZfjYiNWP3ABgzMlyHs8qRu4xfxjqRd3B7Tx9QT6F+iIjSjBnGbHh2hiOaWxjb3Yq
FSRulxTgjcpbPxjYoeEQGW/GYS9RWvHHwX7J08A2+5JCW81UbGQWYna97J/4A3gp
sn2vlIBYy8FjMc73JZNWEWfeOAG5otEBKaMs3jgqq1MJ+YeScy0VpJVgTX/aTyOC
cGPky0urmZrlxCHopMmZ2O2vMVEfUiiNLYAZjV+0TSB5l//aq4rZizRwpiyRRCph
0KOMC7F99QbTvRAJtSgEQGsd5ufYF/AIgFjgrruFqBIZWPO5cISf+2yhg1kEwDFi
dKWXjH9aIWX7ZLvMrOEGxNH93OvS+MH8l91AIKcEsp9s5On+HUcfUZSIijNB3/ho
NOLy41PXqX690hYHQWiwRaF1G1C9wULiQaeunEJpCZTframb3J+SIMGgFIpXk3wZ
UOlDMzDOlzqx51c3dlw+Xl7Lv3XM/l701M/WAm4sS3Z/JPhTRSZqZnSmZoKa++rz
P7KNl22pj+HNDYXFurm5fmaf33/jCfUtwlQmMSGt6tyBM+03jeSgUpEHl5ckxvNi
y5I9o7isAw7YhQL+CXao
=h0qy
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Sep_2012_16_41_22_+1000_m1b8P_87P/sd0ckJ--
