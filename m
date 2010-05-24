Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728Ab0EXXHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:07:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:55325 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758405Ab0EXXHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:07:30 -0400
Date: Mon, 24 May 2010 23:07:07 GMT
From: tip-bot for Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, julia@diku.dk, hpa@zytor.com,
       mingo@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
       hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, julia@diku.dk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <201005241913.o4OJDG3R010871@imap1.linux-foundation.org>
References: <201005241913.o4OJDG3R010871@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] arch/x86/pci: use kasprintf
Message-ID: <tip-b46fc5f235be04a7f77fb2af1d8cb809889c25c1@git.kernel.org>
Git-Commit-ID: b46fc5f235be04a7f77fb2af1d8cb809889c25c1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 24 May 2010 23:07:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b46fc5f235be04a7f77fb2af1d8cb809889c25c1
Gitweb:     http://git.kernel.org/tip/b46fc5f235be04a7f77fb2af1d8cb809889c25c1
Author:     Julia Lawall <julia@diku.dk>
AuthorDate: Mon, 24 May 2010 12:13:16 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 24 May 2010 13:31:45 -0700

arch/x86/pci: use kasprintf

kasprintf combines kmalloc and sprintf, and takes care of the size
calculation itself.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression a,flag;
expression list args;
statement S;
@@

  a =
-  \(kmalloc\|kzalloc\)(...,flag)
+  kasprintf(flag,args)
  <... when != a
  if (a == NULL || ...) S
  ...>
- sprintf(a,args);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
LKML-Reference: <201005241913.o4OJDG3R010871@imap1.linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/pci/acpi.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 31930fd..7c0ad63 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -207,10 +207,9 @@ get_current_resources(struct acpi_device *device, int busnum,
 	if (!info.res)
 		goto res_alloc_fail;
 
-	info.name = kmalloc(16, GFP_KERNEL);
+	info.name = kasprintf(GFP_KERNEL, "PCI Bus %04x:%02x", domain, busnum);
 	if (!info.name)
 		goto name_alloc_fail;
-	sprintf(info.name, "PCI Bus %04x:%02x", domain, busnum);
 
 	info.res_num = 0;
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, setup_resource,
