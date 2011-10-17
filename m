Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab1JQKke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 06:40:34 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:42707 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752574Ab1JQKk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 06:40:29 -0400
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 01/10] x86: Add missing bzImage fields to struct setup_header
Date: Mon, 17 Oct 2011 11:40:08 +0100
Message-Id: <1318848017-12301-2-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

commit 37ba7ab5e33c ("x86, boot: make kernel_alignment adjustable; new
bzImage fields") introduced some new fields into the bzImage header
but struct setup_header was not updated accordingly. Add the missing
'pref_address' and 'init_size' fields.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
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

