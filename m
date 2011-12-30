Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab1L3IMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 03:12:12 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46157 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab1L3IML convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 03:12:11 -0500
MIME-Version: 1.0
In-Reply-To: <1325226961-4271-1-git-send-email-tm@tao.ma>
References: <1325226961-4271-1-git-send-email-tm@tao.ma>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 30 Dec 2011 03:11:49 -0500
X-Google-Sender-Auth: dpsJs5TnNKqJUriMiqiRSi5GuK8
Message-ID: <CAHGf_=qOGy3MQgiFyfeG82+gbDXTBT5KQjgR7JqMfQ7e7RSGpA@mail.gmail.com>
Subject: Re: [PATCH] mm: do not drain pagevecs for mlock
To: Tao Ma <tm@tao.ma>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/30 Tao Ma <tm@tao.ma>:
> In our test of mlock, we have found some severe performance regression
> in it. Some more investigations show that mlocked is blocked heavily
> by lur_add_drain_all which calls schedule_on_each_cpu and flush the work
> queue which is very slower if we have several cpus.
>
> So we have tried 2 ways to solve it:
> 1. Add a per cpu counter for all the pagevecs so that we don't schedule
>   and flush the lru_drain work if the cpu doesn't have any pagevecs(I
>   have finished the codes already).
> 2. Remove the lru_add_drain_all.
>
> The first one has some problems since in our product system, all the cpus
> are busy, so I guess there is very little chance for a cpu to have 0 pagevecs
> except that you run several consecutive mlocks.
>
> From the commit log which added this function(8891d6da), it seems that we
> don't have to call it. So the 2nd one seems to be both easy and workable and
> comes this patch.

Could you please show us your system environment and benchmark programs?
Usually lru_drain_** is very fast than mlock() body because it makes
plenty memset(page).
