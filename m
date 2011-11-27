Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab1K0FcB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:32:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835Ab1K0Fb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:31:57 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Alex Dubov <oakad@yahoo.com>, Takashi Iwai <tiwai@suse.de>,
        Aries Lee <arieslee@jmicron.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 19/62] memstick: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:26:59 +0800
Message-Id: <1322371662-26166-20-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/memstick/host/jmb38x_ms.c |    4 ++--
 drivers/memstick/host/tifm_ms.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 6ce70e9..fd4eefb 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -325,7 +325,7 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
 			p_cnt = min(p_cnt, length);
 
 			local_irq_save(flags);
-			buf = kmap_atomic(pg, KM_BIO_SRC_IRQ) + p_off;
+			buf = kmap_atomic(pg) + p_off;
 		} else {
 			buf = host->req->data + host->block_pos;
 			p_cnt = host->req->data_len - host->block_pos;
@@ -341,7 +341,7 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
 				 : jmb38x_ms_read_reg_data(host, buf, p_cnt);
 
 		if (host->req->long_data) {
-			kunmap_atomic(buf - p_off, KM_BIO_SRC_IRQ);
+			kunmap_atomic(buf - p_off);
 			local_irq_restore(flags);
 		}
 
diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index b7aacf4..975d77c 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -210,7 +210,7 @@ static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
 			p_cnt = min(p_cnt, length);
 
 			local_irq_save(flags);
-			buf = kmap_atomic(pg, KM_BIO_SRC_IRQ) + p_off;
+			buf = kmap_atomic(pg) + p_off;
 		} else {
 			buf = host->req->data + host->block_pos;
 			p_cnt = host->req->data_len - host->block_pos;
@@ -221,7 +221,7 @@ static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
 			 : tifm_ms_read_data(host, buf, p_cnt);
 
 		if (host->req->long_data) {
-			kunmap_atomic(buf - p_off, KM_BIO_SRC_IRQ);
+			kunmap_atomic(buf - p_off);
 			local_irq_restore(flags);
 		}
 
-- 
1.7.4.4

