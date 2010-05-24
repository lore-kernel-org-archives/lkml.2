Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab0EXBYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 21:24:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55207 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab0EXBYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 21:24:12 -0400
Date: Mon, 24 May 2010 11:24:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jassi Brar <jassi.brar@samsung.com>
Subject: linux-next: build failure after merge of the async_tx tree
Message-Id: <20100524112405.3c62d22b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__24_May_2010_11_24_05_+1000_i57tkG9JlBlYFsCs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_May_2010_11_24_05_+1000_i57tkG9JlBlYFsCs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

After merging the async_tx tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from drivers/dma/pl330.c:19:
include/linux/amba/pl330.h:15:32: error: asm/hardware/pl330.h: No such file=
 or directory
In file included from drivers/dma/pl330.c:19:
include/linux/amba/pl330.h:23: error: field 'rqtype' has incomplete type
drivers/dma/pl330.c:74: error: field 'pif' has incomplete type
drivers/dma/pl330.c:96: error: field 'px' has incomplete type
drivers/dma/pl330.c:98: error: field 'rqcfg' has incomplete type
drivers/dma/pl330.c:99: error: field 'req' has incomplete type
drivers/dma/pl330.c: In function 'fill_queue':
drivers/dma/pl330.c:166: error: implicit declaration of function 'pl330_sub=
mit_req'
drivers/dma/pl330.c: In function 'pl330_tasklet':
drivers/dma/pl330.c:204: error: implicit declaration of function 'pl330_cha=
n_ctrl'
drivers/dma/pl330.c:204: error: 'PL330_OP_START' undeclared (first use in t=
his function)
drivers/dma/pl330.c:204: error: (Each undeclared identifier is reported onl=
y once
drivers/dma/pl330.c:204: error: for each function it appears in.)
drivers/dma/pl330.c: At top level:
drivers/dma/pl330.c:211: warning: 'enum pl330_op_err' declared inside param=
eter list
drivers/dma/pl330.c:211: warning: its scope is only this definition or decl=
aration, which is probably not what you want
drivers/dma/pl330.c:211: error: parameter 2 ('err') has incomplete type
drivers/dma/pl330.c: In function 'pl330_alloc_chan_resources':
drivers/dma/pl330.c:240: error: implicit declaration of function 'pl330_req=
uest_channel'
drivers/dma/pl330.c: In function 'pl330_control':
drivers/dma/pl330.c:266: error: 'PL330_OP_FLUSH' undeclared (first use in t=
his function)
drivers/dma/pl330.c: In function 'pl330_free_chan_resources':
drivers/dma/pl330.c:288: error: implicit declaration of function 'pl330_rel=
ease_channel'
drivers/dma/pl330.c: In function '_init_desc':
drivers/dma/pl330.c:362: error: 'SWAP_NO' undeclared (first use in this fun=
ction)
drivers/dma/pl330.c:365: error: 'SCCTRL0' undeclared (first use in this fun=
ction)
drivers/dma/pl330.c:366: error: 'DCCTRL0' undeclared (first use in this fun=
ction)
drivers/dma/pl330.c: In function 'fill_px':
drivers/dma/pl330.c:465: error: dereferencing pointer to incomplete type
drivers/dma/pl330.c:466: error: dereferencing pointer to incomplete type
drivers/dma/pl330.c:467: error: dereferencing pointer to incomplete type
drivers/dma/pl330.c:468: error: dereferencing pointer to incomplete type
drivers/dma/pl330.c: In function 'get_burst_len':
drivers/dma/pl330.c:505: error: dereferencing pointer to incomplete type
drivers/dma/pl330.c:506: error: dereferencing pointer to incomplete type
drivers/dma/pl330.c: In function 'pl330_prep_dma_memcpy':
drivers/dma/pl330.c:535: error: 'MEMTOMEM' undeclared (first use in this fu=
nction)
drivers/dma/pl330.c:548: error: dereferencing pointer to incomplete type
drivers/dma/pl330.c: In function 'pl330_prep_slave_sg':
drivers/dma/pl330.c:585: error: 'MEMTODEV' undeclared (first use in this fu=
nction)
drivers/dma/pl330.c:587: error: 'DEVTOMEM' undeclared (first use in this fu=
nction)
drivers/dma/pl330.c: In function 'pl330_irq_handler':
drivers/dma/pl330.c:653: error: implicit declaration of function 'pl330_upd=
ate'
drivers/dma/pl330.c: In function 'pl330_probe':
drivers/dma/pl330.c:686: error: dereferencing pointer to incomplete type
drivers/dma/pl330.c:687: error: dereferencing pointer to incomplete type
drivers/dma/pl330.c:688: error: dereferencing pointer to incomplete type
drivers/dma/pl330.c:693: error: dereferencing pointer to incomplete type
drivers/dma/pl330.c:694: error: dereferencing pointer to incomplete type
drivers/dma/pl330.c:705: error: implicit declaration of function 'pl330_add'
drivers/dma/pl330.c:725: error: 'MEMTOMEM' undeclared (first use in this fu=
nction)
drivers/dma/pl330.c:728: error: 'MEMTODEV' undeclared (first use in this fu=
nction)
drivers/dma/pl330.c:729: error: 'DEVTOMEM' undeclared (first use in this fu=
nction)
drivers/dma/pl330.c:770: error: dereferencing pointer to incomplete type
drivers/dma/pl330.c:770: error: dereferencing pointer to incomplete type
drivers/dma/pl330.c:770: error: dereferencing pointer to incomplete type
drivers/dma/pl330.c:770: error: dereferencing pointer to incomplete type
drivers/dma/pl330.c:770: error: dereferencing pointer to incomplete type
drivers/dma/pl330.c:779: error: implicit declaration of function 'pl330_del'
drivers/dma/pl330.c:783: error: dereferencing pointer to incomplete type
drivers/dma/pl330.c: In function 'pl330_remove':
drivers/dma/pl330.c:823: error: dereferencing pointer to incomplete type

Caused by commit 0376653c268fce662831fbd109ce9811b25c16c2 ("DMA: PL330:
Add dma api driver").  Maybe this depends on a particular architecture?

I have used the async_tx tree from next-20100522 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__24_May_2010_11_24_05_+1000_i57tkG9JlBlYFsCs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv51TUACgkQjjKRsyhoI8wdrQCgk7tuTd5AJW0tBwl8gKrMm0td
RTUAoKBS5txxWXJdsgOoHB8253C6yeS7
=5R70
-----END PGP SIGNATURE-----

--Signature=_Mon__24_May_2010_11_24_05_+1000_i57tkG9JlBlYFsCs--
