Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab2KZCcF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 21:32:05 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:50694 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab2KZCcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 21:32:03 -0500
Date: Mon, 26 Nov 2012 13:31:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20121126133153.50c5fa21cacd2858f30509e3@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_13_31_53_+1100_Dl+mc_8dA/ubxZDx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_13_31_53_+1100_Dl+mc_8dA/ubxZDx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "dma_common_get_sgtable" [drivers/media/v4l2-core/videobuf2-dma-cont=
ig.ko] undefined!

Caused by commit 9ef2cbeb8192 ("[media] v4l: vb2-dma-contig: add support
for DMABUF exporting").  dma_common_get_sgtable() is called from the
inline dma_get_sgtable_attrs() and dma_get_sgtable_attrs() is "called
from" dma_get_sgtable().  dma_common_get_sgtable() is only defined if
ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY is set which depends on
CONFIG_HAVE_GENERIC_DMA_COHERENT being set which it isn't for this build.

I have used the v4l-dvb tree form next-20121026 for today.

Please try testing your tree with an x86_64 allmodconfig build.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__26_Nov_2012_13_31_53_+1100_Dl+mc_8dA/ubxZDx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQstSZAAoJEECxmPOUX5FEr64P/1S5sMjwiuJS3Stoi+hfcqs+
T0iW/QpLfTFPisK+PJweov6wIwzP59+VE4M237iR6TF3eWOHsSJXEg8C9r+aCacK
MfBiAAAaOXGGFVCrToBjgqkRAJ+Bgl8Fxlls6tXL4N73oWiSAsFwCN6MIrkFj+lU
0/AUXAfj1xt7/u8/RIy8pgtsUMwfEAevy9pYJAuN6OHJXAc22LkEnjErjTzrIEfn
mXv0td2+rotdCV02Sz+gPzf+ZzVPfc73YbFKUs6XjphXxOINTdE34i2RZhlDzvVu
vszT25JmjOZ3SpPhzY09hZVVmvYlofWQHpqk4O4nFFqDNInsveYmt5c2GcKoGEnF
9fnKIeCuI1BoZeyEbXnhn6MkvaQymWtTPmyKGliYzip9n6UpctraPPA8Bg+aj6jx
y2gyVNaO3q97kiUy+Ur73Ur4KhcCRWeZ86UgBQxanP4rY+w+14eq+JmurPo8sqcw
ETnc4irwPDIb052VPiwbqEIr91p0ZPvit1OmYGt3irUNbiD8/5QjE6BiZ3WJZjzE
tM7efYV0D0t2Box+p2GtVzMCp2IpQdfHuTa539EbV5gmGZYBrzSqo/qiWElBhZRe
AKFGPwZlCCqqy2m/bqvZMnAIvSm0iNzT46r+Mlebxm7cey3WkLQQdJ4yoAMuKWLq
6Jsyy/RppwlQOb9BKPGy
=Oxm3
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_13_31_53_+1100_Dl+mc_8dA/ubxZDx--
