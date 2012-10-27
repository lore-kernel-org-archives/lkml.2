Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458Ab2J0VVD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 17:21:03 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:56883 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181Ab2J0VVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 17:21:00 -0400
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH 0/2] mm: do not call frontswap_init() during swapoff
Date: Sat, 27 Oct 2012 19:20:45 -0200
Message-Id: <1351372847-13625-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The call to frontswap_init() was added in a place where it is called not
only from sys_swapon, but also from sys_swapoff. This pair of patches
fixes that.

The first patch moves the acquisition of swap_lock from enable_swap_info
to two separate helpers, one for sys_swapon and one for sys_swapoff. As
a bonus, it also makes the code for sys_swapoff less subtle.

The second patch moves the call to frontswap_init() from the common code
to the helper used only by sys_swapon.

Compile-tested only, but should be safe.

Cesar Eduardo Barros (2):
  mm: refactor reinsert of swap_info in sys_swapoff
  mm: do not call frontswap_init() during swapoff

 mm/swapfile.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

-- 
1.7.11.7

