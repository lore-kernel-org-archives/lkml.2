Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab0GAUMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:12:16 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64144 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab0GAUMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:12:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=SqVd2z0aSxamM9Dl4ifrZd+Cc8l+UMBIS1bjHe2kBi+mhRh8P9h5IfewmfUJZ0P3y1
         6VYywKBQTrBbg7kvbL+byd44NK5xATx4O5FSq0Xil3ryRu82I3XHgZ3gvjjuQI7BzK5b
         xVXR4Q6UCIk4kAN7z/kIYIK57HXg3JB/4se8Q=
Message-ID: <4C2D12C1.3000801@gmail.com>
Date: Fri, 02 Jul 2010 00:12:17 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mtd: return -1 if verify failed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should return -1 if the verify failed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I think this needed, correct?

diff --git a/drivers/mtd/tests/mtd_pagetest.c b/drivers/mtd/tests/mtd_pagetest.c
index 6bc1b82..7414888 100644
--- a/drivers/mtd/tests/mtd_pagetest.c
+++ b/drivers/mtd/tests/mtd_pagetest.c
@@ -358,7 +358,7 @@ static int erasecrosstest(void)
 		printk(PRINT_PREF "verify failed!\n");
 		errcnt += 1;
 		ok = 0;
-		return err;
+		return -1;
 	}
 
 	printk(PRINT_PREF "erasing block %d\n", ebnum);
