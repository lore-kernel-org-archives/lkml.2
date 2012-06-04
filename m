Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab2FDEcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 00:32:18 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:55069 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab2FDEcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 00:32:15 -0400
Message-ID: <4FCC3A4C.2080407@kernel.org>
Date: Mon, 04 Jun 2012 00:32:12 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH -next] acpi: fix acpi_bus.h warnings when ACPI is not
 enabled
References: <20120523170740.ae058d8d5468d471eb948c39@canb.auug.org.au> <4FBD0CDD.6010003@xenotime.net>
In-Reply-To: <4FBD0CDD.6010003@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,
with your patch applied and CONFIG_ACPI=n, I still get:

include/acpi/acpi_bus.h:445:12: warning: ‘register_acpi_bus_type’ defined but not used [-Wunused-function]
include/acpi/acpi_bus.h:446:12: warning: ‘unregister_acpi_bus_type’ defined but not used [-Wunused-function]

so I think I prefer the patch below.

thanks,
Len Brown, Intel Open Source Technology Center

On 05/23/2012 12:14 PM, Randy Dunlap wrote:

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix header file warnings when CONFIG_ACPI is not enabled:
> 
> include/acpi/acpi_bus.h:443:42: warning: 'struct acpi_bus_type' declared inside parameter list
> include/acpi/acpi_bus.h:443:42: warning: its scope is only this definition or declaration, which is probably not what you want
> include/acpi/acpi_bus.h:444:44: warning: 'struct acpi_bus_type' declared inside parameter list
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  include/acpi/acpi_bus.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- linux-next-20120523.orig/include/acpi/acpi_bus.h
> +++ linux-next-20120523/include/acpi/acpi_bus.h
> @@ -440,6 +440,8 @@ static inline int acpi_pm_device_sleep_w
>  
>  #else	/* CONFIG_ACPI */
>  
> +struct acpi_bus_type;
> +
>  static int register_acpi_bus_type(struct acpi_bus_type *bus) { return 0; }
>  static int unregister_acpi_bus_type(struct acpi_bus_type *bus) { return 0; }
>  


Subject: [PATCH] ACPI: fix acpi_bus.h build warnings when ACPI is not enabled

introduced in Linux-3.5-rc1 by
66886d6f8c9bcdee3d7fce5796dcffd6b4bc0b48
(ACPI: Add stubs for (un)register_acpi_bus_type)

Fix header file warnings when CONFIG_ACPI is not enabled:

include/acpi/acpi_bus.h:443:42: warning: 'struct acpi_bus_type' declared inside parameter list
include/acpi/acpi_bus.h:443:42: warning: its scope is only this definition or declaration, which is probably not
include/acpi/acpi_bus.h:444:44: warning: 'struct acpi_bus_type' declared inside parameter list

Signed-off-by: Len Brown <len.brown@intel.com>
---
 include/acpi/acpi_bus.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index b0d6282..9e6e1c6 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -440,8 +440,8 @@ static inline int acpi_pm_device_sleep_wake(struct device *dev, bool enable)
 
 #else	/* CONFIG_ACPI */
 
-static int register_acpi_bus_type(struct acpi_bus_type *bus) { return 0; }
-static int unregister_acpi_bus_type(struct acpi_bus_type *bus) { return 0; }
+static inline int register_acpi_bus_type(void *bus) { return 0; }
+static inline int unregister_acpi_bus_type(void *bus) { return 0; }
 
 #endif				/* CONFIG_ACPI */
 
-- 
1.7.11.rc0.100.g5498c5f
