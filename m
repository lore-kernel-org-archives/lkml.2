Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab1ESL7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 07:59:47 -0400
Received: from gate.krista.ru ([84.47.172.34]:10344 "EHLO gate.krista.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab1ESL7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 07:59:45 -0400
Date: Thu, 19 May 2011 15:57:02 +0400
From: samsonov@krista.ru
To: linux-kernel@vger.kernel.org
Subject: fs/attr.c patch
Message-ID: <20110519155702.38a0481d@wks1198.krista.ru>
Organization: =?KOI8-R?B?7vDvIOvSydPUwQ==?=
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Score: -3.8 [-37] (---) (gate.krista.ru)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- ./linux-2.6.33.4.orig/fs/attr.c	2010-05-13 02:04:27.000000000 +0400
+++ ./linux-2.6.33.4/fs/attr.c	2011-05-19 15:43:14.533672804 +0400
@@ -35,9 +35,7 @@
 
 	/* Make sure caller can chgrp. */
 	if ((ia_valid & ATTR_GID) &&
-	    (current_fsuid() != inode->i_uid ||
-	    (!in_group_p(attr->ia_gid) && attr->ia_gid != inode->i_gid)) &&
-	    !capable(CAP_CHOWN))
+	    !(in_group_p(attr->ia_gid) && is_owner_or_cap(inode)))
 		goto error;
 
 	/* Make sure a caller can chmod. */

I think that fileowner can change group of file.


 

