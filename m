Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab2CITqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:46:38 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43174 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab2CITqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:46:35 -0500
Message-Id: <20120309190204.028553311@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jean Delvare <khali@linux-fr.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [ 21/95] mfd: Fix ACPI conflict check
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 81b5482c32769abb6dfb979560dab2f952ba86fa upstream.

The code is currently always checking the first resource of every
device only (several times.) This has been broken since the ACPI check
was added in February 2010 in commit
91fedede0338eb6203cdd618d8ece873fdb7c22c.

Fix the check to run on each resource individually, once.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/mfd-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -123,7 +123,7 @@ static int mfd_add_device(struct device
 		}
 
 		if (!cell->ignore_resource_conflicts) {
-			ret = acpi_check_resource_conflict(res);
+			ret = acpi_check_resource_conflict(&res[r]);
 			if (ret)
 				goto fail_res;
 		}


