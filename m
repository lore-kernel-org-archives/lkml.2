Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414Ab2GLWge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:36:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab2GLWg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:36:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>,
        Tom Herbert <therbert@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Denys Fedoryshchenko <denys@visp.net.lb>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 016/187] bql: Fix POSDIFF() to integer overflow aware.
Date: Thu, 12 Jul 2012 15:32:52 -0700
Message-Id: <20120712191523.758844778@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>

[ Upstream commit 0cfd32b736ae0c36b42697584811042726c07cba ]

POSDIFF() fails to take into account integer overflow case.

Signed-off-by: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>
Cc: Tom Herbert <therbert@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Denys Fedoryshchenko <denys@visp.net.lb>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/dynamic_queue_limits.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/dynamic_queue_limits.c
+++ b/lib/dynamic_queue_limits.c
@@ -10,7 +10,7 @@
 #include <linux/jiffies.h>
 #include <linux/dynamic_queue_limits.h>
 
-#define POSDIFF(A, B) ((A) > (B) ? (A) - (B) : 0)
+#define POSDIFF(A, B) ((int)((A) - (B)) > 0 ? (A) - (B) : 0)
 
 /* Records completed count and recalculates the queue limit */
 void dql_completed(struct dql *dql, unsigned int count)


