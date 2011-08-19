Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab1HSX27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 19:28:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:38080 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114Ab1HSX24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 19:28:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="40204039"
From: Andi Kleen <andi@firstfloor.org>
To: Michel Lespinasse <walken@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH 6/9] mm: assert that get_page_unless_zero() callers hold the rcu lock
References: <1313740111-27446-1-git-send-email-walken@google.com>
	<1313740111-27446-7-git-send-email-walken@google.com>
Date: Fri, 19 Aug 2011 16:28:53 -0700
In-Reply-To: <1313740111-27446-7-git-send-email-walken@google.com> (Michel
	Lespinasse's message of "Fri, 19 Aug 2011 00:48:28 -0700")
Message-ID: <m2bovlhtfu.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> writes:
>
> Other call sites in memory_hotplug.c, memory_failure.c and hwpoison-inject.c
> are also exempted. It would be preferable if someone more familiar with

I see no reason why hwpoison-inject needs to be exempted. If it doesn't
hold rcu read lock it should.
-Andi

 

-- 
ak@linux.intel.com -- Speaking for myself only
