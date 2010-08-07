Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762455Ab0HGCSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 22:18:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37728 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762433Ab0HGCSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 22:18:02 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 00/10] x86: clean up using smp_register_lapic_address()
Date: Fri,  6 Aug 2010 19:15:33 -0700
Message-Id: <1281147343-18389-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge acpi_register_lapic_address, smp_register_lapic_address, sfi_register_lapic_address

Thanks

Yinghai Lu

[PATCH 01/10] x86: Fix lapic mapping with construct ISA and visws mptable path
[PATCH 02/10] x86, acpi: merge two register_lapic_address()
[PATCH 03/10] x86: remove early_init_lapic_mapping
[PATCH 04/10] x86: call smp_register_lapic_address for contruct_default mptable path
[PATCH 05/10] x86, apic: use smp_register_lapic_address in init_apic_mapping
[PATCH 06/10] x86, sfi: used smp_register_lapic_address
[PATCH 07/10] x86,visws: set_fixmap in find_smp_config
[PATCH 08/10] x86: !find_smp_config path use smp_register_lapic_address
[PATCH 09/10] x86, apic: set fixmap only one time
[PATCH 10/10] x86, ioapic: only print mapping for ioapic in right place

 arch/x86/include/asm/apic.h    |    2 +-
 arch/x86/kernel/acpi/boot.c    |   16 +----------
 arch/x86/kernel/apic/apic.c    |   54 +++++++++++++++++----------------------
 arch/x86/kernel/apic/io_apic.c |   11 +++++---
 arch/x86/kernel/mpparse.c      |   24 +++--------------
 arch/x86/kernel/sfi.c          |   13 +---------
 arch/x86/kernel/visws_quirks.c |    1 +
 arch/x86/mm/k8topology_64.c    |    1 -
 8 files changed, 40 insertions(+), 82 deletions(-)
