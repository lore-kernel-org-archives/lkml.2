Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760413Ab0HEUYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:24:23 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:57891 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934211Ab0HEUYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:24:15 -0400
Date: Thu, 5 Aug 2010 22:24:12 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Corentin Chary <corentincj@iksaif.net>,
        Karol Kozimor <sziwan@users.sourceforge.net>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 24/42] drivers/platform/x86: Adjust confusing if indentation
Message-ID: <Pine.LNX.4.64.1008052223550.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The assignment of ret to -EIO appears to only make sense if the branch that
it is aligned with is executed, so move it into that branch.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable braces4@
position p1,p2;
statement S1,S2;
@@

(
if (...) { ... }
|
if (...) S1@p1 S2@p2
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

if (p1[0].column == p2[0].column):
  cocci.print_main("branch",p1)
  cocci.print_secs("after",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This patch changes the semantics and might not be what is intended.

 drivers/platform/x86/asus_acpi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/asus_acpi.c b/drivers/platform/x86/asus_acpi.c
index e058c2b..ca05aef 100644
--- a/drivers/platform/x86/asus_acpi.c
+++ b/drivers/platform/x86/asus_acpi.c
@@ -938,10 +938,11 @@ static int set_brightness(int value)
 	/* SPLV laptop */
 	if (hotk->methods->brightness_set) {
 		if (!write_acpi_int(hotk->handle, hotk->methods->brightness_set,
-				    value, NULL))
+				    value, NULL)) {
 			printk(KERN_WARNING
 			       "Asus ACPI: Error changing brightness\n");
 			ret = -EIO;
+		}
 		goto out;
 	}
 
@@ -953,10 +954,11 @@ static int set_brightness(int value)
 					      hotk->methods->brightness_down,
 					      NULL, NULL);
 		(value > 0) ? value-- : value++;
-		if (ACPI_FAILURE(status))
+		if (ACPI_FAILURE(status)) {
 			printk(KERN_WARNING
 			       "Asus ACPI: Error changing brightness\n");
 			ret = -EIO;
+		}
 	}
 out:
 	return ret;
