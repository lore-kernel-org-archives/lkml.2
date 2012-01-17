Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab2AQNWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:22:20 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:43625 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab2AQNWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:22:15 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jan 2012 08:22:13 EST
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 17/50] ACPI 5.0: Add new predefined names
Date: Tue, 17 Jan 2012 07:21:09 -0500
Message-id: <7fce7a4b0db7d90db553faf568853d56cd908c39.1326802229.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/aclocal.h   |    3 ++-
 drivers/acpi/acpica/acpredef.h  |   39 ++++++++++++++++++++++++++++++++++++++-
 drivers/acpi/acpica/nspredef.c  |   29 +++++++++++++++++++++++++++++
 drivers/acpi/acpica/nsrepair.c  |    1 +
 drivers/acpi/acpica/nsrepair2.c |    5 +++--
 5 files changed, 73 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index 60aee56..2ddd61d 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -319,7 +319,8 @@ struct acpi_name_info {
 
 /*
  * Used for ACPI_PTYPE1_FIXED, ACPI_PTYPE1_VAR, ACPI_PTYPE2,
- * ACPI_PTYPE2_MIN, ACPI_PTYPE2_PKG_COUNT, ACPI_PTYPE2_COUNT
+ * ACPI_PTYPE2_MIN, ACPI_PTYPE2_PKG_COUNT, ACPI_PTYPE2_COUNT,
+ * ACPI_PTYPE2_FIX_VAR
  */
 struct acpi_package_info {
 	u8 type;
diff --git a/drivers/acpi/acpica/acpredef.h b/drivers/acpi/acpica/acpredef.h
index c445cca..ecac9cf 100644
--- a/drivers/acpi/acpica/acpredef.h
+++ b/drivers/acpi/acpica/acpredef.h
@@ -94,6 +94,14 @@
  * ACPI_PTYPE2_REV_FIXED: Revision at start, each subpackage is Fixed-length
  *      (Used for _ART, _FPS)
  *
+ * ACPI_PTYPE2_FIX_VAR: Each subpackage consists of some fixed-length elements
+ *      followed by an optional element
+ *      object type
+ *      count
+ *      object type
+ *      count = 0 (optional)
+ *      (Used for _DLM)
+ *
  *****************************************************************************/
 
 enum acpi_return_package_types {
@@ -105,7 +113,8 @@ enum acpi_return_package_types {
 	ACPI_PTYPE2_PKG_COUNT = 6,
 	ACPI_PTYPE2_FIXED = 7,
 	ACPI_PTYPE2_MIN = 8,
-	ACPI_PTYPE2_REV_FIXED = 9
+	ACPI_PTYPE2_REV_FIXED = 9,
+	ACPI_PTYPE2_FIX_VAR = 10
 };
 
 #ifdef ACPI_CREATE_PREDEFINED_TABLE
@@ -154,6 +163,7 @@ static const union acpi_predefined_info predefined_names[] =
 	{{"_AC8", 0, ACPI_RTYPE_INTEGER}},
 	{{"_AC9", 0, ACPI_RTYPE_INTEGER}},
 	{{"_ADR", 0, ACPI_RTYPE_INTEGER}},
+	{{"_AEI", 0, ACPI_RTYPE_BUFFER}},
 	{{"_AL0", 0, ACPI_RTYPE_PACKAGE}}, /* Variable-length (Refs) */
 			  {{{ACPI_PTYPE1_VAR, ACPI_RTYPE_REFERENCE, 0,0}, 0,0}},
 
@@ -229,6 +239,13 @@ static const union acpi_predefined_info predefined_names[] =
 	{{"_CID", 0, ACPI_RTYPE_INTEGER | ACPI_RTYPE_STRING | ACPI_RTYPE_PACKAGE}}, /* Variable-length (Ints/Strs) */
 			  {{{ACPI_PTYPE1_VAR, ACPI_RTYPE_INTEGER | ACPI_RTYPE_STRING, 0,0}, 0,0}},
 
+	{{"_CLS", 0, ACPI_RTYPE_PACKAGE}},	/* Fixed-length (3 Int) */
+	{{{ACPI_PTYPE1_FIXED, ACPI_RTYPE_INTEGER, 3, 0}, 0, 0}},
+
+	{{"_CPC", 0, ACPI_RTYPE_PACKAGE}},	/* Variable-length (Ints/Bufs) */
+	{{{ACPI_PTYPE1_VAR, ACPI_RTYPE_INTEGER | ACPI_RTYPE_BUFFER, 0, 0}, 0,
+	  0}},
+
 	{{"_CRS", 0, ACPI_RTYPE_BUFFER}},
 	{{"_CRT", 0, ACPI_RTYPE_INTEGER}},
 	{{"_CSD", 0, ACPI_RTYPE_PACKAGE}}, /* Variable-length (1 Int(n), n-1 Int) */
@@ -237,12 +254,21 @@ static const union acpi_predefined_info predefined_names[] =
 	{{"_CST", 0, ACPI_RTYPE_PACKAGE}}, /* Variable-length (1 Int(n), n Pkg (1 Buf/3 Int) */
 			  {{{ACPI_PTYPE2_PKG_COUNT,ACPI_RTYPE_BUFFER, 1, ACPI_RTYPE_INTEGER}, 3,0}},
 
+	{{"_CWS", 1, ACPI_RTYPE_INTEGER}},
 	{{"_DCK", 1, ACPI_RTYPE_INTEGER}},
 	{{"_DCS", 0, ACPI_RTYPE_INTEGER}},
 	{{"_DDC", 1, ACPI_RTYPE_INTEGER | ACPI_RTYPE_BUFFER}},
 	{{"_DDN", 0, ACPI_RTYPE_STRING}},
+	{{"_DEP", 0, ACPI_RTYPE_PACKAGE}},	/* Variable-length (Refs) */
+	{{{ACPI_PTYPE1_VAR, ACPI_RTYPE_REFERENCE, 0, 0}, 0, 0}},
+
 	{{"_DGS", 0, ACPI_RTYPE_INTEGER}},
 	{{"_DIS", 0, 0}},
+
+	{{"_DLM", 0, ACPI_RTYPE_PACKAGE}},	/* Variable-length (Pkgs) each (1 Ref, 0/1 Optional Buf/Ref) */
+	{{{ACPI_PTYPE2_FIX_VAR, ACPI_RTYPE_REFERENCE, 1,
+	   ACPI_RTYPE_REFERENCE | ACPI_RTYPE_BUFFER}, 0, 0}},
+
 	{{"_DMA", 0, ACPI_RTYPE_BUFFER}},
 	{{"_DOD", 0, ACPI_RTYPE_PACKAGE}}, /* Variable-length (Ints) */
 			  {{{ACPI_PTYPE1_VAR, ACPI_RTYPE_INTEGER, 0,0}, 0,0}},
@@ -262,6 +288,7 @@ static const union acpi_predefined_info predefined_names[] =
 	{{"_EJ3", 1, 0}},
 	{{"_EJ4", 1, 0}},
 	{{"_EJD", 0, ACPI_RTYPE_STRING}},
+	{{"_EVT", 1, 0}},
 	{{"_FDE", 0, ACPI_RTYPE_BUFFER}},
 	{{"_FDI", 0, ACPI_RTYPE_PACKAGE}}, /* Fixed-length (16 Int) */
 			  {{{ACPI_PTYPE1_FIXED, ACPI_RTYPE_INTEGER, 16,0}, 0,0}},
@@ -281,14 +308,17 @@ static const union acpi_predefined_info predefined_names[] =
 	{{{ACPI_PTYPE1_FIXED, ACPI_RTYPE_INTEGER, 3, 0}, 0, 0}},
 
 	{{"_GAI", 0, ACPI_RTYPE_INTEGER}},
+	{{"_GCP", 0, ACPI_RTYPE_INTEGER}},
 	{{"_GHL", 0, ACPI_RTYPE_INTEGER}},
 	{{"_GLK", 0, ACPI_RTYPE_INTEGER}},
 	{{"_GPD", 0, ACPI_RTYPE_INTEGER}},
 	{{"_GPE", 0, ACPI_RTYPE_INTEGER}}, /* _GPE method, not _GPE scope */
+	{{"_GRT", 0, ACPI_RTYPE_BUFFER}},
 	{{"_GSB", 0, ACPI_RTYPE_INTEGER}},
 	{{"_GTF", 0, ACPI_RTYPE_BUFFER}},
 	{{"_GTM", 0, ACPI_RTYPE_BUFFER}},
 	{{"_GTS", 1, 0}},
+	{{"_GWS", 1, ACPI_RTYPE_INTEGER}},
 	{{"_HID", 0, ACPI_RTYPE_INTEGER | ACPI_RTYPE_STRING}},
 	{{"_HOT", 0, ACPI_RTYPE_INTEGER}},
 	{{"_HPP", 0, ACPI_RTYPE_PACKAGE}}, /* Fixed-length (4 Int) */
@@ -303,6 +333,7 @@ static const union acpi_predefined_info predefined_names[] =
 	{{"_HPX", 0, ACPI_RTYPE_PACKAGE}}, /* Variable-length (Pkgs) each (var Ints) */
 			  {{{ACPI_PTYPE2_MIN, ACPI_RTYPE_INTEGER, 5,0}, 0,0}},
 
+	{{"_HRV", 0, ACPI_RTYPE_INTEGER}},
 	{{"_IFT", 0, ACPI_RTYPE_INTEGER}}, /* See IPMI spec */
 	{{"_INI", 0, 0}},
 	{{"_IRC", 0, 0}},
@@ -361,6 +392,9 @@ static const union acpi_predefined_info predefined_names[] =
 	{{"_PR3", 0, ACPI_RTYPE_PACKAGE}},	/* Variable-length (Refs) */
 	{{{ACPI_PTYPE1_VAR, ACPI_RTYPE_REFERENCE, 0, 0}, 0, 0}},
 
+	{{"_PRE", 0, ACPI_RTYPE_PACKAGE}},	/* Variable-length (Refs) */
+	{{{ACPI_PTYPE1_VAR, ACPI_RTYPE_REFERENCE, 0, 0}, 0, 0}},
+
 	{{"_PRL", 0, ACPI_RTYPE_PACKAGE}},	/* Variable-length (Refs) */
 	{{{ACPI_PTYPE1_VAR, ACPI_RTYPE_REFERENCE, 0, 0}, 0, 0}},
 
@@ -391,6 +425,7 @@ static const union acpi_predefined_info predefined_names[] =
 	{{"_PSD", 0, ACPI_RTYPE_PACKAGE}}, /* Variable-length (Pkgs) each (5 Int) with count */
 			  {{{ACPI_PTYPE2_COUNT, ACPI_RTYPE_INTEGER,0,0}, 0,0}},
 
+	{{"_PSE", 1, 0}},
 	{{"_PSL", 0, ACPI_RTYPE_PACKAGE}}, /* Variable-length (Refs) */
 			  {{{ACPI_PTYPE1_VAR, ACPI_RTYPE_REFERENCE, 0,0}, 0,0}},
 
@@ -457,6 +492,7 @@ static const union acpi_predefined_info predefined_names[] =
 	{{"_SLI", 0, ACPI_RTYPE_BUFFER}},
 	{{"_SPD", 1, ACPI_RTYPE_INTEGER}},
 	{{"_SRS", 1, 0}},
+	{{"_SRT", 1, ACPI_RTYPE_INTEGER}},
 	{{"_SRV", 0, ACPI_RTYPE_INTEGER}}, /* See IPMI spec */
 	{{"_SST", 1, 0}},
 	{{"_STA", 0, ACPI_RTYPE_INTEGER}},
@@ -464,6 +500,7 @@ static const union acpi_predefined_info predefined_names[] =
 	{{"_STP", 2, ACPI_RTYPE_INTEGER}},
 	{{"_STR", 0, ACPI_RTYPE_BUFFER}},
 	{{"_STV", 2, ACPI_RTYPE_INTEGER}},
+	{{"_SUB", 0, ACPI_RTYPE_STRING}},
 	{{"_SUN", 0, ACPI_RTYPE_INTEGER}},
 	{{"_SWS", 0, ACPI_RTYPE_INTEGER}},
 	{{"_TC1", 0, ACPI_RTYPE_INTEGER}},
diff --git a/drivers/acpi/acpica/nspredef.c b/drivers/acpi/acpica/nspredef.c
index c845c80..db80366 100644
--- a/drivers/acpi/acpica/nspredef.c
+++ b/drivers/acpi/acpica/nspredef.c
@@ -620,6 +620,7 @@ acpi_ns_check_package(struct acpi_predefined_data *data,
 	case ACPI_PTYPE2_FIXED:
 	case ACPI_PTYPE2_MIN:
 	case ACPI_PTYPE2_COUNT:
+	case ACPI_PTYPE2_FIX_VAR:
 
 		/*
 		 * These types all return a single Package that consists of a
@@ -759,6 +760,34 @@ acpi_ns_check_package_list(struct acpi_predefined_data *data,
 			}
 			break;
 
+		case ACPI_PTYPE2_FIX_VAR:
+			/*
+			 * Each subpackage has a fixed number of elements and an
+			 * optional element
+			 */
+			expected_count =
+			    package->ret_info.count1 + package->ret_info.count2;
+			if (sub_package->package.count < expected_count) {
+				goto package_too_small;
+			}
+
+			status =
+			    acpi_ns_check_package_elements(data, sub_elements,
+							   package->ret_info.
+							   object_type1,
+							   package->ret_info.
+							   count1,
+							   package->ret_info.
+							   object_type2,
+							   sub_package->package.
+							   count -
+							   package->ret_info.
+							   count1, 0);
+			if (ACPI_FAILURE(status)) {
+				return (status);
+			}
+			break;
+
 		case ACPI_PTYPE2_FIXED:
 
 			/* Each sub-package has a fixed length */
diff --git a/drivers/acpi/acpica/nsrepair.c b/drivers/acpi/acpica/nsrepair.c
index ac7b854..dd0a0bd 100644
--- a/drivers/acpi/acpica/nsrepair.c
+++ b/drivers/acpi/acpica/nsrepair.c
@@ -634,6 +634,7 @@ acpi_ns_remove_null_elements(struct acpi_predefined_data *data,
 	case ACPI_PTYPE2_FIXED:
 	case ACPI_PTYPE2_MIN:
 	case ACPI_PTYPE2_REV_FIXED:
+	case ACPI_PTYPE2_FIX_VAR:
 		break;
 
 	default:
diff --git a/drivers/acpi/acpica/nsrepair2.c b/drivers/acpi/acpica/nsrepair2.c
index 024c4f2..3ee2b22 100644
--- a/drivers/acpi/acpica/nsrepair2.c
+++ b/drivers/acpi/acpica/nsrepair2.c
@@ -467,11 +467,12 @@ acpi_ns_repair_HID(struct acpi_predefined_data *data,
 	}
 
 	/*
-	 * Copy and uppercase the string. From the ACPI specification:
+	 * Copy and uppercase the string. From the ACPI 5.0 specification:
 	 *
 	 * A valid PNP ID must be of the form "AAA####" where A is an uppercase
 	 * letter and # is a hex digit. A valid ACPI ID must be of the form
-	 * "ACPI####" where # is a hex digit.
+	 * "NNNN####" where N is an uppercase letter or decimal digit, and
+	 * # is a hex digit.
 	 */
 	for (dest = new_string->string.pointer; *source; dest++, source++) {
 		*dest = (char)ACPI_TOUPPER(*source);
-- 
1.7.9.rc1

