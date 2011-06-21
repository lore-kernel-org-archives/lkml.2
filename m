Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab1FUJaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 05:30:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671Ab1FUJaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 05:30:01 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MN10300: asm/uaccess.h needs to #include linux/kernel.h for
 might_sleep()
To: torvalds@osdl.org
Cc: akpm@linux-foundation.org, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Jun 2011 10:29:51 +0100
Message-ID: <20110621092951.1845.35025.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MN10300's asm/uaccess.h needs to #include linux/kernel.h to get might_sleep()
otherwise it fails to build on MN10300 allyesconfig.  This fails in a few
places with messages like the following:

In file included from security/keys/trusted.c:14:
include/linux/uaccess.h: In function '__copy_from_user_nocache':
include/linux/uaccess.h:52: error: implicit declaration of function 'might_sleep'

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/uaccess.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mn10300/include/asm/uaccess.h b/arch/mn10300/include/asm/uaccess.h
index 3d6e60d..780560b 100644
--- a/arch/mn10300/include/asm/uaccess.h
+++ b/arch/mn10300/include/asm/uaccess.h
@@ -15,6 +15,7 @@
  * User space memory access functions
  */
 #include <linux/thread_info.h>
+#include <linux/kernel.h>
 #include <asm/page.h>
 #include <asm/errno.h>
 

