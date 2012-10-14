Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab2JNPRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:17:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46061 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753813Ab2JNOlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:37 -0400
Message-Id: <20121014143536.070813274@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Khalid Aziz <khalid.aziz@hp.com>, Kees Cook <keescook@chromium.org>,
        Matthew Garrett <mjg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 017/147] firmware: Add missing attributes to EFI variable attribute print out
 from sysfs
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Khalid Aziz <khalid.aziz@hp.com>

commit 7083909023bbe29b3176e92d2d089def1aa7aa1e upstream.

Some of the EFI variable attributes are missing from print out from
/sys/firmware/efi/vars/*/attributes. This patch adds those in. It also
updates code to use pre-defined constants for masking current value
of attributes.

Signed-off-by: Khalid Aziz <khalid.aziz@hp.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/firmware/efivars.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 47408e8..d10c987 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -435,12 +435,23 @@ efivar_attr_read(struct efivar_entry *entry, char *buf)
 	if (status != EFI_SUCCESS)
 		return -EIO;
 
-	if (var->Attributes & 0x1)
+	if (var->Attributes & EFI_VARIABLE_NON_VOLATILE)
 		str += sprintf(str, "EFI_VARIABLE_NON_VOLATILE\n");
-	if (var->Attributes & 0x2)
+	if (var->Attributes & EFI_VARIABLE_BOOTSERVICE_ACCESS)
 		str += sprintf(str, "EFI_VARIABLE_BOOTSERVICE_ACCESS\n");
-	if (var->Attributes & 0x4)
+	if (var->Attributes & EFI_VARIABLE_RUNTIME_ACCESS)
 		str += sprintf(str, "EFI_VARIABLE_RUNTIME_ACCESS\n");
+	if (var->Attributes & EFI_VARIABLE_HARDWARE_ERROR_RECORD)
+		str += sprintf(str, "EFI_VARIABLE_HARDWARE_ERROR_RECORD\n");
+	if (var->Attributes & EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS)
+		str += sprintf(str,
+			"EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS\n");
+	if (var->Attributes &
+			EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS)
+		str += sprintf(str,
+			"EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS\n");
+	if (var->Attributes & EFI_VARIABLE_APPEND_WRITE)
+		str += sprintf(str, "EFI_VARIABLE_APPEND_WRITE\n");
 	return str - buf;
 }
 


