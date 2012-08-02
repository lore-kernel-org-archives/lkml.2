Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab2HBIz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 04:55:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51647 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab2HBIz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 04:55:56 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-02-501a409abe0a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thierry Reding'" <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/2] pwm: samsung: add missing device pointer to struct pwm_chip
Date: Thu, 02 Aug 2012 17:55:54 +0900
Message-id: <002301cd708c$a01a1a50$e04e4ef0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1wjKAGF046k3JfQ567Unl4xOWs9w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t9jQd3ZDlIBBnO4LC7vmsPmwOjxeZNc
	AGMUl01Kak5mWWqRvl0CV8bnkyeZCx6xVrzes4CxgfEGSxcjJ4eEgInEh7Z1TBC2mMSFe+vZ
	uhi5OIQEpjNKzN7YzwrhzGaSeDz1HlgHm4CaxJcvh9lBbBEBc4kli/YydzFycDALuEgcnSYC
	EhYWCJA4/20tI4jNIqAqsWvzLXaQEl4BW4nHFw1BwrwCghI/JkNMZBbQkli/8zgThC0vsXnN
	W7CJEgLqEo/+6kIs0pO4OWEmVLmIxL4X7xgnMArMQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILi
	pPRcQ73ixNzi0rx0veT83E2M4JB8JrWDcWWDxSFGAQ5GJR7elaWSAUKsiWXFlbmHGCU4mJVE
	eO9ISAUI8aYkVlalFuXHF5XmpBYfYpTmYFES5zX2/uovJJCeWJKanZpakFoEk2Xi4JRqYNyS
	qBdhwTybccKrXXluv2belBN9+6Lep3hxzMG9yformZjePjXRK/ylkFLuwLFhmdD3fyzhtrYJ
	08qvcRyWFEz2Ny/bNLVzM0fHdcttZen20qzv5qvWqG35OGt9seVu3S/bfILDVAwWP8n9o3jz
	9PnP/df0jlueiLtXZ7XLVuTWUbkE6SUvs5VYijMSDbWYi4oTAYU5gYpFAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing device pointer to struct pwm_chip. If the
device pointer is NULL, pwmchip_add() will return error.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pwm/pwm-samsung.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
index d103865..e5187c0 100644
--- a/drivers/pwm/pwm-samsung.c
+++ b/drivers/pwm/pwm-samsung.c
@@ -225,6 +225,7 @@ static int s3c_pwm_probe(struct platform_device *pdev)
 
 	/* calculate base of control bits in TCON */
 	s3c->tcon_base = id == 0 ? 0 : (id * 4) + 4;
+	s3c->chip.dev = &pdev->dev;
 	s3c->chip.ops = &s3c_pwm_ops;
 	s3c->chip.base = -1;
 	s3c->chip.npwm = 1;
-- 
1.7.1


