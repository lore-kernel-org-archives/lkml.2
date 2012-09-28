Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965076Ab2I1S6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:58:23 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47421 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965042Ab2I1S6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:58:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jim Cromie <jim.cromie@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>
Subject: [ 086/262] dyndbg: fix for SOH in logging messages
Date: Fri, 28 Sep 2012 11:50:15 -0700
Message-Id: <20120928183008.304394317@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Trippelsdorf <markus@trippelsdorf.de>

commit ebdc82899ec5ed35af1c79ed6a4eeda69dad9b90 upstream.

commit af7f2158fde was done against master, and clashed with structured
logging's change of KERN_LEVEL to SOH.

Bisected and fixed by Markus Trippelsdorf.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1895,8 +1895,8 @@ int __dev_printk(const char *level, cons
 				    "DEVICE=+%s:%s", subsys, dev_name(dev));
 	}
 skip:
-	if (level[3])
-		level_extra = &level[3]; /* skip past "<L>" */
+	if (level[2])
+		level_extra = &level[2]; /* skip past KERN_SOH "L" */
 
 	return printk_emit(0, level[1] - '0',
 			   dictlen ? dict : NULL, dictlen,


