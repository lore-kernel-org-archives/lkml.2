Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab0KZRGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:06:17 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34982 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab0KZRGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:06:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=qJE9cCSf80hFmWBnVi0Sr5no+dRJbnKE9xGt3jntQCRj/zP3hAG+/waoCx9UZrJv69
         SdBaDrEx8Lenr1/tsCTaB/V9iFFmWWIhQpL/Q3OTkSRb5YlKc7d4pegs5c7EHV2VdVGe
         JQByxagpdNYhLyNt2AdoN9YeQG4Ni5FFyVOUI=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Viresh Kumar <viresh.kumar@st.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arm: plat-spear: time: use IS_ERR() instead of NULL check
Date: Fri, 26 Nov 2010 20:06:07 +0300
Message-Id: <1290791168-21255-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() returns ERR_PTR() on error, not NULL.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Cannot compile this driver, so it is not tested at all.

 arch/arm/plat-spear/time.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-spear/time.c b/arch/arm/plat-spear/time.c
index ab21165..678df18 100644
--- a/arch/arm/plat-spear/time.c
+++ b/arch/arm/plat-spear/time.c
@@ -229,13 +229,13 @@ void __init spear_setup_timer(void)
 	}
 
 	gpt_clk = clk_get_sys("gpt0", NULL);
-	if (!gpt_clk) {
+	if (IS_ERR(gpt_clk)) {
 		pr_err("%s:couldn't get clk for gpt\n", __func__);
 		goto err_iomap;
 	}
 
 	pll3_clk = clk_get(NULL, "pll3_48m_clk");
-	if (!pll3_clk) {
+	if (IS_ERR(pll3_clk)) {
 		pr_err("%s:couldn't get PLL3 as parent for gpt\n", __func__);
 		goto err_iomap;
 	}
-- 
1.7.0.4

