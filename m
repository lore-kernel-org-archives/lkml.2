Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab1FHG4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 02:56:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37847 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1FHG4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 02:56:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=mu/UDhomfIN0uXfXRwCXRBxbZzK3QPz5+uGEqRo51o1AYAVC6v+C/mIipFjBtJN3sl
         ufWYocraXjw1msGrvkVzgIlJf7vMdVg2yZq72AHRlD58nw+d9ZloI4Rg04reH3A9/tE1
         Xn0q1uyM88c+9G6vbizMTJY/a0Tv3Mm5D1Ybo=
Subject: [PATCH] platform-drivers-x86: dell-laptop: Remove unneeded
 mutex_init() for buffer_mutex
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 14:56:42 +0800
Message-ID: <1307516202.8028.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEFINE_MUTEX() will automatically initialize buffer_mutex,
no need to call mutex_init() in dell_init().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/dell-laptop.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index d3841de..dbe336e 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -632,7 +632,6 @@ static int __init dell_init(void)
 	if (!bufferpage)
 		goto fail_buffer;
 	buffer = page_address(bufferpage);
-	mutex_init(&buffer_mutex);
 
 	ret = dell_setup_rfkill();
 
-- 
1.7.4.1



