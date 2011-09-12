Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab1ILOhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:37:10 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:54399 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757236Ab1ILOfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:35:00 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 01/10] x86: Add missing bzImage fields to struct setup_header
Date: Mon, 12 Sep 2011 15:34:45 +0100
Message-Id: <1315838094-2307-2-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1315838094-2307-1-git-send-email-matt@console-pimps.org>
References: <1315838094-2307-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

commit 37ba7ab5e33c ("x86, boot: make kernel_alignment adjustable; new
bzImage fields") introduced some new fields into the bzImage header
but struct setup_header was not updated accordingly. Add the missing
'pref_address' and 'init_size' fields.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/include/asm/bootparam.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
index e020d88..2f90c51 100644
--- a/arch/x86/include/asm/bootparam.h
+++ b/arch/x86/include/asm/bootparam.h
@@ -64,6 +64,8 @@ struct setup_header {
 	__u32	payload_offset;
 	__u32	payload_length;
 	__u64	setup_data;
+	__u64	pref_address;
+	__u32	init_size;
 } __attribute__((packed));
 
 struct sys_desc_table {
-- 
1.7.4.4

