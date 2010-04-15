Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab0DOQnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 12:43:20 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47874 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab0DOQnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 12:43:18 -0400
From: Borislav Petkov <bp@amd64.org>
To: <hpa@zytor.com>, <mingo@elte.hu>, <tglx@linutronix.de>
Cc: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
       Frank Arnold <frank.arnold@amd.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/5] AMD L3 cache index disable fixes for .35
Date: Thu, 15 Apr 2010 18:40:58 +0200
Message-Id: <1271349663-16670-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi,

this is a small patchset of fixes for L3 CID which have accumulated over
the last couple of weeks. They serve as a preparation for disabling L3
cache indices whenever an L3 MCE triggers, has been evaluated and the
offending index thresholded and, if error rate is excessively high,
disabled. Those patches will be coming up later though.

Patches 1,3,4 are cleanups and unifications which save us a little bit
of percpu memory in favor of dynamic allocation. Also, we have an L3
cache descriptor per node now instead of having this information per
CPU.

I triggered a lockdep warning in lockdep_trace_alloc() during testing
due to the fact that we may run with disabled interrupts that early
in the boot process. Therefore, I have a GFP_ATOMIC in patch 3 there
allocating the cache descriptors. I'm open for suggestions in case this
is undesired.

Patch 2 is a fix which triggers when we run as a guest on Xen due to Xen
not exporting CPU PCI config space to the guests.

And finally #5 is a required fix.

The patchset is also available at
git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git l3-for-35

Please queue for .35,
thanks.
