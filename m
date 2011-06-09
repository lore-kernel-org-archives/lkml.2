Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab1FIDEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 23:04:35 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54906 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab1FIDEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 23:04:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=ZPS4cKVxStHuIaC3jvvnLRrXRjp1ZoOvDTm/QaBb8uK0mBMb17j+c4kdWkv9owtDj0
         Nxxla2vag90QXNetW+3OW7PxhZTf29R0BTDMbMhVPR1M1nVBhSINYOefmk0/iJHsg8dz
         scPGX7DgcQI2uCh472/bmE88OX+0/ft0mXTSc=
Date: Thu, 9 Jun 2011 11:04:13 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: ravi@jetztechnologies.com, arvino55@gmail.com, greg@kroah.com,
        akpm@linux-foundation.org, randy.dunlap@oracle.com, joe@perches.com
Subject: [PATCH RESEND]Remove a warning for drivers/edac/i82975x_edac.c
Message-ID: <20110609030401.GA2615@gmail.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, ravi@jetztechnologies.com,
	arvino55@gmail.com, greg@kroah.com, akpm@linux-foundation.org,
	randy.dunlap@oracle.com, joe@perches.com
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
