Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760522Ab2EWQOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:14:22 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:41718 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751924Ab2EWQOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:14:21 -0400
Message-ID: <4FBD0CDD.6010003@xenotime.net>
Date: Wed, 23 May 2012 09:14:21 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: [PATCH -next] acpi: fix acpi_bus.h warnings when ACPI is not enabled
References: <20120523170740.ae058d8d5468d471eb948c39@canb.auug.org.au>
In-Reply-To: <20120523170740.ae058d8d5468d471eb948c39@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix header file warnings when CONFIG_ACPI is not enabled:

include/acpi/acpi_bus.h:443:42: warning: 'struct acpi_bus_type' declared inside parameter list
include/acpi/acpi_bus.h:443:42: warning: its scope is only this definition or declaration, which is probably not what you want
include/acpi/acpi_bus.h:444:44: warning: 'struct acpi_bus_type' declared inside parameter list

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 include/acpi/acpi_bus.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20120523.orig/include/acpi/acpi_bus.h
+++ linux-next-20120523/include/acpi/acpi_bus.h
@@ -440,6 +440,8 @@ static inline int acpi_pm_device_sleep_w
 
 #else	/* CONFIG_ACPI */
 
+struct acpi_bus_type;
+
 static int register_acpi_bus_type(struct acpi_bus_type *bus) { return 0; }
 static int unregister_acpi_bus_type(struct acpi_bus_type *bus) { return 0; }
 
