Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab1GGCGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 22:06:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47349 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab1GGCF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 22:05:59 -0400
Subject: [PATCH] platform-drivers-x86: intel_menlow: add missing return
 AE_OK for intel_menlow_register_sensor()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sujith Thomas <sujith.thomas@intel.com>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jul 2011 10:05:49 +0800
Message-ID: <1310004349.2481.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, the error path will always be executed.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/intel_menlow.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/intel_menlow.c b/drivers/platform/x86/intel_menlow.c
index 809adea..abddc83 100644
--- a/drivers/platform/x86/intel_menlow.c
+++ b/drivers/platform/x86/intel_menlow.c
@@ -477,6 +477,8 @@ static acpi_status intel_menlow_register_sensor(acpi_handle handle, u32 lvl,
 		return AE_ERROR;
 	}
 
+	return AE_OK;
+
  aux1_not_found:
 	if (status == AE_NOT_FOUND)
 		return AE_OK;
-- 
1.7.4.1



