Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab1ABXC5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 18:02:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54734 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401Ab1ABXC4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 18:02:56 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, 599368@bugs.debian.org,
        608138@bugs.debian.org, Cesare Leonardi <celeonar@gmail.com>
In-Reply-To: <1294005610.3167.99.camel@localhost>
References: <1294005610.3167.99.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 02 Jan 2011 23:02:42 +0000
Message-ID: <1294009362.3167.126.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH v2] watchdog: Improve initialisation error message and
 documentation
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error message 'NMI watchdog failed to create perf event...'  does
not make it clear that this is a fatal error for the watchdog.  It
also currently prints the error value as a pointer, rather than
extracting the error code with PTR_ERR().  Fix that.

Add a note to the description of the 'nowatchdog' kernel parameter to
associate it with this message.

Reported-by: Cesare Leonardi <celeonar@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
Further improved the error message based on Cesare's comments.

Ben.

 Documentation/kernel-parameters.txt |    2 +-
 kernel/watchdog.c                   |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7d0cead..6fc0cf4 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1764,7 +1764,7 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	nousb		[USB] Disable the USB subsystem
 
-	nowatchdog	[KNL] Disable the lockup detector.
+	nowatchdog	[KNL] Disable the lockup detector (NMI watchdog).
 
 	nowb		[ARM]
 
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index d74e866..d7ebdf4 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -366,7 +366,8 @@ static int watchdog_nmi_enable(int cpu)
 		goto out_save;
 	}
 
-	printk(KERN_ERR "NMI watchdog failed to create perf event on cpu%i: %p\n", cpu, event);
+	printk(KERN_ERR "NMI watchdog disabled for cpu%i: unable to create perf event: %ld\n",
+	       cpu, PTR_ERR(event));
 	return PTR_ERR(event);
 
 	/* success path */
-- 
1.7.2.3


