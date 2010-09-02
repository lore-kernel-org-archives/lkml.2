Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab0IBUFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:05:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43660 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab0IBUFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:05:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] vmscan: don't use return value trick when oom_killer_disabled
Date: Thu, 2 Sep 2010 22:04:14 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-mm" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        "M. Vefa Bicakci" <bicave@superonline.com>, stable@kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
References: <1283442461-16290-1-git-send-email-minchan.kim@gmail.com>
In-Reply-To: <1283442461-16290-1-git-send-email-minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201009022204.14661.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 02, 2010, Minchan Kim wrote:
> M. Vefa Bicakci reported 2.6.35 kernel hang up when hibernation on his
> 32bit 3GB mem machine. (https://bugzilla.kernel.org/show_bug.cgi?id=16771)
> Also he was bisected first bad commit is below
> 
>   commit bb21c7ce18eff8e6e7877ca1d06c6db719376e3c
>   Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>   Date:   Fri Jun 4 14:15:05 2010 -0700
> 
>      vmscan: fix do_try_to_free_pages() return value when priority==0 reclaim failure
> 
> At first impression, this seemed very strange because the above commit only
> chenged function return value and hibernate_preallocate_memory() ignore
> return value of shrink_all_memory(). But it's related.
> 
> Now, page allocation from hibernation code may enter infinite loop if
> the system has highmem.
> 
> The reasons are two. 1) hibernate_preallocate_memory() call
> alloc_pages() wrong order

This isn't the case, as explained here: http://lkml.org/lkml/2010/9/1/316 .

The ordering of calls is correct, but it's better to check if there are any
non-highmem pages to allocate from before the last call (for performance
reasons, but that also would eliminate the failure in question).

Thanks,
Rafael
