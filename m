Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab1GJUAi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 16:00:38 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:51912 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754922Ab1GJUAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 16:00:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Fxf/NEsHGnCV3bY8VeRP1g7zs9xhBmo4Z6PFZIO5FuP5/tm6yYqu1YIgbxeqSQUgur/4AhlnC+S4J22SrfL0Jt14i/hK45KsgE3IMfclMDcXACbQOZgJBoG0s88QL57z;
Date: Sun, 10 Jul 2011 12:51:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-kbuild@vger.kernel.org, linux-media@vger.kernel.org,
        mchehab@infradead.org
Subject: [PATCH 1/9] stringify: add HEX_STRING()
Message-Id: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Add HEX_STRING(value) to stringify.h so that drivers can
convert kconfig hex values (without leading "0x") to useful
hex constants.

Several drivers/media/radio/ drivers need this.  I haven't
checked if any other drivers need to do this.

Alternatively, kconfig could produce hex config symbols with
leading "0x".

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 include/linux/stringify.h |    7 +++++++
 1 file changed, 7 insertions(+)

NOTE: The other 8 patches are on lkml and linux-media mailing lists.

--- linux-next-20110707.orig/include/linux/stringify.h
+++ linux-next-20110707/include/linux/stringify.h
@@ -9,4 +9,11 @@
 #define __stringify_1(x...)	#x
 #define __stringify(x...)	__stringify_1(x)
 
+/*
+ * HEX_STRING(value) is useful for CONFIG_ values that are in hex,
+ * but kconfig does not put a leading "0x" on them.
+ */
+#define HEXSTRINGVALUE(h, value)	h##value
+#define HEX_STRING(value)		HEXSTRINGVALUE(0x, value)
+
 #endif	/* !__LINUX_STRINGIFY_H */
