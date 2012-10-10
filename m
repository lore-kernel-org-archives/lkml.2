Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab2JJWxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:53:04 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:32943 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757335Ab2JJWwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:52:54 -0400
X-Sasl-enc: f5XFfmxxzN80wup2zGWVwtDIA+SHVwzo4Vf3r6xVifsK 1349909573
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jim Cromie <jim.cromie@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>
Subject: [ 001/133] Revert dyndbg: fix for SOH in logging messages
Date: Thu, 11 Oct 2012 07:50:27 +0900
Message-Id: <20121010224854.686758690@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 3d822616ca81881d8c19d0b473e79ba241c700de, which is
ebdc82899ec5ed35af1c79ed6a4eeda69dad9b90 upstream, as it's not needed in
the 3.5.y tree.

Reported-by: Wouter M. Koolen <W.M.Koolen-Wijkstra@cwi.nl>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Jim Cromie <jim.cromie@gmail.com>
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
-	if (level[2])
-		level_extra = &level[2]; /* skip past KERN_SOH "L" */
+	if (level[3])
+		level_extra = &level[3]; /* skip past "<L>" */
 
 	return printk_emit(0, level[1] - '0',
 			   dictlen ? dict : NULL, dictlen,


