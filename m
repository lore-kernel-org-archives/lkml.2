Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab1LJCjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 21:39:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48790 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab1LJCjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 21:39:07 -0500
Date: Fri, 9 Dec 2011 18:38:57 -0800
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-f30ca6ba0bb2b7d050f24682bb8639c939c79859@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com,
        matt.fleming@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        matt.fleming@intel.com, hpa@linux.intel.com
In-Reply-To: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] efi.h: Add struct definition for boot time services
Git-Commit-ID: f30ca6ba0bb2b7d050f24682bb8639c939c79859
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Dec 2011 18:39:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f30ca6ba0bb2b7d050f24682bb8639c939c79859
Gitweb:     http://git.kernel.org/tip/f30ca6ba0bb2b7d050f24682bb8639c939c79859
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Tue, 15 Nov 2011 12:56:32 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 Dec 2011 17:35:40 -0800

efi.h: Add struct definition for boot time services

With the forthcoming efi stub code we're gonna need to access boot
time services so let's define a struct so we can access the functions.

Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1318848017-12301-1-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/linux/efi.h |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 2362a0b..9547597 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -139,6 +139,57 @@ typedef struct {
 } efi_time_cap_t;
 
 /*
+ * EFI Boot Services table
+ */
+typedef struct {
+	efi_table_hdr_t hdr;
+	void *raise_tpl;
+	void *restore_tpl;
+	void *allocate_pages;
+	void *free_pages;
+	void *get_memory_map;
+	void *allocate_pool;
+	void *free_pool;
+	void *create_event;
+	void *set_timer;
+	void *wait_for_event;
+	void *signal_event;
+	void *close_event;
+	void *check_event;
+	void *install_protocol_interface;
+	void *reinstall_protocol_interface;
+	void *uninstall_protocol_interface;
+	void *handle_protocol;
+	void *__reserved;
+	void *register_protocol_notify;
+	void *locate_handle;
+	void *locate_device_path;
+	void *install_configuration_table;
+	void *load_image;
+	void *start_image;
+	void *exit;
+	void *unload_image;
+	void *exit_boot_services;
+	void *get_next_monotonic_count;
+	void *stall;
+	void *set_watchdog_timer;
+	void *connect_controller;
+	void *disconnect_controller;
+	void *open_protocol;
+	void *close_protocol;
+	void *open_protocol_information;
+	void *protocols_per_handle;
+	void *locate_handle_buffer;
+	void *locate_protocol;
+	void *install_multiple_protocol_interfaces;
+	void *uninstall_multiple_protocol_interfaces;
+	void *calculate_crc32;
+	void *copy_mem;
+	void *set_mem;
+	void *create_event_ex;
+} efi_boot_services_t;
+
+/*
  * Types and defines for EFI ResetSystem
  */
 #define EFI_RESET_COLD 0
@@ -261,7 +312,7 @@ typedef struct {
 	unsigned long stderr_handle;
 	unsigned long stderr;
 	efi_runtime_services_t *runtime;
-	unsigned long boottime;
+	efi_boot_services_t *boottime;
 	unsigned long nr_tables;
 	unsigned long tables;
 } efi_system_table_t;
