Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab0LaPFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 10:05:06 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53699 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab0LaPFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 10:05:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ahH5xHdsqfKfi6eL5qngPI1K31dSeESqz5dECuc1PERkh6YMtY1EOcdWxQ97n5P0M0
         pttj8gzOisemSMnSaydWdYmmGtx2NMbO28jxw/wuX4SilwqGxrccFozyKLLtnwUqcnJ/
         yl4w55jyPRidhua0dcWcC1ubRZqQ6nvTQ25/0=
Message-ID: <4D1DF11D.7090201@gmail.com>
Date: Fri, 31 Dec 2010 16:05:01 +0100
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: libertas: down_interruptible() can return -EINTR, not EINTR
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix test in lbs_spi_thread(). down_interruptible() can return -EINTR, but not EINTR.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/wireless/libertas/if_spi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index ecd4d04..0060023 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -784,7 +784,7 @@ static int lbs_spi_thread(void *data)
 				up(&card->spi_thread_terminated);
 				do_exit(0);
 			}
-		} while (err == EINTR);
+		} while (err == -EINTR);
 
 		/* Read the host interrupt status register to see what we
 		 * can do. */
