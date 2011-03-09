Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab1CJA3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:29:20 -0500
Received: from smtp-out.google.com ([216.239.44.51]:24397 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab1CJA3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:29:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=aoKKWR9xDhskunYCBwBSLagXVIkNWvqQuX6zfAiZ5DSg+MH2Gptlc8aU4AqMk6VF1
	iY12OZHZFRk6xDgrnrI1w==
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org, rostedt@goodmis.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH trace-cmd 3/3] Revert "trace-cmd: Use conditional assignment of CC and AR"
Date: Wed,  9 Mar 2011 15:58:57 -0800
Message-Id: <1299715137-22768-3-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1299715137-22768-1-git-send-email-dhsharp@google.com>
References: <1299715137-22768-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 6c696cec3f264a9399241b6e648f58bc97117d49.

Make has default values CC and AR of 'cc' and 'ar' respectively. This means
that "CC ?= anything" will never have effect, because CC is always already set.
Because of this, 6c696cec makes setting CROSS_COMPILE from the command line or
environment useless.

Signed-off-by: David Sharp <dhsharp@google.com>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 169fcbc..fa37df5 100644
--- a/Makefile
+++ b/Makefile
@@ -13,8 +13,8 @@ FILE_VERSION = 6
 
 MAKEFLAGS += --no-print-directory
 
-CC ?= $(CROSS_COMPILE)gcc
-AR ?= $(CROSS_COMPILE)ar
+CC = $(CROSS_COMPILE)gcc
+AR = $(CROSS_COMPILE)ar
 EXT = -std=gnu99
 INSTALL = install
 
-- 
1.7.3.1

