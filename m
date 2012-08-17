Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab2HQGEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 02:04:42 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6299 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab2HQGEj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 02:04:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 16 Aug 2012 23:04:24 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Antti Palosaari <crope@iki.fi>,
        "htl10@users.sourceforge.net" <htl10@users.sourceforge.net>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "joe@perches.com" <joe@perches.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Fri, 17 Aug 2012 08:04:16 +0200
Subject: [PATCH 1/1] driver-core: Shut up dev_dbg_reatelimited() without
 DEBUG
Thread-Topic: [PATCH 1/1] driver-core: Shut up dev_dbg_reatelimited()
 without DEBUG
Thread-Index: Ac17fyQiMTGNaEIySQ+BMLfQ/o0HGA==
Message-ID: <20120817.090416.563933713934615530.hdoyu@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_dbg_reatelimited() without DEBUG printed "217078 callbacks
suppressed". This shouldn't print anything without DEBUG.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
Reported-by: Antti Palosaari <crope@iki.fi>
---
 include/linux/device.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index eb945e1..d4dc26e 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -962,9 +962,13 @@ do {									\
 	dev_level_ratelimited(dev_notice, dev, fmt, ##__VA_ARGS__)
 #define dev_info_ratelimited(dev, fmt, ...)				\
 	dev_level_ratelimited(dev_info, dev, fmt, ##__VA_ARGS__)
+#if defined(DEBUG)
 #define dev_dbg_ratelimited(dev, fmt, ...)				\
 	dev_level_ratelimited(dev_dbg, dev, fmt, ##__VA_ARGS__)
-
+#else
+#define dev_dbg_ratelimited(dev, fmt, ...)			\
+	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#endif
 /*
  * Stupid hackaround for existing uses of non-printk uses dev_info
  *
-- 
1.7.5.4
