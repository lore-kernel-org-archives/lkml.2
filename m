Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab0JLCSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 22:18:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49933 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756504Ab0JLCSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 22:18:30 -0400
Date: Tue, 12 Oct 2010 13:18:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Robert Richter <robert.richter@amd.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Matt Fleming <matt@console-pimps.org>
Subject: linux-next: manual merge of the oprofile tree with the tip tree
Message-Id: <20101012131828.5fedf1bf.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

Today's linux-next merge of the oprofile tree got a conflict in
arch/arm/oprofile/common.c between commit
38a81da2205f94e8a2a834b51a6b99c91fc7c2e8 ("perf events: Clean up pid
passing") from the tip tree and commit
3d90a00763b51e1db344a7430c966be723b67a29 ("oprofile: Abstract the
perf-events backend") from the oprofile tree.

The latter moved the code modified by the former, so I used the version
of this file from the oprofile tree.  I also applied the effect of the
tip tree patch to the new file drivers/oprofile/oprofile_perf.c:

diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
index b17235a..afbc43b 100644
--- a/drivers/oprofile/oprofile_perf.c
+++ b/drivers/oprofile/oprofile_perf.c
@@ -77,7 +77,7 @@ static int op_create_counter(int cpu, int event)
 		return 0;
 
 	pevent = perf_event_create_kernel_counter(&counter_config[event].attr,
-						  cpu, -1,
+						  cpu, NULL1,
 						  op_overflow_handler);
 
 	if (IS_ERR(pevent))
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
