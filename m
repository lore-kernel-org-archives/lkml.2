Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab1IZLjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 07:39:52 -0400
Received: from caiajhbdcagg.dreamhost.com ([208.97.132.66]:36794 "EHLO
	homiemail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751961Ab1IZLjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 07:39:51 -0400
Subject: [PATCH] ACPI: check mutex release status
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Len Brown <lenb@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Mon, 26 Sep 2011 08:39:44 -0300
Message-ID: <1317037184.2697.1.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

If this is not done we have a bogus ACPI_FAILURE() call.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/acpi/acpica/nsload.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/acpica/nsload.c b/drivers/acpi/acpica/nsload.c
index 5f7dc69..f3070fd 100644
--- a/drivers/acpi/acpica/nsload.c
+++ b/drivers/acpi/acpica/nsload.c
@@ -115,7 +115,7 @@ acpi_ns_load_table(u32 table_index, struct acpi_namespace_node *node)
 	}
 
       unlock:
-	(void)acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
+	status = acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
 
 	if (ACPI_FAILURE(status)) {
 		return_ACPI_STATUS(status);
-- 
1.7.4.1



