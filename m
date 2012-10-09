Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab2JIQ6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:58:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53558 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab2JIQ6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:58:46 -0400
From: Mel Gorman <mgorman@suse.de>
To: Stable <stable@vger.kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 0/5] Memory policy corruption fixes -stable
Date: Tue,  9 Oct 2012 17:58:36 +0100
Message-Id: <1349801921-16598-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a backport of the series "Memory policy corruption fixes V2". This
should apply to 3.6-stable, 3.5-stable, 3.4-stable and 3.0-stable without
any difficulty.  It will not apply cleanly to 3.2 but just drop the "revert"
patch and the rest of the series should apply.

I tested 3.6-stable and 3.0-stable with just the revert and trinity breaks
as expected for the mempolicy tests. Applying the full series in both case
allowed trinity to complete successfully. Andi Kleen reported previously
that the series fixed a database performance regression[1].

[1] https://lkml.org/lkml/2012/8/22/585

 include/linux/mempolicy.h |    2 +-
 mm/mempolicy.c            |  137 +++++++++++++++++++++++++++++----------------
 2 files changed, 89 insertions(+), 50 deletions(-)

-- 
1.7.9.2

