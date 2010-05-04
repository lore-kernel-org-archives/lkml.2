Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab0EDEoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 00:44:55 -0400
Received: from recombinator.qemfd.net ([216.27.165.184]:60541 "EHLO
	recombinator.qemfd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0EDEoy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 00:44:54 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 May 2010 00:44:54 EDT
Date: Tue, 4 May 2010 00:09:20 -0400
From: nick black <dank@qemfd.net>
To: Robert Richter <robert.richter@amd.com>, oprofile-list@lists.sf.net
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nate Clark <ntclark@cc.gatech.edu>, trivial@kernel.org
Subject: [PATCH] support Model-30 Corei7 in Oprofile
Message-ID: <20100504040920.GA15516@qemfd.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howdy! OProfile doesn't recognize my QM720 Core i7. It knows about Model 26,
but not Model 30. This one-liner, taken against 2.6.34-rc6, addresses that.

Signed-off-by: Nick Black <nickblack@acm.org>
---
I sent a very similar patch to DynamoRIO this weekend. Not many Model-30's
in use yet?

diff -uprN linux-2.6.34-rc6/arch/x86/oprofile/nmi_int.c /home/dank/local/linux-2.6.34-rc6//arch/x86/oprofile/nmi_int.c
--- linux-2.6.34-rc6/arch/x86/oprofile/nmi_int.c	2010-04-29 23:02:05.000000000 -0400
+++ /home/dank/local/linux-2.6.34-rc6//arch/x86/oprofile/nmi_int.c	2010-05-03 23:46:51.018835896 -0400
@@ -601,6 +601,7 @@ static int __init ppro_init(char **cpu_t
 		break;
 	case 0x2e:
 	case 26:
+	case 30:
 		spec = &op_arch_perfmon_spec;
 		*cpu_type = "i386/core_i7";
 		break;

-- 
                                       Nick Black <nickblack@linux.com>
                                  Grad student, GT College of Computing
                    "np: the class of dashed hopes, and idle dreams..."
