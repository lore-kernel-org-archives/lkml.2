Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab0FIQBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 12:01:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55631 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923Ab0FIQBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:01:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=POlzxeHEHJhHpynsOEXTX8ACA12V8aGsFeAWjX2LESSuHXE3ANoz9RvRwEtHrwhAui
         xw6wPZoRxAfB3D7Qj6LBwQTTSbePSjzRQKexfEBHQzsR7ASYeJ5HW4gIgAwZvUB9/Y8I
         LgljzfbpQ+powsovmzuAPaIVrR7nQOqV/OXMo=
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Darren Hart <dvhltc@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 1/2] trace-cmd: Makefile - EXTRAVERSION should be set without a leading period
Date: Wed,  9 Jun 2010 18:01:27 +0200
Message-Id: <1276099288-3029-2-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1276099288-3029-1-git-send-email-jkacur@redhat.com>
References: <1276099288-3029-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXTRAVERSION should be set without a leading period, and then add
the period where necessary in the Makefile

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 1f5d855..0ed5685 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # trace-cmd version
 TC_VERSION = 1
 TC_PATCHLEVEL = 0
-TC_EXTRAVERSION = .1
+TC_EXTRAVERSION = 1
 
 # Kernel Shark version
 KS_VERSION = 0
@@ -307,7 +307,7 @@ define make_version.h
 	echo \#define VERSION_CODE $(shell						\
 	expr $(VERSION) \* 256 + $(PATCHLEVEL));					\
 	echo '#define EXTRAVERSION ' $(EXTRAVERSION);					\
-	echo '#define VERSION_STRING "'$(VERSION).$(PATCHLEVEL)$(EXTRAVERSION)'"';	\
+	echo '#define VERSION_STRING "'$(VERSION).$(PATCHLEVEL).$(EXTRAVERSION)'"';	\
 	echo '#define FILE_VERSION '$(FILE_VERSION);					\
 	) > $1
 endef
-- 
1.6.6.1

