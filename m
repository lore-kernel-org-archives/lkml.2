Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965678Ab2CAVvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:51:01 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35281 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965656Ab2CAVu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:50:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.129.136 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213923.202770580@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Yong Zhang <yong.zhang@windriver.com>,
        Ingo Molnar <mingo@elte.hu>, Joe Perches <joe@perches.com>
Subject: [ 06/34] kernel.h: fix wrong usage of __ratelimit()
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Yong Zhang <yong.zhang@windriver.com>

commit bb1dc0bacb8ddd7ba6a5906c678a5a5a110cf695 upstream.

When __ratelimit() returns 1 this means that we can go ahead.

Signed-off-by: Yong Zhang <yong.zhang@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/kernel.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -417,7 +417,7 @@ static inline char *pack_hex_byte(char *
 		.burst = DEFAULT_RATELIMIT_BURST,       \
 	};                                              \
 							\
-	if (!__ratelimit(&_rs))                         \
+	if (__ratelimit(&_rs))                          \
 		printk(fmt, ##__VA_ARGS__);		\
 })
 #else


