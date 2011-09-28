Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab1I1PE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:04:26 -0400
Received: from [124.207.24.138] ([124.207.24.138]:35561 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab1I1PEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:04:25 -0400
MIME-Version: 1.0
In-Reply-To: <1317174330-2677-1-git-send-email-minchan.kim@gmail.com>
References: <1317174330-2677-1-git-send-email-minchan.kim@gmail.com>
Date: Wed, 28 Sep 2011 23:04:05 +0800
Message-ID: <CAF1ivSaf8ER9yDWohudy-huiq5QHS8vE04R+4+nPTQihZ2MAmQ@mail.gmail.com>
Subject: Re: [PATCH] vmscan: add barrier to prevent evictable page in
 unevictable list
From: Lin Ming <mlin@ss.pku.edu.cn>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 9:45 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> When racing between putback_lru_page and shmem_unlock happens,

s/shmem_unlock/shmem_lock/

> progrom execution order is as follows, but clear_bit in processor #1
> could be reordered right before spin_unlock of processor #1.
> Then, the page would be stranded on the unevictable list.
