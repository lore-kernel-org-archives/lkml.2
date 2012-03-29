Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910Ab2C2RHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 13:07:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759178Ab2C2RHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 13:07:07 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/14] i5100_edac: Fix a warning when compiled with 32 bits
Date: Thu, 29 Mar 2012 14:06:59 -0300
Message-Id: <1333040821-6253-13-git-send-email-mchehab@redhat.com>
In-Reply-To: <1333040821-6253-1-git-send-email-mchehab@redhat.com>
References: <1333040821-6253-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/edac/i5100_edac.c: In function ‘i5100_init_csrows’:
drivers/edac/i5100_edac.c:862:3: warning: format ‘%zd’ expects argument of type ‘signed size_t’, but argument 5 has type ‘long unsigned int’ [-Wformat]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i5100_edac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index 11aba5e..dd260c8 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -859,8 +859,8 @@ static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 				i5100_rank_to_slot(mci, chan, rank));
 		}
 
-		debugf2("dimm channel %d, rank %d, size %zd\n",
-			chan, rank, PAGES_TO_MiB(npages));
+		debugf2("dimm channel %d, rank %d, size %ld\n",
+			chan, rank, (long)PAGES_TO_MiB(npages));
 	}
 }
 
-- 
1.7.8

