Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab2HXHUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 03:20:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41324 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab2HXHU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 03:20:27 -0400
Date: Fri, 24 Aug 2012 17:20:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mengdong Lin <mengdong.lin@intel.com>
Subject: linux-next: build failure after merge of the final tree (sound tree
 related)
Message-Id: <20120824172018.21db4ca1245f3aa28002a76b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__24_Aug_2012_17_20_18_+1000_pmjG_ghZl7e_fpQv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Aug_2012_17_20_18_+1000_pmjG_ghZl7e_fpQv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (i386 defconfig)
failed like this:

sound/pci/hda/hda_codec.c: In function 'snd_hda_codec_new':
sound/pci/hda/hda_codec.c:1323:7: error: 'struct hda_codec' has no member n=
amed 'd3_stop_clk'
sound/pci/hda/hda_codec.c:1326:12: error: 'struct hda_codec' has no member =
named 'd3_stop_clk'
sound/pci/hda/hda_codec.c: In function 'hda_set_power_state':
sound/pci/hda/hda_codec.c:3547:7: error: 'struct hda_codec' has no member n=
amed 'd3_stop_clk_ok'
sound/pci/hda/hda_codec.c:3573:11: error: 'struct hda_codec' has no member =
named 'd3_stop_clk'
sound/pci/hda/hda_codec.c:3574:8: error: 'struct hda_codec' has no member n=
amed 'd3_stop_clk_ok'

Caused by commit b8dfc4624162 ("ALSA: hda - add runtime PM support").
CONFIG_SND_HDA_POWER_SAVE is not set for this build.

I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__24_Aug_2012_17_20_18_+1000_pmjG_ghZl7e_fpQv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQNysyAAoJEECxmPOUX5FEMtEQAJsyTBk3oVmNpEdOcb98GkzM
FRvoze0fQieZN+Y0KUp4ZiMrQaFyBdw3wmfvwZ7bWAGPFeeBrUpXFMUAu2SEv4YK
ESiqFqDE1ZOT+jSYEBw29LkaYKqbR8Gu41vkw+Y6SsaQAXbjJcxBXjwhyOp0KNIp
qjq4FRmmSl8gKNi/3XSKdRWnY/NZw+STyCbUvt9pzQ9UkVRJT/HsK9pJl41uUnxb
JxBOxXpgsYeT260cWToZw+4QhkZ08Og4nQYoKHNxEoGQvxP1W9esRbpAQNJ0x02X
RDrT/mKufl9D2/++pUePBohPbZL7lqZrrqIdumr2i84hMUfwPL3aaMsCfZ0TVCHC
WfFuAf76Qn8SnjQiglYgQXR+PN+CqDPK63embbkVwyPIePxFvu0SiKdlSrHMqEZY
MSBpWzFV7M1gJ7OQoJdSEnlsCFy05sCvhsGPQrpIVCd29QWKz27Rx1iD5Ou0rYmy
zYLdqWNhPnF1+bJMHI4xfTO9uCdlgbjNkTor6EiyEgcoQ87Sdu7E3irUwXb/laDW
aSCVxlBcC1yIoTyjGFgcNBPhWWmFtw5o7rVpj3VYHUaHlk2YIzxz1tlHtlLiRoLQ
nI0cd/cSAV8GkAowgdyoviz2UDDArrmnH9XpV/JepPC3MapAeLKg742wTlyWhi4Q
j5ms+JY+GuRjkB6Nfbyb
=ueKW
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Aug_2012_17_20_18_+1000_pmjG_ghZl7e_fpQv--
