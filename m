Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364Ab2IYEKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 00:10:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab2IYEKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 00:10:17 -0400
Date: Tue, 25 Sep 2012 14:10:05 +1000
From: NeilBrown <neilb@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the md tree
Message-ID: <20120925141005.2a83593e@notabene.brown>
In-Reply-To: <20120925133146.36615871cf4ccbcbd422ed87@canb.auug.org.au>
References: <20120925133146.36615871cf4ccbcbd422ed87@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AVb3x23g=xwDjDgAYF6cLAA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/AVb3x23g=xwDjDgAYF6cLAA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Sep 2012 13:31:46 +1000 Stephen Rothwell <sfr@canb.auug.org.au>
wrote:

> Hi Neil,
>=20
> After merging the md tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> ERROR: "__tracepoint_block_unplug" [drivers/md/raid456.ko] undefined!
>=20
> Presumably caused by commit 14817e9a6dab ("md/raid5: add blktrace calls").
>=20
> CONFIG_MD_RAID456=3Dm
>=20
> I have used the md tree from next-20120924 for today.

Thanks.
I requires the following which I have already sent to Jens Axboe.
I might pull my patch until this fix-up is resolve.

Thanks,
NeilBrown


=46rom 0ef9cbd6e5c6f6c9f303c8a7c905afb3fb55c28d Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Tue, 25 Sep 2012 09:56:31 +1000
Subject: [PATCH] block: export trace_block_unplug

This allows stacked devices (like md/raid5) to provide blktrace
tracing, including unplug events.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/block/blk-core.c b/block/blk-core.c
index 4b4dbdf..ef55ae0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -40,6 +40,7 @@
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_unplug);
=20
 DEFINE_IDA(blk_queue_ida);
=20

--Sig_/AVb3x23g=xwDjDgAYF6cLAA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGEunjnsnt1WYoG5AQK8yhAAi1qYovddDfRCggqvw2nGS8jFAMCuylHy
Wm2Hh0jR5BL9Fu76o0SVOsUw7ADDUll5ZQG3FuPgViV026+R48vddoJN/Nu3jMZT
KNDr4evIQRVQk7XhSHQLKuLJ1fxV896vnNhckeGUmiC8E33Dr6/+wp4n93pQb3Z8
w8pMQtXsUE10iXI9TN6dpyMIvOpyhPJBANQfw1Qc3xpOe2wxPyhIbDTxm5Two5+i
6bVNTaumH84IOQYgk20JpkmeaScRu8EBPCInby/2a/E1EIueqsUPPaEAVxj5uw2g
3cbczhvDF7eaTNHYByhJSKDLytp0wP8V5r410bWkpi1WLbDG8Daf5xMyBkjvngUY
Z1WouxeU11T2+qVVhQovASk9B6D1pZrrjq//jX5eoEY6Iq/cKfZsulvSwnHkOJDt
gusODXYY8V5q0AyGuSXb4/Mfh7XqpkApti/3LA3KyehhhCiPjjgjFLiyuIX86Ux1
wu0tInRYWx3HAWx2JDJGgWmepiAPP6N98oRHiXhOt26HUFHtqP89Qc0VojbDC2Zc
FUFlLU1PR+edIhIB/9jLkrzcEh+3j0RWLNSBzo87OWmxw8g0SAMOX+XHCcPPyn/x
qq/LxRpDAe/MEOUzEOAK2c2svMVbpH5GJr4b5LoJjPHEXjb8dWVPRKseV98ZZavu
DPrPR0qvSRA=
=mxjf
-----END PGP SIGNATURE-----

--Sig_/AVb3x23g=xwDjDgAYF6cLAA--
