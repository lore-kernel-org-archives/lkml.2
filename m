Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761429Ab2ELASf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 20:18:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42602 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab2ELASd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 20:18:33 -0400
Date: Fri, 11 May 2012 17:17:06 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 01/11] persistent_ram: Remove prz->node
Message-ID: <20120512001706.GA14782@lizard>
References: <20120512001506.GA8653@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120512001506.GA8653@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'node' struct member is unused, so remove it.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/staging/android/persistent_ram.c |    2 --
 drivers/staging/android/persistent_ram.h |    1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/staging/android/persistent_ram.c b/drivers/staging/android/persistent_ram.c
index 8407112..12444fd 100644
--- a/drivers/staging/android/persistent_ram.c
+++ b/drivers/staging/android/persistent_ram.c
@@ -407,8 +407,6 @@ struct persistent_ram_zone *__persistent_ram_init(struct device *dev, bool ecc)
 		goto err;
 	}
 
-	INIT_LIST_HEAD(&prz->node);
-
 	ret = persistent_ram_buffer_init(dev_name(dev), prz);
 	if (ret) {
 		pr_err("persistent_ram: failed to initialize buffer\n");
diff --git a/drivers/staging/android/persistent_ram.h b/drivers/staging/android/persistent_ram.h
index f41e208..5635355 100644
--- a/drivers/staging/android/persistent_ram.h
+++ b/drivers/staging/android/persistent_ram.h
@@ -38,7 +38,6 @@ struct persistent_ram {
 };
 
 struct persistent_ram_zone {
-	struct list_head node;
 	void *vaddr;
 	struct persistent_ram_buffer *buffer;
 	size_t buffer_size;
-- 
1.7.9.2

