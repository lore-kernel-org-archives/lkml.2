Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0DMQrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 12:47:11 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:22524 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab0DMQrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 12:47:09 -0400
Date: Tue, 13 Apr 2010 09:45:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Matthew Garrett <mjg@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       platform-driver-x86@vger.kernel.org
Subject: [PATCH -next] eeepc-wmi: depends on INPUT_SPARSEKMAP
Message-Id: <20100413094544.38369da9.randy.dunlap@oracle.com>
In-Reply-To: <20100413163427.8acd04e5.sfr@canb.auug.org.au>
References: <20100413163427.8acd04e5.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BC49FE0.0135:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

When EEEPC_WMI=y and INPUT_SPARSEKMAP=m, the build fails,
so make EEEPC_WMI depend on INPUT_SPARSEKMAP.

eeepc-wmi.c:(.text+0x28d1a9): undefined reference to `sparse_keymap_setup'
eeepc-wmi.c:(.text+0x28d1f9): undefined reference to `sparse_keymap_free'
eeepc-wmi.c:(.text+0x28d2e0): undefined reference to `sparse_keymap_report_event'
eeepc-wmi.c:(.init.text+0x17069): undefined reference to `sparse_keymap_free'
eeepc-wmi.c:(.exit.text+0x2bae): undefined reference to `sparse_keymap_free'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/platform/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100413.orig/drivers/platform/x86/Kconfig
+++ linux-next-20100413/drivers/platform/x86/Kconfig
@@ -388,7 +388,7 @@ config EEEPC_LAPTOP
 config EEEPC_WMI
 	tristate "Eee PC WMI Hotkey Driver (EXPERIMENTAL)"
 	depends on ACPI_WMI
-	depends on INPUT
+	depends on INPUT && INPUT_SPARSEKMAP
 	depends on EXPERIMENTAL
 	---help---
 	  Say Y here if you want to support WMI-based hotkeys on Eee PC laptops.
