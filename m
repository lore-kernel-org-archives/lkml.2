Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab2GVFgE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 01:36:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59498 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2GVFgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 01:36:00 -0400
Date: Sun, 22 Jul 2012 15:35:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Vinod Koul <vinod.koul@linux.intel.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: linux-next: manual merge of the akpm tree with the slave-dma tree
Message-Id: <20120722153548.48213df45606109be4f7952b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__22_Jul_2012_15_35_48_+1000_XE+u/rdbu56N1wv="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__22_Jul_2012_15_35_48_+1000_XE+u/rdbu56N1wv=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/dma/dmaengine.c between commit 634332502366 ("dmaengine: Cleanup
logging messages") from the slave-dma tree and commit
"drivers/dma/dmaengine.c: lower the priority of 'failed to get' dma
channel message" from the akpm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/dma/dmaengine.c
index 3491654,6c87d67..0000000
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@@ -582,8 -578,8 +582,8 @@@ void dmaengine_get(void
  				list_del_rcu(&device->global_node);
  				break;
  			} else if (err)
- 				pr_err("%s: failed to get %s: (%d)\n",
+ 				pr_debug("%s: failed to get %s: (%d)\n",
 -					__func__, dma_chan_name(chan), err);
 +				       __func__, dma_chan_name(chan), err);
  		}
  	}
 =20

--Signature=_Sun__22_Jul_2012_15_35_48_+1000_XE+u/rdbu56N1wv=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQC5E0AAoJEECxmPOUX5FEBu4P/3KNJygrQtW2RARpvVEFAwTS
XUHHR2US/xEsvYenYF+whOnBuF16fZ/AKIbRTOTNpE+My11meUD2zg5jMiapLyPG
L2RNue4KcSUC/k15HyBxJzMD7RI+sJDocfgfV2jZg1gp9W0ZM74B6kZd1s8w0S9T
EIrf7ky9wdZb5Yrj0hB8Z6uWQ/VsedoTnr1sNLbaEcXX8DYeBErAP3XYR/QcXvQv
XrrqF6+YOipbgqLM/o2+tTB04qA4b92A4bOvo4C73nnc+tY4gT02EqVQukemCKb5
LtFQhYkJ6OBJSCoBNx7SJr84KgkQHzLDcjdjPMxM5sbvBJl6jD+DBbc6Kq5Qckn2
l4KvWfkZlvuj89BTc2+WjtDqzaT1wrmitWV/qxDszIVFL2zmzAaC5JS1cKEDDJb5
Cu1mY4LZsaQfuCsH1BpxYT6fPYVl7X8ycSDQ4jnlj++sEdyCGqLBTp/gPy5PMzIT
49ZoBx+DO2ixFuH5ECkF1kYLTFSW5OpSVZfOibJ5qhcFBSaS9beEJdIuAeWQd8Pq
u0D++zo5MEcTzaJuxD3/mBDQ0PtZzqpb3uhHGBYwiYk/W3P15L1cz0bhpfyS5Swr
5zy9F7kBm4MM0dzRa0oDFIZKpX2h8TU3j1OB4mcYVE/z1Xp4JD+y0jWv3EqnyCMY
Zh1G1XNE1uFbrGLbb+XE
=CMJk
-----END PGP SIGNATURE-----

--Signature=_Sun__22_Jul_2012_15_35_48_+1000_XE+u/rdbu56N1wv=--
