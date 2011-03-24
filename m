Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab1CXCZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 22:25:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754915Ab1CXCZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 22:25:49 -0400
Date: Wed, 23 Mar 2011 19:21:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nick Piggin <npiggin@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/5] vmscan: remove all_unreclaimable check from direct
 reclaim path completely
Message-Id: <20110323192150.9895afe3.akpm@linux-foundation.org>
In-Reply-To: <20110324111200.1AF4.A69D9226@jp.fujitsu.com>
References: <20110323174545.1AE2.A69D9226@jp.fujitsu.com>
	<AANLkTi=w62=WR5WACJGk6JNhyCYpgNhFQK3CyQ5Ag-Yj@mail.gmail.com>
	<20110324111200.1AF4.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 11:11:46 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Subject: [PATCH] vmscan: remove all_unreclaimable check from direct reclaim path completely

zone.all_unreclaimable is there to prevent reclaim from wasting CPU
cycles scanning a zone which has no reclaimable pages.  When originally
implemented it did this very well.

That you guys keep breaking it, or don't feel like improving it is not a
reason to remove it!

If the code is unneeded and the kernel now reliably solves this problem
by other means then this should have been fully explained in the
changelog, but it was not even mentioned.

