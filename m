Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357Ab2JXD6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 23:58:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:13699 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933903Ab2JXD6P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 23:58:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,638,1344236400"; 
   d="scan'208";a="231445608"
From: "Song, Youquan" <youquan.song@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        "Song, Youquan" <youquan.song@intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>
Subject: RE: linux-next: build failure after merge of the final tree (pm
 tree related)
Thread-Topic: linux-next: build failure after merge of the final tree (pm
 tree related)
Thread-Index: AQHNsZnZW8s3cq6ukUupD1wFlhxRfJfH0q4w
Date: Wed, 24 Oct 2012 03:58:00 +0000
Message-ID: <70A3B115BE79814398B8E4E7C4AE18EE13A218@SHSMSX101.ccr.corp.intel.com>
References: <20121024144400.f5779e119f248256aa183ef5@canb.auug.org.au>
In-Reply-To: <20121024144400.f5779e119f248256aa183ef5@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes. We already do the patch to fix the warning yesterday after get the information from Fengguang's "0-DAY kernel build testing".  But do not refresh linux-next so quickly.
Thanks for the information and patch, Stephen!

-Youquan

-----Original Message-----
From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
Sent: Wednesday, October 24, 2012 11:44 AM
To: Rafael J. Wysocki
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Song, Youquan; Rik van Riel
Subject: linux-next: build failure after merge of the final tree (pm tree related)

Hi all,

After merging the final tree, today's linux-next build (powerpc
allnoconfig) failed like this:

In file included from arch/powerpc/kernel/idle.c:27:0:
include/linux/tick.h: In function 'menu_hrtimer_cancel':
include/linux/tick.h:148:48: error: 'return' with a value, in function returning void [-Werror]

Several of these :-(

Caused by commit 25d77b76d7ae ("cpuidle: Quickly notice prediction failure for repeat mode") from the pm tree.  This build has CONFIG_CPU_IDLE_GOV_MENU turned off.  For changes that are obviously affected by CONFIG options, please test build with the CONFIG option on and off.

I have applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 24 Oct 2012 14:40:47 +1100
Subject: [PATCH] cpuidle: fix up but return type for inline function

Fixes this error when CONFIG_CPU_IDLE_GOV_MENU is not enabled:

In file included from arch/powerpc/kernel/idle.c:27:0:
include/linux/tick.h: In function 'menu_hrtimer_cancel':
include/linux/tick.h:148:48: error: 'return' with a value, in function returning void [-Werror]

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/tick.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h index 8867424..40d123e 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -145,7 +145,7 @@ static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }  # ifdef CONFIG_CPU_IDLE_GOV_MENU  extern void menu_hrtimer_cancel(void);  # else -static inline void menu_hrtimer_cancel(void) { return -1; }
+static inline void menu_hrtimer_cancel(void) { }
 # endif /* CONFIG_CPU_IDLE_GOV_MENU */
 
 #endif
--
1.7.10.280.gaa39

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
