Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0CYOlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:41:37 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34366 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab0CYOld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:41:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=hsRpqwtlIoZRIkE7yDjh1p8IAHzKDmroo86exRF6BBkYOgX6jOzG97BJudf2bFp9rl
         YkaSukfZK6NC0hxMpqPCmpOcS6e05E7x3JNyqW5d+HWbZG5cyBPyXn27MvsPeA73HzjC
         NN2tEWCBDj9Yy7q7xpWB/lAR9SBGYxKYPBep0=
Date: Thu, 25 Mar 2010 17:41:22 +0300
From: Dan Carpenter <error27@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Shaohua Li <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chen Gong <gong.chen@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v2] acpi_pad: "processor_aggregator" name too long
Message-ID: <20100325144122.GF5069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Pavel Machek <pavel@ucw.cz>, Shaohua Li <shaohua.li@intel.com>,
	Len Brown <lenb@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chen Gong <gong.chen@linux.intel.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20100319114806.GN5331@bicker> <20100325142738.GD1602@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325142738.GD1602@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpi_device_class can only be 19 characters and a NULL terminator.

With the current name we get a buffer overflow in acpi_pad_add()
	strcpy(acpi_device_class(device), ACPI_PROCESSOR_AGGREGATOR_CLASS);

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
V2: Thanks to Pavel Machek for coming up with the right name for this.

diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index 7e52295..790aaa1 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -30,7 +30,7 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
-#define ACPI_PROCESSOR_AGGREGATOR_CLASS	"processor_aggregator"
+#define ACPI_PROCESSOR_AGGREGATOR_CLASS	"cpu_aggregator"
 #define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
 #define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
 static DEFINE_MUTEX(isolated_cpus_lock);
