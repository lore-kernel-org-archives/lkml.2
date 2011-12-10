Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab1LJChh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 21:37:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48770 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab1LJChf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 21:37:35 -0500
Date: Fri, 9 Dec 2011 18:37:24 -0800
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-8af21e7e71d1ac56d9b66fb787a14fd66af7f5f7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, matt.fleming@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, matt.fleming@intel.com, hpa@linux.intel.com
In-Reply-To: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86: Add missing bzImage fields to struct setup_header
Git-Commit-ID: 8af21e7e71d1ac56d9b66fb787a14fd66af7f5f7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Dec 2011 18:37:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8af21e7e71d1ac56d9b66fb787a14fd66af7f5f7
Gitweb:     http://git.kernel.org/tip/8af21e7e71d1ac56d9b66fb787a14fd66af7f5f7
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Sat, 27 Aug 2011 09:35:45 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 Dec 2011 17:35:33 -0800

x86: Add missing bzImage fields to struct setup_header

commit 37ba7ab5e33c ("x86, boot: make kernel_alignment adjustable; new
bzImage fields") introduced some new fields into the bzImage header
but struct setup_header was not updated accordingly. Add the missing
'pref_address' and 'init_size' fields.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1318848017-12301-1-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
