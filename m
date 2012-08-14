Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab2HNI23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:28:29 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:40030 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2HNI20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:28:26 -0400
Message-ID: <502A0C19.6010007@linux.vnet.ibm.com>
Date: Tue, 14 Aug 2012 13:58:09 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: tglx@linutronix.de, mingo@kernel.org, paulmck@linux.vnet.ibm.com,
        josh@joshtriplett.org, linux-kernel@vger.kernel.org
Subject: [PATCH] preempt/hardirq.h: Clarify PREEMPT_ACTIVE bit location
References: <20120720192459.6149.14821.stgit@srivatsabhat.in.ibm.com> <1343706583.27983.28.camel@gandalf.stny.rr.com>
In-Reply-To: <1343706583.27983.28.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
x-cbid: 12081408-5564-0000-0000-00000402DCA0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


By default, the PREEMPT_ACTIVE flag is bit 27, but different
architectures can override that. Update the comment to reflect
this fact.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/hardirq.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 305f23c..483aa60 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -20,10 +20,15 @@
  * hardirq nesting. An arch may choose to give less than 10 bits.
  * m68k expects it to be 8.
  *
+ * By default, the bits are defined as shown below:
+ *
  * - bits 16-25 are the hardirq count (max # of nested hardirqs: 1024)
  * - bit 26 is the NMI_MASK
  * - bit 27 is the PREEMPT_ACTIVE flag
  *
+ * However, different architectures may override them. (For example,
+ * x86 defines bit 28 as the PREEMPT_ACTIVE flag).
+ *
  * PREEMPT_MASK: 0x000000ff
  * SOFTIRQ_MASK: 0x0000ff00
  * HARDIRQ_MASK: 0x03ff0000


