Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab1CNK4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:56:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33408 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1CNK4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:56:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=K4wc8CiFhsLlJI5gudNW58NNzqBoj39vQ2czjRAlifjRP9lHvyPKzjWbKAyoL65jTm
         8V+TZUBVjbJankUBhbDxEo/3XekJ8HZdTDCouGS1XzgcYyWNGhnZp/H/P655ZoWT2Q18
         QrRSIFjwl1kceSWnBWrWop1CMCpAHLYjAWWlg=
Subject: [PATCH] platform-driver-x86: samsung-laptop: make dmi_check_cb to
 return 1 instead of 0
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Mar 2011 18:56:18 +0800
Message-ID: <1300100178.3761.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmi_check_system() walks the table running matching functions until
someone returns non zero or we hit the end.

This patch makes dmi_check_cb to return 1 so dmi_check_system() return
immediately when a match is found.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/samsung-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index e0b390d..de434c6 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -496,7 +496,7 @@ static int __init dmi_check_cb(const struct dmi_system_id *id)
 {
 	pr_info("found laptop model '%s'\n",
 		id->ident);
-	return 0;
+	return 1;
 }
 
 static struct dmi_system_id __initdata samsung_dmi_table[] = {
-- 
1.7.1



