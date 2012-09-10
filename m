Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab2IJSwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:52:46 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:28001 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab2IJSwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:52:44 -0400
Date: Mon, 10 Sep 2012 12:52:42 -0600
From: Khalid Aziz <khalid.aziz@hp.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Mike Waychison <mikew@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        khalid@gonehiking.org
Subject: [PATCH v2 RESEND] Add missing attributes to EFI variable attribute
 print out from sysfs
Message-ID: <20120910185242.GA12627@ldl.usa.hp.com>
References: <20120713174216.GA10445@hp.com>
 <CAGTjWtDyGrVuBXZzdDfbS961cRSQY7eZaEbb9E8HACk5-imiuQ@mail.gmail.com>
 <CAGTjWtAPKXfA7pOqWEfK2i_HbrtA6_w7+ezZyCo4NG1gBSEhwg@mail.gmail.com>
 <20120910180335.GA26021@kroah.com>
 <1347300789.4393.27.camel@lyra>
 <20120910181855.GA26404@kroah.com>
 <20120910182914.GA12076@ldl.usa.hp.com>
 <20120910183506.GA25975@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910183506.GA25975@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the EFI variable attributes are missing from print out from
/sys/firmware/efi/vars/*/attributes. This patch adds those in. It also
updates code to use pre-defined constants for masking current value
of attributes.

Signed-off-by: Khalid Aziz <khalid.aziz@hp.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Matthew Garrett <mjg@redhat.com>
Cc: stable@vger.kernel.org
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
 
--
1.7.9.5

