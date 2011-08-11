Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab1HKK75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 06:59:57 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:53848 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753458Ab1HKK7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 06:59:51 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 2/9] efi.h: Add struct definition for boot time services
Date: Thu, 11 Aug 2011 11:59:39 +0100
Message-Id: <1313060386-4858-3-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313060386-4858-1-git-send-email-matt@console-pimps.org>
References: <1313060386-4858-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

With the forthcoming efi stub code we're gonna need to access boot
time services so let's define a struct so we can access the functions.

Cc: Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
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
-- 
1.7.4.4

