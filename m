Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab0LXTGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 14:06:22 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19431 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab0LXTGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 14:06:20 -0500
Date: Fri, 24 Dec 2010 19:56:28 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: ibm-acpi-devel@lists.sourceforge.net
cc: Borislav Deianov <borislav@users.sf.net>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI Thinkpad: We must always call va_end() after va_start()
 but do not do so in thinkpad_acpi.c::acpi_evalf()
Message-ID: <alpine.LNX.2.00.1012241952200.28973@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In drivers/platform/x86/thinkpad_acpi.c::acpi_evalf() we don't always call 
va_end() after va_start(). This patch corrects that.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 thinkpad_acpi.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index e8c2199..d053c0e 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -589,6 +589,7 @@ static int acpi_evalf(acpi_handle handle,
 		default:
 			printk(TPACPI_ERR "acpi_evalf() called "
 			       "with invalid format character '%c'\n", c);
+			va_end(ap);
 			return 0;
 		}
 	}



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

