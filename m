Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab0JYQ5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:57:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56678 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab0JYQ5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:57:52 -0400
Message-ID: <4CC5B682.7030009@kernel.org>
Date: Mon, 25 Oct 2010 09:55:30 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, ioapic: Add debug printing when mapping for ioapic
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org> <1287882149-29275-12-git-send-email-yinghai@kernel.org>
In-Reply-To: <1287882149-29275-12-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It is in mp_register_ioapic().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -4068,6 +4068,9 @@ void __init mp_register_ioapic(int id, u
 	mp_ioapics[idx].apicaddr = address;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
+	apic_printk(APIC_VERBOSE, "mapped IOAPIC to %08lx (%08x)\n",
+			__fix_to_virt(FIX_IO_APIC_BASE_0 + idx) + (address & ~PAGE_MASK),
+			address);
 	mp_ioapics[idx].apicid = io_apic_unique_id(id);
 	mp_ioapics[idx].apicver = io_apic_get_version(idx);
 
