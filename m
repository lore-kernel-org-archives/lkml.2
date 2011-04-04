Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab1DDWNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:13:31 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:57153 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755719Ab1DDWMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:12:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=kVNUbFP5F2ngg+YRElpW2Rj3qv/Zib5YWqK23en7geNgTiy5VvzrrlJi4rct8E4Kes1yQjqOre96UBPr9laj79ItZiT69HMVLjKLOfjr0W1IYJnHkfEPAtdahVfMTPG6;
Date: Mon, 4 Apr 2011 15:06:44 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>, Daniel Baluta <dbaluta@ixiacom.com>
Cc: torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6/8] kemleak-test: build as module only
Message-Id: <20110404150644.e391d7a1.rdunlap@xenotime.net>
In-Reply-To: <20110404145803.8663081d.rdunlap@xenotime.net>
References: <20110404145803.8663081d.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Baluta <dbaluta@ixiacom.com>

mm/kmemleak-test.c is used to provide an example of how kmemleak
tool works.

Memory is leaked at module unload-time, so building the test
in kernel (Y) makes the leaks impossible and the test useless.

Qualify DEBUG_KMEMLEAK_TEST config symbol with "depends on m",
to restrict module-only building.

Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 lib/Kconfig.debug |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- linux-2.6.38-git18.orig/lib/Kconfig.debug
+++ linux-2.6.38-git18/lib/Kconfig.debug
@@ -434,11 +434,9 @@ config DEBUG_KMEMLEAK_EARLY_LOG_SIZE
 
 config DEBUG_KMEMLEAK_TEST
 	tristate "Simple test for the kernel memory leak detector"
-	depends on DEBUG_KMEMLEAK
+	depends on DEBUG_KMEMLEAK && m
 	help
-	  Say Y or M here to build a test for the kernel memory leak
-	  detector. This option enables a module that explicitly leaks
-	  memory.
+	  This option enables a module that explicitly leaks memory.
 
 	  If unsure, say N.
 
