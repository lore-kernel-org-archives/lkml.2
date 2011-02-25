Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab1BYSBE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:01:04 -0500
Received: from gir.skynet.ie ([193.1.99.77]:56208 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822Ab1BYSBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:01:01 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arthur Marsh <arthur.marsh@internode.on.net>,
        Clemens Ladisch <cladisch@googlemail.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Reduce the amount of time compaction disables IRQs for
Date: Fri, 25 Feb 2011 18:00:54 +0000
Message-Id: <1298656856-6074-1-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches are aimed at reducing the amount of time IRQs are
disabled. It was reported by some ALSA people that transparent hugepages was
causing slowdowns on MIDI playback but I strongly suspect that compaction
running for smaller orders was also a factor. The theory was that IRQs
were being disabled for too long and sure enough, compaction was found to
be disabling IRQs for a long time. The patches reduce the length of time
IRQs are disabled when scanning for free pages and for pages to migrate.

It's late in the cycle but the IRQs disabled times are sufficiently bad
that it would be desirable to have these merged for 2.6.38 if possible.

 mm/compaction.c |   35 ++++++++++++++++++++++++++++++-----
 1 files changed, 30 insertions(+), 5 deletions(-)

-- 
1.7.2.3

