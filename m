Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079Ab2GYDrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:47:33 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62253 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932963Ab2GYDnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:43:16 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 40/52] ACPICA: Fix some comment fields
Date: Tue, 24 Jul 2012 23:41:36 -0400
Message-Id: <cf48958e84abb3b2dbb4202d0edbfce6aff65ce7.1343187617.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.rc0
In-Reply-To: <1343187708-19532-1-git-send-email-lenb@kernel.org>
References: <1343187708-19532-1-git-send-email-lenb@kernel.org>
In-Reply-To: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
References: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

No functional change. Fixes some typos and linux divergences.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/acmacros.h | 4 ++--
 drivers/acpi/acpica/acobject.h | 4 ++--
 drivers/acpi/acpica/exprep.c   | 4 ++--
 drivers/acpi/acpica/exresolv.c | 2 +-
 drivers/acpi/acpica/exstore.c  | 4 ++--
 drivers/acpi/acpica/exutils.c  | 2 +-
 drivers/acpi/acpica/rscreate.c | 6 +++---
 drivers/acpi/acpica/utglobal.c | 5 +++--
 drivers/acpi/acpica/utobject.c | 6 +++---
 9 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/acpi/acpica/acmacros.h b/drivers/acpi/acpica/acmacros.h
index f119f47..087b466 100644
--- a/drivers/acpi/acpica/acmacros.h
+++ b/drivers/acpi/acpica/acmacros.h
@@ -283,8 +283,8 @@
 #define ACPI_INSERT_BITS(target, mask, source)          target = ((target & (~(mask))) | (source & mask))
 
 /*
- * A struct acpi_namespace_node can appear in some contexts
- * where a pointer to a union acpi_operand_object can also
+ * An object of type struct acpi_namespace_node can appear in some contexts
+ * where a pointer to an object of type union acpi_operand_object can also
  * appear. This macro is used to distinguish them.
  *
  * The "Descriptor" field is the first field in both structures.
diff --git a/drivers/acpi/acpica/acobject.h b/drivers/acpi/acpica/acobject.h
index 39a2b84..b85802d 100644
--- a/drivers/acpi/acpica/acobject.h
+++ b/drivers/acpi/acpica/acobject.h
@@ -113,8 +113,8 @@ struct acpi_object_integer {
 };
 
 /*
- * Note: The String and Buffer object must be identical through the Pointer
- * and length elements.  There is code that depends on this.
+ * Note: The String and Buffer object must be identical through the
+ * pointer and length elements. There is code that depends on this.
  *
  * Fields common to both Strings and Buffers
  */
diff --git a/drivers/acpi/acpica/exprep.c b/drivers/acpi/acpica/exprep.c
index 30157f5..ae62038 100644
--- a/drivers/acpi/acpica/exprep.c
+++ b/drivers/acpi/acpica/exprep.c
@@ -395,8 +395,8 @@ acpi_ex_prep_common_field_object(union acpi_operand_object *obj_desc,
  *
  * RETURN:      Status
  *
- * DESCRIPTION: Construct a union acpi_operand_object of type def_field and
- *              connect it to the parent Node.
+ * DESCRIPTION: Construct an object of type union acpi_operand_object with a
+ *              subtype of def_field and connect it to the parent Node.
  *
  ******************************************************************************/
 
diff --git a/drivers/acpi/acpica/exresolv.c b/drivers/acpi/acpica/exresolv.c
index 6e335dc..c6f0ad4 100644
--- a/drivers/acpi/acpica/exresolv.c
+++ b/drivers/acpi/acpica/exresolv.c
@@ -147,7 +147,7 @@ acpi_ex_resolve_object_to_value(union acpi_operand_object **stack_ptr,
 
 	stack_desc = *stack_ptr;
 
-	/* This is a union acpi_operand_object    */
+	/* This is an object of type union acpi_operand_object */
 
 	switch (stack_desc->common.type) {
 	case ACPI_TYPE_LOCAL_REFERENCE:
diff --git a/drivers/acpi/acpica/exstore.c b/drivers/acpi/acpica/exstore.c
index c6cf843..38c5048 100644
--- a/drivers/acpi/acpica/exstore.c
+++ b/drivers/acpi/acpica/exstore.c
@@ -62,8 +62,8 @@ acpi_ex_store_object_to_index(union acpi_operand_object *val_desc,
  * FUNCTION:    acpi_ex_store
  *
  * PARAMETERS:  *source_desc        - Value to be stored
- *              *dest_desc          - Where to store it.  Must be an NS node
- *                                    or a union acpi_operand_object of type
+ *              *dest_desc          - Where to store it. Must be an NS node
+ *                                    or union acpi_operand_object of type
  *                                    Reference;
  *              walk_state          - Current walk state
  *
diff --git a/drivers/acpi/acpica/exutils.c b/drivers/acpi/acpica/exutils.c
index eb6798b..7482400 100644
--- a/drivers/acpi/acpica/exutils.c
+++ b/drivers/acpi/acpica/exutils.c
@@ -109,7 +109,7 @@ void acpi_ex_enter_interpreter(void)
  *
  * DESCRIPTION: Reacquire the interpreter execution region from within the
  *              interpreter code. Failure to enter the interpreter region is a
- *              fatal system error. Used in  conjunction with
+ *              fatal system error. Used in conjunction with
  *              relinquish_interpreter
  *
  ******************************************************************************/
diff --git a/drivers/acpi/acpica/rscreate.c b/drivers/acpi/acpica/rscreate.c
index 46d6eb3..311cbc4 100644
--- a/drivers/acpi/acpica/rscreate.c
+++ b/drivers/acpi/acpica/rscreate.c
@@ -190,8 +190,8 @@ acpi_rs_create_resource_list(union acpi_operand_object *aml_buffer,
  *
  * FUNCTION:    acpi_rs_create_pci_routing_table
  *
- * PARAMETERS:  package_object          - Pointer to a union acpi_operand_object
- *                                        package
+ * PARAMETERS:  package_object          - Pointer to a package containing one
+ *                                        of more ACPI_OPERAND_OBJECTs
  *              output_buffer           - Pointer to the user's buffer
  *
  * RETURN:      Status  AE_OK if okay, else a valid acpi_status code.
@@ -199,7 +199,7 @@ acpi_rs_create_resource_list(union acpi_operand_object *aml_buffer,
  *              AE_BUFFER_OVERFLOW and output_buffer->Length will point
  *              to the size buffer needed.
  *
- * DESCRIPTION: Takes the union acpi_operand_object    package and creates a
+ * DESCRIPTION: Takes the union acpi_operand_object package and creates a
  *              linked list of PCI interrupt descriptions
  *
  * NOTE: It is the caller's responsibility to ensure that the start of the
diff --git a/drivers/acpi/acpica/utglobal.c b/drivers/acpi/acpica/utglobal.c
index 78cf1fe..9bd5b4c 100644
--- a/drivers/acpi/acpica/utglobal.c
+++ b/drivers/acpi/acpica/utglobal.c
@@ -247,8 +247,9 @@ struct acpi_fixed_event_info acpi_gbl_fixed_event_info[ACPI_NUM_FIXED_EVENTS] =
  *
  * RETURN:      Status
  *
- * DESCRIPTION: Init library globals.  All globals that require specific
- *              initialization should be initialized here!
+ * DESCRIPTION: Initialize ACPICA globals. All globals that require specific
+ *              initialization should be initialized here. This allows for
+ *              a warm restart.
  *
  ******************************************************************************/
 
diff --git a/drivers/acpi/acpica/utobject.c b/drivers/acpi/acpica/utobject.c
index b112744..d0441ca 100644
--- a/drivers/acpi/acpica/utobject.c
+++ b/drivers/acpi/acpica/utobject.c
@@ -327,7 +327,7 @@ union acpi_operand_object *acpi_ut_create_string_object(acpi_size string_size)
  *
  * RETURN:      TRUE if object is valid, FALSE otherwise
  *
- * DESCRIPTION: Validate a pointer to be a union acpi_operand_object
+ * DESCRIPTION: Validate a pointer to be of type union acpi_operand_object
  *
  ******************************************************************************/
 
@@ -348,7 +348,7 @@ u8 acpi_ut_valid_internal_object(void *object)
 	switch (ACPI_GET_DESCRIPTOR_TYPE(object)) {
 	case ACPI_DESC_TYPE_OPERAND:
 
-		/* The object appears to be a valid union acpi_operand_object    */
+		/* The object appears to be a valid union acpi_operand_object */
 
 		return (TRUE);
 
@@ -419,7 +419,7 @@ void acpi_ut_delete_object_desc(union acpi_operand_object *object)
 {
 	ACPI_FUNCTION_TRACE_PTR(ut_delete_object_desc, object);
 
-	/* Object must be a union acpi_operand_object    */
+	/* Object must be a union acpi_operand_object */
 
 	if (ACPI_GET_DESCRIPTOR_TYPE(object) != ACPI_DESC_TYPE_OPERAND) {
 		ACPI_ERROR((AE_INFO,
-- 
1.7.12.rc0

