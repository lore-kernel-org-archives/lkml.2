Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab0CSLsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 07:48:20 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55988 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab0CSLsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 07:48:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=DvEGbMUCOHip9UXjksgqfspO67Rqm1oAuXtVmSVqOgnOOZJaKEgA4pSSLkQEW0PbDO
         KaVvEkytDXiRZTZ4gInrPpTXNEAdVNnrgX1vx65zXSTDOx6R1mBZHfH9OR3GnIW/pnW9
         hVRmNT2gIxlMwrCxwAwnVh8A82q2o7LKgl6d4=
Date: Fri, 19 Mar 2010 14:48:06 +0300
From: Dan Carpenter <error27@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Chen Gong <gong.chen@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] acpi_pad: "processor_aggregator" name too long
Message-ID: <20100319114806.GN5331@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Shaohua Li <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chen Gong <gong.chen@linux.intel.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpi_device_class can only be 19 characters and a NULL terminator.

With the current name we get a buffer overflow in acpi_pad_add()
        strcpy(acpi_device_class(device), ACPI_PROCESSOR_AGGREGATOR_CLASS);

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Feel free to pick your own name if you don't like mine.  :)


diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index 7e52295..2db89d9 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -30,7 +30,7 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
-#define ACPI_PROCESSOR_AGGREGATOR_CLASS	"processor_aggregator"
+#define ACPI_PROCESSOR_AGGREGATOR_CLASS	"proc_aggregator"
 #define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
 #define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
 static DEFINE_MUTEX(isolated_cpus_lock);
