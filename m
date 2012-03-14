Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030810Ab2CNNIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 09:08:19 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46302 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757690Ab2CNNIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 09:08:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120314111357.GD4434@tiehlicka.suse.cz>
References: <CAJd=RBATj97k5UESDFx82bzt0K4OquhBoDkfjPBPacdmdfJE8g@mail.gmail.com>
	<20120314111357.GD4434@tiehlicka.suse.cz>
Date: Wed, 14 Mar 2012 21:08:13 +0800
Message-ID: <CAJd=RBBd0vF1waARU5FQbomLQLAG5ekmiWg+WDpALke9SaGP1g@mail.gmail.com>
Subject: Re: [PATCH] mm: hugetlb: defer freeing pages when gathering surplus pages
From: Hillf Danton <dhillf@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 7:13 PM, Michal Hocko <mhocko@suse.cz> wrote:
> [Sorry for the late reply but I was away from email for quite sometime]
>

Nice to see you back:)

> On Tue 14-02-12 20:53:51, Hillf Danton wrote:
>> When gathering surplus pages, the number of needed pages is recomputed after
>> reacquiring hugetlb lock to catch changes in resv_huge_pages and
>> free_huge_pages. Plus it is recomputed with the number of newly allocated
>> pages involved.
>>
>> Thus freeing pages could be deferred a bit to see if the final page request is
>> satisfied, though pages could be allocated less than needed.
>
> The patch looks OK but I am missing a word why we need it. I guess

False negative is removed as it should be.

> your primary motivation is that we want to reduce false positives when
> we fail to allocate surplus pages while somebody freed some in the
> background.
> What is the workload that you observed such a behavior? Or is this just
> from the code review?
>
The second.

-hd
