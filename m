Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab0JZCyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:54:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758821Ab0JZCyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:54:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 10/43] MN10300: Differentiate AM33_2 and AM33_3 in config
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:53:55 +0100
Message-ID: <20101026025355.23512.15449.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

Differentiate AM33_2 and AM33_3 CPU cores in configuration.  The MN103E010
processor contains an AM33_2 core.

Whilst we're at it, prepare for AM34-based stuff by declaring AM34_2 too.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/Kconfig |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)


diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 7c2a2f7..275963e 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -9,8 +9,14 @@ config MN10300
 	def_bool y
 	select HAVE_OPROFILE
 
-config AM33
-	def_bool y
+config AM33_2
+	def_bool n
+
+config AM33_3
+	def_bool n
+
+config AM34_2
+	def_bool n
 
 config MMU
 	def_bool y
@@ -99,6 +105,7 @@ choice
 config MN10300_PROC_MN103E010
 	bool "MN103E010"
 	depends on MN10300_UNIT_ASB2303 || MN10300_UNIT_ASB2305
+	select AM33_2
 	select MN10300_PROC_HAS_TTYSM0
 	select MN10300_PROC_HAS_TTYSM1
 	select MN10300_PROC_HAS_TTYSM2

