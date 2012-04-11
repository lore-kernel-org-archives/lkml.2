Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab2DKIFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 04:05:37 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:36387 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753364Ab2DKIFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 04:05:34 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: stefani@seibold.net
Cc: srinivas.kandagatla@st.com, mchehab@infradead.org,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Subject: [PATCH 3.3.0] kernel:kfifo: export __kfifo_max_r symbol.
Date: Wed, 11 Apr 2012 09:01:56 +0100
Message-Id: <1334131316-7992-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

kfifo_avail expands to __kfifo_max_r which is not an exported symbol.
Any kernel module using kfifo_avail will result in build failures
because of this.
This patch just exports __kfifo_max_r symbol to fix such problems in
future.

This bug was orignially reported by Stephen Rothwell <sfr@canb.auug.org.au> 
during v4l-dvb tree integration into linux-next.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
Hi All, 
A bulid failure during v4l-dvb tree integration into linux-next shows that __kfifo_max_r symbol is not exported.
All the __kifo_* functions declared in kfifo.h are already exported symbols.
I see no reason why __kfifo_max_r should not be exported too.

comments?

--srini

 kernel/kfifo.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/kfifo.c b/kernel/kfifo.c
index c744b88..59dcf5b 100644
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -402,6 +402,7 @@ unsigned int __kfifo_max_r(unsigned int len, size_t recsize)
 		return max;
 	return len;
 }
+EXPORT_SYMBOL(__kfifo_max_r);
 
 #define	__KFIFO_PEEK(data, out, mask) \
 	((data)[(out) & (mask)])
-- 
1.7.0.4

