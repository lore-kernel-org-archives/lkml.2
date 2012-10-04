Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab2JDWOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:14:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40785 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401Ab2JDVSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:18:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Khalid Aziz <khalid.aziz@hp.com>, Kees Cook <keescook@chromium.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: [ 26/56] firmware: Add missing attributes to EFI variable attribute print out from sysfs
Date: Thu,  4 Oct 2012 14:15:47 -0700
Message-Id: <20121004211155.074576446@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004211152.101901246@linuxfoundation.org>
References: <20121004211152.101901246@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/firmware/efivars.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -435,12 +435,23 @@ efivar_attr_read(struct efivar_entry *en
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
 


