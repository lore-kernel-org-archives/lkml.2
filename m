Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab1AFAiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:38:23 -0500
Received: from kroah.org ([198.145.64.141]:36029 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679Ab1AFAb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:26 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:08 2011
Message-Id: <20110106002308.434740955@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>, 599368@bugs.debian.org,
        608138@bugs.debian.org, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [124/152] watchdog: Improve initialisation error message and documentation
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 551423748a4eba55f2eb0fc250d757986471f187 upstream.

The error message 'NMI watchdog failed to create perf event...'
does not make it clear that this is a fatal error for the
watchdog.  It also currently prints the error value as a
pointer, rather than extracting the error code with PTR_ERR().
Fix that.

Add a note to the description of the 'nowatchdog' kernel
parameter to associate it with this message.

Reported-by: Cesare Leonardi <celeonar@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: 599368@bugs.debian.org
Cc: 608138@bugs.debian.org
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1294009362.3167.126.camel@localhost>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/kernel-parameters.txt |    2 +-
 kernel/watchdog.c                   |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1745,7 +1745,7 @@ and is between 256 and 4096 characters.
 
 	nousb		[USB] Disable the USB subsystem
 
-	nowatchdog	[KNL] Disable the lockup detector.
+	nowatchdog	[KNL] Disable the lockup detector (NMI watchdog).
 
 	nowb		[ARM]
 
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -377,7 +377,8 @@ static int watchdog_nmi_enable(int cpu)
 		goto out_save;
 	}
 
-	printk(KERN_ERR "NMI watchdog failed to create perf event on cpu%i: %p\n", cpu, event);
+	printk(KERN_ERR "NMI watchdog disabled for cpu%i: unable to create perf event: %ld\n",
+	       cpu, PTR_ERR(event));
 	return -1;
 
 	/* success path */


