Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab1CJCoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 21:44:13 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59781 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab1CJCoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 21:44:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UBmhDPLOSSCkZI4ooeVh7dT46CRz/pLC63qX37c/mcxAvsgOLZQTOecsRsBjQXOnhs
         J/fChnV4+UKf9UhS9wSPhgYI6p9+gWzbPS51OiptlJDagpZRlAF4C9dKQmyh03x/WO3S
         /JbOj+Kn5AdEQOG4Nnx/TWyhDf7unGDxLBBZU=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH next 6/6] staging: ste_rmi4: fix memory leaks
Date: Thu, 10 Mar 2011 05:43:08 +0300
Message-Id: <1299724988-25351-6-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299724988-25351-1-git-send-email-a.beregalov@gmail.com>
References: <1299724988-25351-1-git-send-email-a.beregalov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free resources before exit.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
index 51b4a79..d55a8e4 100644
--- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
+++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
@@ -764,8 +764,10 @@ static int synaptics_rmi4_i2c_query_device(struct synaptics_rmi4_data *pdata)
 								(pdata,	rfi,
 								&rmi_fd,
 								intr_count);
-					if (retval < 0)
+					if (retval < 0) {
+						kfree(rfi);
 						return retval;
+					}
 				}
 				break;
 			}
-- 
1.7.4.1

