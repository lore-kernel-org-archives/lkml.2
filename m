Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab1FOAWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 20:22:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab1FOAWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 20:22:22 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] linux/uaccess.h needs to #include linux/kernel.h for
 might_sleep()
To: torvalds@osdl.org
Cc: akpm@linux-foundation.org, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Wed, 15 Jun 2011 01:22:10 +0100
Message-ID: <20110615002210.1392.64165.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/uaccess.h needs to #include linux/kernel.h to get might_sleep() otherwise
it fails to build on MN10300 allyesconfig.  This fails in a few places with
messages like the following:

In file included from security/keys/trusted.c:14:
include/linux/uaccess.h: In function '__copy_from_user_nocache':
include/linux/uaccess.h:52: error: implicit declaration of function 'might_sleep'

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/uaccess.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 5ca0951..ab540ed 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -2,6 +2,7 @@
 #define __LINUX_UACCESS_H__
 
 #include <linux/preempt.h>
+#include <linux/kernel.h>
 #include <asm/uaccess.h>
 
 /*

