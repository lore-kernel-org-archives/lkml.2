Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030191Ab1LPTx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:53:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964833Ab1LPTwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:52:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:42:11 2011
Message-Id: <20111216194211.342204710@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:40:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes.berg@intel.com>,
        Balbir Singh <bsingharora@gmail.com>,
        =?UTF-8?q?Moritz=20M=C3=BChlenhoff?= <jmm@inutil.org>
Subject: [28/45] Make TASKSTATS require root access
In-Reply-To: <20111216194603.GA15028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

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
 1 file changed, 1 insertion(+)

--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -657,6 +657,7 @@ static struct genl_ops taskstats_ops = {
 	.cmd		= TASKSTATS_CMD_GET,
 	.doit		= taskstats_user_cmd,
 	.policy		= taskstats_cmd_get_policy,
+	.flags		= GENL_ADMIN_PERM,
 };
 
 static struct genl_ops cgroupstats_ops = {


