Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab0IQNhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:37:32 -0400
Received: from mail.bspu.unibel.by ([195.50.2.21]:44455 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752244Ab0IQNhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:37:31 -0400
Message-ID: <4C936F3B.70500@bspu.unibel.by>
Date: Fri, 17 Sep 2010 16:38:03 +0300
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Reply-To: mahatma@eu.by
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b6pre) Gecko/20100902 SeaMonkey/2.1b1pre
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: acpi: Re: #2 (Re: More modaliases + patchtool))
References: <4C6BE292.3060307@bspu.unibel.by> <201008191020.52861.rusty@rustcorp.com.au> <4C6D26BC.9040805@bspu.unibel.by> <201009111144.34078.rusty@rustcorp.com.au>
In-Reply-To: <201009111144.34078.rusty@rustcorp.com.au>
Content-Type: multipart/mixed;
 boundary="------------050508010108090607050100"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050508010108090607050100
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

...




--------------050508010108090607050100
Content-Type: text/plain;
 name="mods-acpi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mods-acpi.patch"

--- linux-2.6.36-rc4-git3/drivers/platform/x86/intel_menlow.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/platform/x86/intel_menlow.c	2010-09-17 12:38:56.376753809 +0300
@@ -536,5 +536,8 @@ static void __exit intel_menlow_module_e
 	intel_menlow_unregister_sensor();
 }
 
+
+MODULE_DEVICE_TABLE(acpi, intel_menlow_memory_ids);
+
 module_init(intel_menlow_module_init);
 module_exit(intel_menlow_module_exit);
--- linux-2.6.36-rc4-git3/drivers/staging/quickstart/quickstart.c	2010-09-17 12:30:31.000000000 +0300
+++ b/drivers/staging/quickstart/quickstart.c	2010-09-17 12:39:02.903030634 +0300
@@ -470,5 +470,8 @@ fail_pfdrv_reg:
 	return ret;
 }
 
+
+MODULE_DEVICE_TABLE(acpi, quickstart_device_ids);
+
 module_init(quickstart_init);
 module_exit(quickstart_exit);
--- linux-2.6.36-rc4-git3/drivers/char/sonypi.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/char/sonypi.c	2010-09-17 12:38:43.182861196 +0300
@@ -1565,5 +1565,10 @@ static void __exit sonypi_exit(void)
 	printk(KERN_INFO "sonypi: removed.\n");
 }
 
+
+#ifdef CONFIG_ACPI
+MODULE_DEVICE_TABLE(acpi, sonypi_device_ids);
+#endif
+
 module_init(sonypi_init);
 module_exit(sonypi_exit);

--------------050508010108090607050100--
