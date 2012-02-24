Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab2BXWdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 17:33:47 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64757 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829Ab2BXWdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 17:33:46 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of venki@google.com designates 10.68.220.162 as permitted sender) smtp.mail=venki@google.com; dkim=pass header.i=venki@google.com
MIME-Version: 1.0
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        Yong Zhang <yong.zhang0@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Extend mwait idle to optimize away CAL and RES interrupts to an idle CPU -v2
Date: Fri, 24 Feb 2012 14:33:16 -0800
Message-Id: <1330122800-834-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addressed various comments to the previous version. I did have to avoid
x86 smpboot cleanup that Ingo suggested as that did not seem trivial to me :-).
I also separated out the change that does percpu idle task caching. That
change does provide a measurable gain to the IPI sender overhead.

Previous versions
* RFC - https://lkml.org/lkml/2012/2/6/357
* v1 - https://lkml.org/lkml/2012/2/22/512

Changes since previous versions:
RFC to v1
 Moved the changes into arch specific code as per PeterZ suggestion (Mostly)
 Got rid of new per cpu state logic in favor of TIF flag bits

v1 to v2
 Generic TS_POLLING cleanup
 Really really no change to generic code (other than TS_POLLING cleanup)
 Single bit in TIF flags. Had to get rid of micro optimization of avoiding
  second IPI to a CPU when there is already one pending, in favor of keeping
  code simple and faster in common case.
 Add irq_enter irq_exit around pending interrupt handlers
 Extended the optimization to cover C1 mwait() and poll_idle()
