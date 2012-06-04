Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760944Ab2FDV3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 17:29:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab2FDV3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 17:29:20 -0400
From: Donald Dutile <ddutile@redhat.com>
To: dwmw2@infradead.org
Cc: iommu@lists.linux-foundation.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, chrisw@redhat.com,
        suresh.b.siddha@intel.com
Subject: [PATCH 0/2]intel-iommu: reserve IOMMU register space
Date: Mon,  4 Jun 2012 17:29:00 -0400
Message-Id: <1338845342-12464-1-git-send-email-ddutile@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reserve the memory space that Intel IOMMUs use so
they aren't dynamically allocated by hot-plug operations.
Seem on some systems when BIOS doesn't place IOMMU registers
in a safe, non-hotplug location. ... until BIOS quickly changed.

Since modifying dmar.c, and information prints in the code,
cleanup the info/warning prints in the first patch to use
more std pr_*() functions and formatting.

Second patch is core of the iomem space reservation.

Bjorn had posted a similar patch a couple weeks back,
and I informed him in a side note I had this patch set
in my queue, just needed couple minor edits to complete.
So, if you are having deja-vu, now you know why...

Signed-off-by: Donald Dutile <ddutile@redhat.com>

