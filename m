Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab2H0P2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 11:28:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab2H0P16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 11:27:58 -0400
Message-ID: <503B920F.30509@suse.com>
Date: Mon, 27 Aug 2012 11:28:15 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Cc: Viresh Kumar <viresh.kumar@st.com>, Wolfram Sang <w.sang@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Garzik <jgarzik@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Bhupesh Sharma <bhupesh.sharma@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH] clk.h: Fix shim ifdef guard (HAVE_CLK -> COMMON_CLK)
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 93abe8e4 (clk: add non HAVE_CLK routines) added shims for
the clk code but HAVE_CLK isn't enough. It's possible to have the
clk support but not enable it. We end up with full prototypes for code
that is never built - causing module linking to fail later.

This patch changes the guard to use COMMON_CLK, which actually guards
the code.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 include/linux/clk.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -120,7 +120,7 @@ static inline void clk_unprepare(struct
 }
 #endif
 
-#ifdef CONFIG_HAVE_CLK
+#ifdef CONFIG_COMMON_CLK
 /**
  * clk_get - lookup and obtain a reference to a clock producer.
  * @dev: device for clock "consumer"
@@ -276,7 +276,7 @@ struct clk *clk_get_parent(struct clk *c
  */
 struct clk *clk_get_sys(const char *dev_id, const char *con_id);
 
-#else /* !CONFIG_HAVE_CLK */
+#else /* !CONFIG_COMMON_CLK */
 
 static inline struct clk *clk_get(struct device *dev, const char *id)
 {


-- 
Jeff Mahoney
SUSE Labs
