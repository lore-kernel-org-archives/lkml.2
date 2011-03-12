Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab1CLBnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 20:43:50 -0500
Received: from smtp-out.google.com ([216.239.44.51]:59399 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab1CLBnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 20:43:45 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=dQDcIW/R/3uc9NqKPoy2Zev39OCGiwOxTfIrSeQLbrYFa5OP48eaq06yR0UH3faXs
	sBu8ZxhqdXIEDgVAwozeA==
Subject: [PATCH v2 07/12] efivars: Add Documentation
To: Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
From: Mike Waychison <mikew@google.com>
Cc: Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Date: Fri, 11 Mar 2011 17:43:32 -0800
Message-ID: <20110312014332.6133.53355.stgit@mike.mtv.corp.google.com>
In-Reply-To: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch documents the interface exposed by the 'efivars' module.

Signed-off-by: Mike Waychison <mikew@google.com>
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

