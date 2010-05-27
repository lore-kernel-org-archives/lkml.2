Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab0E0QH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:07:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61720 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab0E0QHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:07:42 -0400
Date: Thu, 27 May 2010 09:07:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Jiri Kosina <jkosina@suse.cz>,
       Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: [PATCH -next] hid: roccat modules interdependencies
Message-Id: <20100527090706.6c2bc555.randy.dunlap@oracle.com>
In-Reply-To: <20100527152628.b23a14c6.sfr@canb.auug.org.au>
References: <20100527152628.b23a14c6.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090209.4BFE98C1.01C7:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

hid-roccat-kone calls the hid-roccat module interfaces,
so the former should depend on or select the latter to prevent
build errors, like:

hid-roccat-kone.c:(.text+0x133ed2): undefined reference to `roccat_report_event'
hid-roccat-kone.c:(.text+0x133fa8): undefined reference to `roccat_disconnect'
hid-roccat-kone.c:(.text+0x1353be): undefined reference to `roccat_connect'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/hid/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100527.orig/drivers/hid/Kconfig
+++ linux-next-20100527/drivers/hid/Kconfig
@@ -358,6 +358,7 @@ config HID_ROCCAT
 config HID_ROCCAT_KONE
 	tristate "Roccat Kone Mouse support"
 	depends on USB_HID
+	select HID_ROCCAT
 	---help---
 	Support for Roccat Kone mouse.
 
