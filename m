Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab1CPVVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:21:00 -0400
Received: from kroah.org ([198.145.64.141]:60920 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548Ab1CPVMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:12:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Waychison <mikew@google.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 49/50] efivars: Add Documentation
Date: Wed, 16 Mar 2011 14:11:27 -0700
Message-Id: <1300309888-5028-49-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Waychison <mikew@google.com>

This patch documents the interface exposed by the 'efivars' module.

Signed-off-by: Mike Waychison <mikew@google.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>,
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/ABI/stable/sysfs-firmware-efi-vars |   75 ++++++++++++++++++++++
 1 files changed, 75 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-firmware-efi-vars

diff --git a/Documentation/ABI/stable/sysfs-firmware-efi-vars b/Documentation/ABI/stable/sysfs-firmware-efi-vars
new file mode 100644
index 0000000..5def20b
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-firmware-efi-vars
@@ -0,0 +1,75 @@
+What:		/sys/firmware/efi/vars
+Date:		April 2004
+Contact:	Matt Domsch <Matt_Domsch@dell.com>
+Description:
+		This directory exposes interfaces for interactive with
+		EFI variables.  For more information on EFI variables,
+		see 'Variable Services' in the UEFI specification
+		(section 7.2 in specification version 2.3 Errata D).
+
+		In summary, EFI variables are named, and are classified
+		into separate namespaces through the use of a vendor
+		GUID.  They also have an arbitrary binary value
+		associated with them.
+
+		The efivars module enumerates these variables and
+		creates a separate directory for each one found.  Each
+		directory has a name of the form "<key>-<vendor guid>"
+		and contains the following files:
+
+		attributes:	A read-only text file enumerating the
+				EFI variable flags.  Potential values
+				include:
+
+				EFI_VARIABLE_NON_VOLATILE
+				EFI_VARIABLE_BOOTSERVICE_ACCESS
+				EFI_VARIABLE_RUNTIME_ACCESS
+				EFI_VARIABLE_HARDWARE_ERROR_RECORD
+				EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS
+
+				See the EFI documentation for an
+				explanation of each of these variables.
+
+		data:		A read-only binary file that can be read
+				to attain the value of the EFI variable
+
+		guid:		The vendor GUID of the variable.  This
+				should always match the GUID in the
+				variable's name.
+
+		raw_var:	A binary file that can be read to obtain
+				a structure that contains everything
+				there is to know about the variable.
+				For structure definition see "struct
+				efi_variable" in the kernel sources.
+
+				This file can also be written to in
+				order to update the value of a variable.
+				For this to work however, all fields of
+				the "struct efi_variable" passed must
+				match byte for byte with the structure
+				read out of the file, save for the value
+				portion.
+
+				**Note** the efi_variable structure
+				read/written with this file contains a
+				'long' type that may change widths
+				depending on your underlying
+				architecture.
+
+		size:		As ASCII representation of the size of
+				the variable's value.
+
+
+		In addition, two other magic binary files are provided
+		in the top-level directory and are used for adding and
+		removing variables:
+
+		new_var:	Takes a "struct efi_variable" and
+				instructs the EFI firmware to create a
+				new variable.
+
+		del_var:	Takes a "struct efi_variable" and
+				instructs the EFI firmware to remove any
+				variable that has a matching vendor GUID
+				and variable key name.
-- 
1.7.4.1

