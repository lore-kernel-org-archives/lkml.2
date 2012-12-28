Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab2L1TRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:17:04 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54920 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754211Ab2L1TQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:16:59 -0500
Message-Id: <20121228190403.079524028@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:06:23 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 173/173] ramoops: fix use of rounddown_pow_of_two()
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Stornelli <marco.stornelli@gmail.com>

commit fdb5950754eb3dedb9fea7c8828d3e51d9dbc3f7 upstream.

The return value of rounddown_pow_of_two wasn't evaluated, so the
operation was a no-op.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/ramoops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index feda90c..9c152ab 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -125,8 +125,8 @@ static int __init ramoops_probe(struct platform_device *pdev)
 		goto fail3;
 	}
 
-	rounddown_pow_of_two(pdata->mem_size);
-	rounddown_pow_of_two(pdata->record_size);
+	pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
+	pdata->record_size = rounddown_pow_of_two(pdata->record_size);
 
 	/* Check for the minimum memory size */
 	if (pdata->mem_size < MIN_MEM_SIZE &&


