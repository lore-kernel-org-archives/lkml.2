Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab0IRG1j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 02:27:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55207 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab0IRG1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 02:27:38 -0400
Message-ID: <4C945B90.5060306@kernel.org>
Date: Fri, 17 Sep 2010 23:26:24 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Brown, Len" <len.brown@intel.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Lin Ming <ming.m.lin@intel.com>,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH -v4] acpi: Handle ACPI0007 Device in acpi_early_set_pdc
References: <4C89906B.1050406@kernel.org> <201009131128.42519.bjorn.helgaas@hp.com> <4C931714.2080905@kernel.org> <201009170756.53100.bjorn.helgaas@hp.com>
In-Reply-To: <201009170756.53100.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After
| commit d8191fa4a33fdc817277da4f2b7f771ff605a41c
| Author: Alex Chiang <achiang@hp.com>
| Date:   Mon Feb 22 12:11:39 2010 -0700
|
|    ACPI: processor: driver doesn't need to evaluate _PDC
|
|    Now that the early _PDC evaluation path knows how to correctly
|    evaluate _PDC on only physically present processors, there's no
|    need for the processor driver to evaluate it later when it loads.
|
|    To cover the hotplug case, push _PDC evaluation down into the
|    hotplug paths.

only cpu with Processor Statement get processed with _PDC

If bios is using Device object instead of Processor statement.
SSDTs for Pstate/Cstate/Tstate can not be loaded dynamically.

Need to try to scan ACPI0007 in addition to Processor.

That commit is between 2.6.34-rc1 and 2.6.34-rc2, so stable tree for 2.6.34+
need this patch.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/acpi/processor_core.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/acpi/processor_core.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_core.c
+++ linux-2.6/drivers/acpi/processor_core.c
@@ -352,4 +352,5 @@ void __init acpi_early_processor_set_pdc
 	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
 			    ACPI_UINT32_MAX,
 			    early_init_pdc, NULL, NULL, NULL);
+	acpi_get_devices("ACPI0007", early_init_pdc, NULL, NULL);
 }
