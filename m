Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698Ab1BZPDs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 10:03:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55684 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1BZPDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 10:03:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=SIkH28i/X4CrVrQrzQ3tnaXQOOMOI1tlfvkl5EmnYhsMrv8StcG94EJqWOX4qXgiNV
         0ZlyPkC9fSeNIk9puASnjyrrz0yC+ElPwr9978fyjsSqN9htPcSPPRMo8GFtErD9p8Ay
         lb7tjplIIJ+3cCRL6LZrpnaCFqP/ZFD4lVMeQ=
Subject: [PATCH] platform-driver-x86: intel_mid_thermal: fix unterminated
 platform_device_id table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Durgadoss R <durgadoss.r@intel.com>, Alan Cox <alan@linux.intel.com>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Feb 2011 23:03:34 +0800
Message-ID: <1298732614.2762.6.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/intel_mid_thermal.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/intel_mid_thermal.c b/drivers/platform/x86/intel_mid_thermal.c
index 1215c30..6c12db5 100644
--- a/drivers/platform/x86/intel_mid_thermal.c
+++ b/drivers/platform/x86/intel_mid_thermal.c
@@ -543,6 +543,7 @@ static int mid_thermal_remove(struct platform_device *pdev)
 
 static const struct platform_device_id therm_id_table[] = {
        { DRIVER_NAME, 1 },
+       { }
 };
 
 static struct platform_driver mid_thermal_driver = {
-- 
1.7.1



