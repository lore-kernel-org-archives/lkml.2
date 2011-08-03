Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab1HCG71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 02:59:27 -0400
Received: from www84.your-server.de ([213.133.104.84]:34001 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab1HCG7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 02:59:19 -0400
X-Greylist: delayed 1774 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Aug 2011 02:59:19 EDT
Subject: Re: [PATCH 1/11] kernel/kfifo.c: trivial: use BUG_ON
From: Stefani Seibold <stefani@seibold.net>
To: Andrea Righi <arighi@develer.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, trivial@kernel.org,
        kernel-janitors@vger.kernel.org, Stefani Seibold <stefani@seibold.net>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1108021349330.24349@ask.diku.dk>
References: <1312281304-11847-1-git-send-email-julia@diku.dk>
	 <1312281304-11847-2-git-send-email-julia@diku.dk>
	 <20110802113335.GA4185@thinkpad>
	 <Pine.LNX.4.64.1108021349330.24349@ask.diku.dk>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 03 Aug 2011 08:30:40 +0200
Message-ID: <1312353040.30326.0.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Allow the function to return 0 when 0 elements are asked for rather than
crashing the kernel with BUG.

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Stefano Seibold <stefani@seibold.net>

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


