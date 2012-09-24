Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab2IXDjd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 23:39:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34625 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab2IXDjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 23:39:32 -0400
Date: Mon, 24 Sep 2012 13:39:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: linux-next: build failure after merge of the sound and sound-asoc
 trees
Message-Id: <20120924133923.130c4db72aa8105cb5647d7a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_13_39_23_+1000_AlwBkNuiICzS1f86"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_13_39_23_+1000_AlwBkNuiICzS1f86
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from include/linux/skbuff.h:31:0,
                 from include/linux/if_ether.h:135,
                 from include/linux/netdevice.h:29,
                 from arch/powerpc/net/bpf_jit_comp.c:14:
include/linux/dmaengine.h: In function 'dmaengine_prep_dma_cyclic':
include/linux/dmaengine.h:659:24: error: 'flags' undeclared (first use in t=
his function)

and lots more similar.

Caused by commit ec8b5e48c037 ("dmaengine: Pass flags via
device_prep_dma_cyclic() callback").  Was this version of this patch
build tested at all?

I have used the sound and sound-asoc trees from next-20120921 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Sep_2012_13_39_23_+1000_AlwBkNuiICzS1f86
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQX9XrAAoJEECxmPOUX5FEomYP/3ugmM8ymdx/mX9QmLFv4+o7
ElD48nWimg1oh9CaD+qJv0eAbKp/wGL625RVnQhxxwUMkh+eJs0uuU4k5Gdw8nmE
yStNzFvOpozJbEtyHjbL8l5u6Ws8YxgpuGuFfDGe3yxHVuGd1l2mwWRklW8ep+AN
hxAndC7Ka1f9n3I0yAxcI78dS+hDK2v5hNk/sZHmo5YJjBUssZH3ajzh4lKmy+OS
EHZdnLmvtjVe6ZURC1inL0ERU+cCWMjmbiXvROC1ph6OwbtUJPLwYfN+q1qvWEXo
GNE888EuiwpcV6BZxE+cUz8cisDje4GrYHT0wQF1cHhsuc/rSTmsvVh+eZkEqV0q
ALHt5fJj9EXKKNhMxLGGkhHQ8utnWdWkT5aq7P+3jC+3p12aBiB4XlcSpEAzifdL
1JgkhYh1X0xa8RSVE21vE4Dx9c1qkGCc7zV7NMI7mUZnPkXOt3b8xxnIzMBh3IkI
A3XTNFmL4DcUynLUrZzNvcGlmLglwjU5rHeYJ1WHfTG0ZbGnaODdEtPxrYBPrymC
yJdH6/TbVuL3wpN+Ng4s7Pmqfx7TmL8nLeYdUdidaBfZ0hJ31w3937AcUPN3GGhK
HyRk39CIxBid+T3eam45dmvGNABz2CIwLCpp2nSONsT2xROEmeOD4+zbsBP/NNZd
/1gNlb4BKsaCEHy6iZx4
=nKjm
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_13_39_23_+1000_AlwBkNuiICzS1f86--
