Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab2HCGqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 02:46:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15579 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab2HCGp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 02:45:58 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-3a-501b73a41e4e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thierry Reding'" <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2 1/3] pwm: samsung: add missing device pointer to struct
 pwm_chip
Date: Fri, 03 Aug 2012 15:45:56 +0900
Message-id: <001601cd7143$a29d0780$e7d71680$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1xQ6JUQmKz+x6IToivet5W1lmIDg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t9jQd2lxdIBBt1rmS0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDIOz13KXPCHtWLn/wXMDYxvWboYOTkkBEwkvr+eAWWL
	SVy4t56ti5GLQ0hgOqPE0c/nWSGcX4wSF1evZQapYhNQk/jy5TA7iC0iYC6xZNFesDizQKbE
	wZU7wGxhgVCJm4+WsYLYLAKqEhd+d4DZvAK2Eh87fzNC2IISPybfY4Ho1ZJYv/M4E4QtL7F5
	zVugORxAF6lLPPqrC7FKT+Lc7iOsECUiEvtevGOcwCgwC8mkWUgmzUIyaRaSlgWMLKsYRVML
	kguKk9JzDfWKE3OLS/PS9ZLzczcxgkP0mdQOxpUNFocYBTgYlXh4A02lA4RYE8uKK3MPMUpw
	MCuJ8B7LBQrxpiRWVqUW5ccXleakFh9ilOZgURLnNfb+6i8kkJ5YkpqdmlqQWgSTZeLglGpg
	dGe52x3QtV9GX+pggeaUPbde/f2em+lopSjndrnAn+dMs7ng4hVlzNYtKVauzkFh934t7t19
	MHXF8VN/DnJFhZb+2Jx16/H+rtUOwYuuXi5yzItnuKB/Z9oJG+UfWxcW/n8SslSVg/HMu4N/
	vk28+bn9AeONx5f+ZbuUXJsaIdMxufPFSYn2DiWW4oxEQy3mouJEAOBNpQJNAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing device pointer to struct pwm_chip. If the
device pointer is NULL, pwmchip_add() will return error.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Tested on SMDKV310 board
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


