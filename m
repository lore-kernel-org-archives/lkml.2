Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab0KANoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 09:44:01 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40806 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab0KANoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 09:44:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 1 Nov 2010 14:43:29 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: 2.6.37-rc1: section mismatches
To: Shaohua Li <shaohua.li@intel.com>, Stephane Eranian <eranian@google.com>,
        Len Brown <len.brown@intel.com>
cc: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Message-ID: <tkrat.725fc810c3a4881e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three new section mismatches have been introduced:

----
WARNING: vmlinux.o(.text+0x26e8c): Section mismatch in reference from the function tlb_cpuhp_notify() to the function .cpuinit.text:calculate_tlb_offset()
The function tlb_cpuhp_notify() references
the function __cpuinit calculate_tlb_offset().
This is often because tlb_cpuhp_notify lacks a __cpuinit 
annotation or the annotation of calculate_tlb_offset is wrong.

apparently due to commit 932967202182743c01a2eee4bdfa2c42697bc586

----
WARNING: vmlinux.o(.text+0x71f47): Section mismatch in reference from the function proc_dowatchdog_enabled() to the variable .init.data:no_watchdog
The function proc_dowatchdog_enabled() references
the variable __initdata no_watchdog.
This is often because proc_dowatchdog_enabled lacks a __initdata 
annotation or the annotation of no_watchdog is wrong.

apparently due to commit d9ca07a05ce1c42ac9717e54eaea4546a3a80978

----
WARNING: vmlinux.o(.text+0x17147f): Section mismatch in reference from the function acpi_os_initialize1() to the function .init.text:acpi_osi_setup_late()
The function acpi_os_initialize1() references
the function __init acpi_osi_setup_late().
This is often because acpi_os_initialize1 lacks a __init 
annotation or the annotation of acpi_osi_setup_late is wrong.

by merge commit 1bd64d42abdd4f9d44f77011a31f0292112f4c3b or one of the
parents
-- 
Stefan Richter
-=====-==-=- =-== ----=
http://arcgraph.de/sr/

