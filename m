Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab0KVBhN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:37:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:37835 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900Ab0KVBhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:37:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,232,1288594800"; 
   d="scan'208";a="860004239"
Date: Mon, 22 Nov 2010 09:36:55 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] vmscan: Make move_active_pages_to_lru more generic
Message-ID: <20101122013655.GA10126@localhost>
References: <1290349496-13297-1-git-send-email-minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290349496-13297-1-git-send-email-minchan.kim@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 10:24:56PM +0800, Minchan Kim wrote:
> Now move_active_pages_to_lru can move pages into active or inactive.
> if it moves the pages into inactive, it itself can clear PG_acive.
> It makes the function more generic.

Do you plan to use this "more generic" function? Because the patch in
itself makes code slightly less efficient. It adds one "if" test, and
moves one operation into the spin lock.

Thanks,
Fengguang
