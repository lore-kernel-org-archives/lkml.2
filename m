Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2BEWjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:39:35 -0500
Received: from 1wt.eu ([62.212.114.60]:62048 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab2BEW0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:48 -0500
Message-Id: <20120205220952.019376250@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:49 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?ISO-8859-15?q?Moritz=20M=FChlenhoff?= <jmm@inutil.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 60/91] Make TASKSTATS require root access
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 1a51410abe7d0ee4b1d112780f46df87d3621043 upstream.

Ok, this isn't optimal, since it means that 'iotop' needs admin
capabilities, and we may have to work on this some more.  But at the
same time it is very much not acceptable to let anybody just read
anybody elses IO statistics quite at this level.

Use of the GENL_ADMIN_PERM suggested by Johannes Berg as an alternative
to checking the capabilities by hand.

Reported-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Acked-by: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Moritz Mühlenhoff <jmm@inutil.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/taskstats.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/kernel/taskstats.c
===================================================================
--- longterm-2.6.27.orig/kernel/taskstats.c	2012-02-05 22:34:33.153915196 +0100
+++ longterm-2.6.27/kernel/taskstats.c	2012-02-05 22:34:43.419915481 +0100
@@ -574,6 +574,7 @@
 	.cmd		= TASKSTATS_CMD_GET,
 	.doit		= taskstats_user_cmd,
 	.policy		= taskstats_cmd_get_policy,
+	.flags		= GENL_ADMIN_PERM,
 };
 
 static struct genl_ops cgroupstats_ops = {


