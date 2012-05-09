Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab2EIGI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:08:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38997 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756328Ab2EIFxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:35 -0400
Message-Id: <20120509055047.444206090@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>
Subject: [ 129/167] [PATCH] efi: Add new variable attributes
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Garrett <mjg@redhat.com>

commit 41b3254c93acc56adc3c4477fef7c9512d47659e upstream.

More recent versions of the UEFI spec have added new attributes for
variables. Add them.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/efi.h |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- linux.orig/include/linux/efi.h
+++ linux/include/linux/efi.h
@@ -383,7 +383,18 @@
 #define EFI_VARIABLE_NON_VOLATILE       0x0000000000000001
 #define EFI_VARIABLE_BOOTSERVICE_ACCESS 0x0000000000000002
 #define EFI_VARIABLE_RUNTIME_ACCESS     0x0000000000000004
+#define EFI_VARIABLE_HARDWARE_ERROR_RECORD 0x0000000000000008
+#define EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS 0x0000000000000010
+#define EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS 0x0000000000000020
+#define EFI_VARIABLE_APPEND_WRITE	0x0000000000000040
 
+#define EFI_VARIABLE_MASK 	(EFI_VARIABLE_NON_VOLATILE | \
+				EFI_VARIABLE_BOOTSERVICE_ACCESS | \
+				EFI_VARIABLE_RUNTIME_ACCESS | \
+				EFI_VARIABLE_HARDWARE_ERROR_RECORD | \
+				EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS | \
+				EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS | \
+				EFI_VARIABLE_APPEND_WRITE)
 /*
  * EFI Device Path information
  */


