Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab0DVOHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 10:07:18 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41274 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab0DVOHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 10:07:14 -0400
From: Borislav Petkov <bp@amd64.org>
To: <hpa@zytor.com>, <mingo@elte.hu>, <tglx@linutronix.de>
Cc: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
       Frank Arnold <frank.arnold@amd.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH -v2 0/5] AMD L3 cache index disable fixes for .35
Date: Thu, 22 Apr 2010 16:06:57 +0200
Message-Id: <1271945222-5283-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi,

here's the dynamic allocation version in 4/5. The small amount of
NUM_NODES * 8 Bytes is not being freed because we don't have an exit
callback but I guess this is ok since we want to free it only when
shutting down anyway.

-v2:

Allocate l3_caches descriptor array dynamically.

-v1:

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
