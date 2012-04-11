Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760768Ab2DKRTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 13:19:45 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:42206
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756032Ab2DKRTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 13:19:43 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2fh668h839hd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F85BD04.3070407@am.sony.com>
Date: Wed, 11 Apr 2012 10:19:00 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <andrea@suse.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] stack usage: Add pid to warning printk in check_stack_usage
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In embedded systems, sometimes the same program (busybox)
is the cause of multiple warnings.  Outputting the pid
with the program name in the warning printk helps
distinguish which instances of a program are using
the stack most.

This is a small patch, but useful.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 exit.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index b8a6a09..bad923d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -898,9 +898,9 @@ static void check_stack_usage(void)

 	spin_lock(&low_water_lock);
 	if (free < lowest_to_date) {
-		printk(KERN_WARNING "%s used greatest stack depth: %lu bytes "
-				"left\n",
-				current->comm, free);
+		printk(KERN_WARNING "%s (%d) used greatest stack depth: "
+				"%lu bytes left\n",
+				current->comm, task_pid_nr(current), free);
 		lowest_to_date = free;
 	}
 	spin_unlock(&low_water_lock);

