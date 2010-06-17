Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957Ab0FQMWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 08:22:10 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:45787 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0FQMWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 08:22:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=pedIKIkV4HZ4e1fH8OWHjgRwa//UTRn4dditFVAe2+OPmWI8+gvaY7PhpyNGszHr5z
         uMY7BrG5sLMMF8fv9811dpXRRbddpQAjtT8CLPzZheL3pG+0nBHLhqUbiF3c7hItKF+5
         dTSrf1UpgVr+UhU2EHbJ/698x5XZZHsDk97GE=
Date: Thu, 17 Jun 2010 14:21:56 +0200
From: Dan Carpenter <error27@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [patch] get rid of "cut here" from bug output
Message-ID: <20100617122156.GK5483@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's annoying to have chunks of dmesg output instead just the whole
output.  A lot of times the very interesting information is before
the bug happens.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/kernel/panic.c b/kernel/panic.c
index 3b16cd9..2db532a 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -373,7 +373,7 @@ static void warn_slowpath_common(const char *file, int line, void *caller,
 {
 	const char *board;
 
-	printk(KERN_WARNING "------------[ cut here ]------------\n");
+	printk(KERN_WARNING "-----[ paste whole dmesg to bugzilla ]-----\n");
 	printk(KERN_WARNING "WARNING: at %s:%d %pS()\n", file, line, caller);
 	board = dmi_get_system_info(DMI_PRODUCT_NAME);
 	if (board)
