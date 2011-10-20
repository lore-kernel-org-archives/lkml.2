Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab1JTIp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 04:45:56 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51097 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab1JTIpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 04:45:54 -0400
Date: Thu, 20 Oct 2011 04:45:41 -0400 (EDT)
Message-Id: <20111020.044541.970282389722164761.davem@davemloft.net>
To: cloud.ren@Atheros.com
Cc: Luis.Rodriguez@Atheros.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch net-next]alx: Atheros AR8131/AR8151/AR8152/AR8161
 Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1319093184-19696-1-git-send-email-cloud.ren@Atheros.com>
References: <1319093184-19696-1-git-send-email-cloud.ren@Atheros.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 20 Oct 2011 01:45:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <cloud.ren@Atheros.com>
Date: Thu, 20 Oct 2011 14:46:24 +0800

> +#define __far

So much unused crap left in these header files, get rid of this stuff.

+#define ALX_HW_WARN(_fmt, _args...) \
+		ALX_HW_PRINTA(WARNING, _fmt, ## _args)
+
+#define ALX_HW_INFO(_fmt, _args...) \
+		ALX_HW_PRINTA(INFO, _fmt, ## _args)
+
+#define ALX_HW_DBG(_fmt, _args...) \
+		ALX_HW_PRINTA(DEBUG, _fmt, ## _args)
+

We told you to get rid of your customized debug logging interfaces,
yet all of this stuff is still there.

+/* delay function */
+#define US_DELAY(_hw, _n)	__US_DELAY(_n)
+#define MS_DELAY(_hw, _n)	__MS_DELAY(_n)
+#define __US_DELAY(_n)		udelay(_n)
+#define __MS_DELAY(_n)		mdelay(_n)

Useless wrappers for standard kernel interfaces, kill this.

+#define DEBUG_INFO(_a, _b)
+#define DEBUG_INFOS(_a, _b)

Again we told you to get rid of this stuff.

I suspect it's going to take may rounds of feedback before this driver
is anywhere near ready for inclusion.

Please just submit it to staging and let it cook there for a couple
weeks in the interests of our sanity.
