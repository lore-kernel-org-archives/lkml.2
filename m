Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab1HYRrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:47:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45144 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab1HYRrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:47:02 -0400
Date: Thu, 25 Aug 2011 19:46:56 +0200
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Anders Eriksson <aeriksson@fastmail.fm>, Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mtrr: fix UP breakage caused during switch to stop_machine
Message-ID: <20110825174656.GN2803@mtj.dyndns.org>
References: <20110825070335.3095B3BC183@tippex.mynet.homeunix.org>
 <CA+55aFzndqkSC1z3==HqUGC8hP=pw62ro3CWYtovk95_cYAKsA@mail.gmail.com>
 <20110825164649.GL2803@mtj.dyndns.org>
 <1314294182.16133.19.camel@sbsiddha-desk.sc.intel.com>
 <CA+55aFwaxzFJCjJc1=6utMq0WQmrP4COGEOQirqBLcmdTf=+rQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwaxzFJCjJc1=6utMq0WQmrP4COGEOQirqBLcmdTf=+rQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While removing custom rendezvous code and switching to stop_machine,
commit 192d8857427d "x86, mtrr: use stop_machine APIs for doing MTRR
rendezvous" completely dropped mtrr setting code on !CONFIG_SMP
breaking MTRR settting on UP.  Fix it by removing the incorrect
CONFIG_SMP.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Anders Eriksson <aeriksson@fastmail.fm>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/kernel/cpu/mtrr/main.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 08119a3..6b96110 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -149,7 +149,6 @@ struct set_mtrr_data {
  */
 static int mtrr_rendezvous_handler(void *info)
 {
-#ifdef CONFIG_SMP
 	struct set_mtrr_data *data = info;
 
 	/*
@@ -171,7 +170,6 @@ static int mtrr_rendezvous_handler(void *info)
 	} else if (mtrr_aps_delayed_init || !cpu_online(smp_processor_id())) {
 		mtrr_if->set_all();
 	}
-#endif
 	return 0;
 }
 
