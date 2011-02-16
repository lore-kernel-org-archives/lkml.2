Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab1BPAjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:39:13 -0500
Received: from kroah.org ([198.145.64.141]:49506 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173Ab1BPAXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:49 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:45 2011
Message-Id: <20110216001445.343326634@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [202/272] watchdog: Dont change watchdog state on read of sysctl
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcin Slusarz <marcin.slusarz@gmail.com>

commit 9ffdc6c37df131f89d52001e0ef03091b158826f upstream.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
[ add {}'s to fix a warning ]
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1296230433-6261-3-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/watchdog.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -497,10 +497,12 @@ int proc_dowatchdog_enabled(struct ctl_t
 {
 	proc_dointvec(table, write, buffer, length, ppos);
 
-	if (watchdog_enabled)
-		watchdog_enable_all_cpus();
-	else
-		watchdog_disable_all_cpus();
+	if (write) {
+		if (watchdog_enabled)
+			watchdog_enable_all_cpus();
+		else
+			watchdog_disable_all_cpus();
+	}
 	return 0;
 }
 


