Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab0C3XJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:09:05 -0400
Received: from kroah.org ([198.145.64.141]:48477 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755663Ab0C3XJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:09:02 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:52 2010
Message-Id: <20100330224951.271498807@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [18/45] sched: fine-tune SD_SIBLING_INIT
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ingo Molnar <mingo@elte.hu>

commit 52c642f33b14bfa1b00ef2b68296effb34a573f3 upstream.

fine-tune the HT sched-domains parameters as well.

On a HT capable box, this increases lat_ctx performance from 23.87
usecs to 1.49 usecs:

 # before

 $ ./lat_ctx -s 0 2

   "size=0k ovr=1.89
    2 23.87

 # after

 $ ./lat_ctx -s 0 2

   "size=0k ovr=1.84
     2 1.49

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/topology.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -99,7 +99,7 @@ void arch_update_cpu_topology(void);
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
 				| SD_WAKE_AFFINE	\
-				| SD_WAKE_IDLE		\
+				| SD_WAKE_BALANCE	\
 				| SD_SHARE_CPUPOWER,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\


