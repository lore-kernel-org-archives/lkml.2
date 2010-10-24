Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289Ab0JXBGA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 21:06:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48266 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759070Ab0JXBFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 21:05:10 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 00/15] x86: APIC related clean up
Date: Sat, 23 Oct 2010 18:02:14 -0700
Message-Id: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Merge acpi_register_lapic_address, smp_register_lapic_address, sfi_register_lapic_address

2. nox2apic support: disable x2apic for preenabled system or kexec path.

Thanks

Yinghai Lu

71fee2d: x86: Disabling x2apic if nox2apic is specified
017b8d0: acpi: Reverse uid and apic_id print out for x2apic
0c2a5ca: x86, apic, acpi: Handle xapic/x2apic entries in MADT at same time
88c4f93: x86, x2apic: Don't map lapic addr for preenabled x2apic
7084cf3: x86, ioapic: Only print mapping for ioapic in right place
d4c4263: x86, apic: Set fixmap only one time
19fafd5: x86: on !find_smp_config path use smp_register_lapic_address
74c3593: x86, visws: Set_fixmap in find_smp_config
039ff68: x86, sfi: Use smp_register_lapic_address()
6f13e6a: x86, apic: Use smp_register_lapic_address in init_apic_mapping
48c02b1: x86: Call smp_register_lapic_address for contruct_default mptable path
d2f3d61: x86, apic: Remove early_init_lapic_mapping
3887e09: x86, apic: Merge two register_lapic_address()
703583d: x86, apic: Fix lapic mapping with construct ISA and visws mptable path
a2bd134: x86, apic: Don't write io_apic ID if it is not changed

 arch/x86/include/asm/apic.h    |    8 +++-
 arch/x86/include/asm/apicdef.h |    1 +
 arch/x86/kernel/acpi/boot.c    |   61 +++++++++++++---------
 arch/x86/kernel/apic/apic.c    |  110 +++++++++++++++++++++++++---------------
 arch/x86/kernel/apic/io_apic.c |   19 ++++---
 arch/x86/kernel/mpparse.c      |   24 ++-------
 arch/x86/kernel/sfi.c          |   13 +----
 arch/x86/kernel/visws_quirks.c |    1 +
 arch/x86/mm/k8topology_64.c    |    1 -
 arch/x86/mm/srat_64.c          |   12 ++++-
 drivers/acpi/numa.c            |   18 +++++--
 drivers/acpi/tables.c          |   60 ++++++++++++++++------
 include/linux/acpi.h           |    8 +++
 13 files changed, 207 insertions(+), 129 deletions(-)

