Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab1FDCWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 22:22:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65440 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab1FDCWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 22:22:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=K8kBaw1WpHlhfblq6dCsohNgRxirflxh9A2A8BfOYoCxjfCE44VoVK8ncscV3K1pet
         ww7m0MdZyYuEFXUw4r2cioax7ZIsV2FrsHOaaN+jDJg3Vs1CMmjqgMupfhgJKxzkCg/C
         BNwTBeKVhRNFStwxOCzs0HUe+LIH2NgPYuBi8=
Date: Sat, 4 Jun 2011 10:22:21 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: ravi@jetztechnologies.com, arvino55@gmail.com,
        bluesmoke-devel@lists.sourceforge.net, greg@kroah.com,
        akpm@linux-foundation.org
Subject: [PATCH]Remove a warning for drivers/edac/i82975x_edac.c
Message-ID: <20110604022151.GA2475@gmail.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, ravi@jetztechnologies.com,
	arvino55@gmail.com, bluesmoke-devel@lists.sourceforge.net,
	greg@kroah.com, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harry Wei <harryxiyou@gmail.com>

When i compile 2.6.39.1, a warning shows like below.
This patch can fix the warning. And i works well with
my PC.

[...]
CC [M]  drivers/edac/e752x_edac.o
CC [M]  drivers/edac/i82875p_edac.o
CC [M]  drivers/edac/i82975x_edac.o
drivers/edac/i82975x_edac.c: In function ���i82975x_process_error_info���:
drivers/edac/i82975x_edac.c:298: warning: integer constant is too large for ���unsigned long��� type
CC [M]  drivers/edac/i3000_edac.o
CC [M]  drivers/edac/i3200_edac.o
CC [M]  drivers/edac/x38_edac.o
CC [M]  drivers/edac/i82860_edac.o
[...]

Signed-off-by: Harry Wei <harryxiyou@gmail.com>

Index: prj/drivers/edac/i82975x_edac.c
===================================================================
--- prj.orig/drivers/edac/i82975x_edac.c	2011-06-04 10:09:55.351174516 +0800
+++ prj/drivers/edac/i82975x_edac.c	2011-06-04 10:10:30.875168437 +0800
@@ -293,9 +293,9 @@
 		info->errsts = info->errsts2;
 	}
 
-	page = (unsigned long) info->eap;
+	page = (unsigned long long) info->eap;
 	if (info->xeap & 1)
-		page |= 0x100000000ul;
+		page |= 0x100000000ull;
 	chan = page & 1;
 	page >>= 1;
 	offst = page & ((1 << PAGE_SHIFT) - 1);
