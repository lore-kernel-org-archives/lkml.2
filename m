Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155Ab2EDVLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:11:11 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:45099 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425Ab2EDUqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:46:15 -0400
Message-Id: <20120504204228.224640293@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>
Subject: [ 45/75] efi: Add new variable attributes
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Garrett <mjg@redhat.com>

commit 41b3254c93acc56adc3c4477fef7c9512d47659e upstream.

More recent versions of the UEFI spec have added new attributes for
variables. Add them.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/efi.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -510,7 +510,18 @@ extern int __init efi_setup_pcdp_console
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
  * The type of search to perform when calling boottime->locate_handle
  */


