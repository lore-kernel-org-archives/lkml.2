Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab1HBT1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 15:27:51 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:36259 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286Ab1HBT1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 15:27:44 -0400
Date: Tue, 2 Aug 2011 21:27:38 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Andrea Righi <arighi@develer.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, trivial@kernel.org,
        kernel-janitors@vger.kernel.org, Stefani Seibold <stefani@seibold.net>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/11] kernel/kfifo.c: trivial: use BUG_ON
In-Reply-To: <Pine.LNX.4.64.1108021349330.24349@ask.diku.dk>
Message-ID: <Pine.LNX.4.64.1108022127150.1846@ask.diku.dk>
References: <1312281304-11847-1-git-send-email-julia@diku.dk>
 <1312281304-11847-2-git-send-email-julia@diku.dk> <20110802113335.GA4185@thinkpad>
 <Pine.LNX.4.64.1108021349330.24349@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Allow the function to return 0 when 0 elements are asked for rather than
crashing the kernel with BUG.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 var/julia/linuxcopy/kernel/kfifo.c |    6 ------
 1 file changed, 6 deletions(-)

diff -u -p a/kernel/kfifo.c b/kernel/kfifo.c
index 01a0700..9f928ef 100644
--- a/var/linuxes/linux-next/kernel/kfifo.c
+++ b/var/julia/linuxcopy/kernel/kfifo.c
@@ -562,9 +562,6 @@ EXPORT_SYMBOL(__kfifo_to_user_r);
 unsigned int __kfifo_dma_in_prepare_r(struct __kfifo *fifo,
 	struct scatterlist *sgl, int nents, unsigned int len, size_t recsize)
 {
-	if (!nents)
-		BUG();
-
 	len = __kfifo_max_r(len, recsize);
 
 	if (len + recsize > kfifo_unused(fifo))
@@ -586,9 +583,6 @@ EXPORT_SYMBOL(__kfifo_dma_in_finish_r);
 unsigned int __kfifo_dma_out_prepare_r(struct __kfifo *fifo,
 	struct scatterlist *sgl, int nents, unsigned int len, size_t recsize)
 {
-	if (!nents)
-		BUG();
-
 	len = __kfifo_max_r(len, recsize);
 
 	if (len + recsize > fifo->in - fifo->out)
