Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab0CSLtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 07:49:32 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61806 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab0CSLt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 07:49:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=U2+ac9ih3YWZ3i322U3nb0ouJsCL4eSLubHJ2j11MWx+jysARwjToBpN0AFLPw0d2N
         52Ku3fMqlg5LIwE/InVKRA1ijrAwd58nowegyllx2kchjZANn6qIAbyFq5L5dupwbvbC
         teJOkyINhX0l7R2RCVFq/O5Yv3PCZ/9xq99iE=
Date: Fri, 19 Mar 2010 14:49:20 +0300
From: Dan Carpenter <error27@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Lin Ming <ming.m.lin@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] power_meter: acpi_device_class "power_meter_resource" too
	long
Message-ID: <20100319114920.GP5331@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Len Brown <lenb@kernel.org>, "Darrick J. Wong" <djwong@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?iso-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
	Lin Ming <ming.m.lin@intel.com>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_device_class can only be 19 characters and a NULL terminator.

The current code has a buffer overflow in acpi_power_meter_add():
       strcpy(acpi_device_class(device), ACPI_POWER_METER_CLASS);

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Feel free to change the name to anything you like.

diff --git a/drivers/acpi/power_meter.c b/drivers/acpi/power_meter.c
index 834c5af..31baa1e 100644
--- a/drivers/acpi/power_meter.c
+++ b/drivers/acpi/power_meter.c
@@ -34,7 +34,7 @@
 #define ACPI_POWER_METER_NAME		"power_meter"
 ACPI_MODULE_NAME(ACPI_POWER_METER_NAME);
 #define ACPI_POWER_METER_DEVICE_NAME	"Power Meter"
-#define ACPI_POWER_METER_CLASS		"power_meter_resource"
+#define ACPI_POWER_METER_CLASS		"pwr_meter_resource"
 
 #define NUM_SENSORS			17
 
