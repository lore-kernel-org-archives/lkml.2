Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab1JQOnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:43:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab1JQOnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:43:08 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: thp: gup_fast s390/sparc tail refcounting [was Re: [PATCH] thp: tail page refcounting fix #6]
Date: Mon, 17 Oct 2011 16:41:54 +0200
Message-Id: <1318862517-7042-1-git-send-email-aarcange@redhat.com>
In-Reply-To: <1316793432.9084.47.camel@twins>
References: <1316793432.9084.47.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

These last three patches are incremental with the ones sent yesterday
(that in turn are incremental with the hugepage mapcount tail
refcounting race fix in -mm).

These should complete the gup_fast arch updates to support the
tail page mapcount refcounting.

sh is the only other one supporting gup_fast and hugetlbfs, but it
looked ok already so it requires no changes (it uses get_page). The
arch requiring updates can easily be found by searching:

	find arch/ -name hugetlbpage.c -or -name gup.c

I'm still uncertain why all these page_cache_get/add_speculative in
various gup.c and the pte change checks are needed there but I didn't
alter those, so if it worked before it'll still work the same.
