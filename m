Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826Ab1J1XWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 19:22:17 -0400
Received: from smtp-out.google.com ([74.125.121.67]:19831 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab1J1XWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 19:22:16 -0400
From: Bryan Freed <bfreed@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: sergiu@chromium.org, akpm@linux-foundation.org, msb@chromium.org,
        marco.stornelli@gmail.com, seiji.aguchi@hds.com,
        Bryan Freed <bfreed@chromium.org>
Subject: [PATCH] ramoops appears geared to not support ARM
Date: Fri, 28 Oct 2011 16:21:49 -0700
Message-Id: <1319844110-23062-1-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had some difficulty in getting ramoops to work on our ARM systems.
The driver maps memory with ioremap() which is supposed to map IO memory,
not physical RAM.  This happens to work on x86 and apparently some other
architectures, but it does not work on ARM.
Specifically, I see this comment in __arm_ioremap_pfn_caller():
	Don't allow RAM to be mapped - this causes problems with ARMv6+

So here is a patch that hacks around the issue using page_is_ram() to
differentiate between the two.

Am I missing something here?
Is ramoops working on any ARM systems yet, and I am just doing something wrong?

My ARM platform reserves a section of RAM for use by ramoops, but it is still
mapped along with the rest of main memory.  This is so /dev/mem can find it
with xlate_dev_mem_ptr().
On x86, I see our BIOS reserves the memory so that it is not counted as main
memory, and it is not mapped until ramoops ioremaps it.

Bryan Freed (1):
  ramoops: Add support for ARM systems.

 drivers/char/ramoops.c |   67 +++++++++++++++++++++++++++++++++++++----------
 1 files changed, 52 insertions(+), 15 deletions(-)

-- 
1.7.3.1

