Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab1CRXu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 19:50:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21899 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757620Ab1CRXuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 19:50:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=NjetivRMJURq5ZjRNYFPATbljR3WquhLlYKAbd5UqYgS3XeD+N1PQE4FIQk55WzzG
	wYy/O7GscSJi7l09hP58g==
From: Mike Waychison <mikew@google.com>
To: Valdis.Kletnieks@vt.edu
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Mike Waychison <mikew@google.com>
Subject: [PATCH] firmware: Fix grammar in sysfs-firmware-dmi doc
Date: Fri, 18 Mar 2011 16:50:03 -0700
Message-Id: <1300492203-15263-1-git-send-email-mikew@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <27993.1300481607@localhost>
References: <27993.1300481607@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the grammar in describing the position attribute of DMI entries in
the dmi-sysfs module.  While here, make a couple other small clarifying
fixups to the docs.

Reported-by: <Valdis.Kletnieks@vt.edu>
Signed-off-by: Mike Waychison <mikew@google.com>
---
 Documentation/ABI/testing/sysfs-firmware-dmi |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-firmware-dmi b/Documentation/ABI/testing/sysfs-firmware-dmi
index ba9da95..c78f9ab 100644
--- a/Documentation/ABI/testing/sysfs-firmware-dmi
+++ b/Documentation/ABI/testing/sysfs-firmware-dmi
@@ -14,14 +14,15 @@ Description:
 
 		DMI is structured as a large table of entries, where
 		each entry has a common header indicating the type and
-		length of the entry, as well as 'handle' that is
-		supposed to be unique amongst all entries.
+		length of the entry, as well as a firmware-provided
+		'handle' that is supposed to be unique amongst all
+		entries.
 
 		Some entries are required by the specification, but many
 		others are optional.  In general though, users should
 		never expect to find a specific entry type on their
 		system unless they know for certain what their firmware
-		is doing.  Machine to machine will vary.
+		is doing.  Machine to machine experiences will vary.
 
 		Multiple entries of the same type are allowed.  In order
 		to handle these duplicate entry types, each entry is
@@ -67,25 +68,24 @@ Description:
 			  and the two terminating nul characters.
 		type	: The type of the entry.  This value is the same
 			  as found in the directory name.  It indicates
-			  how the rest of the entry should be
-			  interpreted.
+			  how the rest of the entry should be interpreted.
 		instance: The instance ordinal of the entry for the
 			  given type.  This value is the same as found
 			  in the parent directory name.
-		position: The position of the entry within the entirety
-			  of the entirety.
+		position: The ordinal position (zero-based) of the entry
+			  within the entirety of the DMI entry table.
 
 		=== Entry Specialization ===
 
 		Some entry types may have other information available in
-		sysfs.
+		sysfs.  Not all types are specialized.
 
 		--- Type 15 - System Event Log ---
 
 		This entry allows the firmware to export a log of
 		events the system has taken.  This information is
 		typically backed by nvram, but the implementation
-		details are abstracted by this table.  This entries data
+		details are abstracted by this table.  This entry's data
 		is exported in the directory:
 
 		/sys/firmware/dmi/entries/15-0/system_event_log
-- 
1.7.3.1

