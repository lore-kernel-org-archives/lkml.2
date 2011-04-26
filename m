Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab1DZBiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 21:38:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52765 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732Ab1DZBiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 21:38:11 -0400
Date: Mon, 25 Apr 2011 18:37:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: <pefoley2@verizon.net>, David Rientjes <rientjes@google.com>
Cc: <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
        torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] init: restore the EXPERT kconfig menu
Message-Id: <20110425183723.36c80ae1.randy.dunlap@oracle.com>
In-Reply-To: <4DB61913.6090907@verizon.net>
References: <4DB61913.6090907@verizon.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DB621DD.009A:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011 21:00:03 -0400 Peter Foley wrote:

> This patch changes CONFIG_EXPERT from a menuconfig to a config
> because it no longer has any child items and is therefore an empty menu.
> 
> Signed-off-by: Peter Foley <pefoley2@verizon.net>
> ---
>  init/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 56240e7..332a2b3 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -916,7 +916,7 @@ config SYSCTL
>  config ANON_INODES
>  	bool
> 
> -menuconfig EXPERT
> +config EXPERT
>  	bool "Configure standard kernel features (expert users)"
>  	help
>  	  This option allows certain base kernel options and settings
> -- 

NAK.  Just restore the EXPERT menu.  Patch below.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Restore the EXPERT menu list -- don't inject a symbol (EMBEDDED)
that does not depend on EXPERT into the list.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Rientjes <rientjes@google.com>
---
 init/Kconfig |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- lnx-2639-rc4.orig/init/Kconfig
+++ lnx-2639-rc4/init/Kconfig
@@ -924,14 +924,6 @@ menuconfig EXPERT
           environments which can tolerate a "non-standard" kernel.
           Only use this if you really know what you are doing.
 
-config EMBEDDED
-	bool "Embedded system"
-	select EXPERT
-	help
-	  This option should be enabled if compiling the kernel for
-	  an embedded system so certain expert options are available
-	  for configuration.
-
 config UID16
 	bool "Enable 16-bit UID system calls" if EXPERT
 	depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && COMPAT) || UML || (X86_64 && IA32_EMULATION)
@@ -1104,6 +1096,14 @@ config AIO
           by some high performance threaded applications. Disabling
           this option saves about 7k.
 
+config EMBEDDED
+	bool "Embedded system"
+	select EXPERT
+	help
+	  This option should be enabled if compiling the kernel for
+	  an embedded system so certain expert options are available
+	  for configuration.
+
 config HAVE_PERF_EVENTS
 	bool
 	help
