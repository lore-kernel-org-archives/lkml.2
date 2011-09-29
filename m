Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1I2BC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 21:02:56 -0400
Received: from [124.207.24.138] ([124.207.24.138]:48055 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab1I2BCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 21:02:55 -0400
MIME-Version: 1.0
In-Reply-To: <20110928180503.GC1696@barrios-desktop>
References: <1317174330-2677-1-git-send-email-minchan.kim@gmail.com>
	<CAF1ivSaf8ER9yDWohudy-huiq5QHS8vE04R+4+nPTQihZ2MAmQ@mail.gmail.com>
	<20110928180503.GC1696@barrios-desktop>
Date: Thu, 29 Sep 2011 09:02:36 +0800
Message-ID: <CAF1ivSbPoC_ngCmwmTC+JJuNxhhSoJyCRhTRcWj9V9VgYwU9jQ@mail.gmail.com>
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

On Thu, Sep 29, 2011 at 2:05 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> On Wed, Sep 28, 2011 at 11:04:05PM +0800, Lin Ming wrote:
>> On Wed, Sep 28, 2011 at 9:45 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
>> > When racing between putback_lru_page and shmem_unlock happens,
>>
>> s/shmem_unlock/shmem_lock/
>
> I did it intentionally for represent shmem_lock with user = 1, lock = 0.
> If you think it makes others confusing, I will change in next version.
> Thanks.

I was confused. Now I understand.

>
>>
>> > progrom execution order is as follows, but clear_bit in processor #1
>> > could be reordered right before spin_unlock of processor #1.
>> > Then, the page would be stranded on the unevictable list.
>
> --
> Kind regards,
> Minchan Kim
