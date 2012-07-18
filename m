Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab2GRALt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:11:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37684 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab2GRADr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:03:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vlastimil Babka <caster@gentoo.org>,
        Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [ 09/37] ACPICA: Fix possible fault in return package object repair code
Date: Tue, 17 Jul 2012 17:02:46 -0700
Message-Id: <20120717232432.089781420@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232431.399005532@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Moore <robert.moore@intel.com>

commit 46befd6b38d802dfc5998e7d7938854578b45d9d upstream.

Fixes a problem that can occur when a lone package object is
wrapped with an outer package object in order to conform to
the ACPI specification. Can affect these predefined names:
_ALR,_MLS,_PSS,_TRT,_TSS,_PRT,_HPX,_DLM,_CSD,_PSD,_TSD

https://bugzilla.kernel.org/show_bug.cgi?id=44171

This problem was introduced in 3.4-rc1 by commit
6a99b1c94d053b3420eaa4a4bc8b2883dd90a2f9
(ACPICA: Object repair code: Support to add Package wrappers)

Reported-by: Vlastimil Babka <caster@gentoo.org>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpica/nspredef.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/acpica/nspredef.c
+++ b/drivers/acpi/acpica/nspredef.c
@@ -638,7 +638,7 @@ acpi_ns_check_package(struct acpi_predef
 			/* Create the new outer package and populate it */
 
 			status =
-			    acpi_ns_wrap_with_package(data, *elements,
+			    acpi_ns_wrap_with_package(data, return_object,
 						      return_object_ptr);
 			if (ACPI_FAILURE(status)) {
 				return (status);


