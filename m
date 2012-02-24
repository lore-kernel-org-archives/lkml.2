Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab2BXKyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 05:54:00 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:42621 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753400Ab2BXKx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:53:59 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>,
        <rabin@rab.in>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>,
        <salvatore.dedominicis@st.com>
Subject: [PATCH] gpio/gpio-stmpe: Fix the value returned by _get_value routine
Date: Fri, 24 Feb 2012 16:04:39 +0530
Message-ID: <2f2b55523b707d514a15d822ff812cfae654510a.1330079584.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bhupesh Sharma <bhupesh.sharma@st.com>

The present _get_value routine returns the contents of the GPIO
Monitor Pin Status Register(GPMR) starting from the bit whose value
is requested to BIT 0.

For e.g. if we request the value of GPIO 6 in the earlier
implementation the value returned is:

	BIT6 to BIT0

whereas it should just return BIT6.

This patch addresses the same.

Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
Reviewed-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/gpio/gpio-stmpe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
index 094c5c4..dce3472 100644
--- a/drivers/gpio/gpio-stmpe.c
+++ b/drivers/gpio/gpio-stmpe.c
@@ -54,7 +54,7 @@ static int stmpe_gpio_get(struct gpio_chip *chip, unsigned offset)
 	if (ret < 0)
 		return ret;
 
-	return ret & mask;
+	return !!(ret & mask);
 }
 
 static void stmpe_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
-- 
1.7.8.110.g4cb5d

