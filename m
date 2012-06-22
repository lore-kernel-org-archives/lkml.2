Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190Ab2FVVLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 17:11:22 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:52040 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab2FVVLU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 17:11:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120622131901.28f273e3.akpm@linux-foundation.org>
References: <1339690570-7471-1-git-send-email-kosaki.motohiro@gmail.com> <20120622131901.28f273e3.akpm@linux-foundation.org>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Fri, 22 Jun 2012 17:10:59 -0400
Message-ID: <CAHGf_=rQ6AaZBjfvkWWKi+a5q+1R29_PGWDyD77VFisgJHPQEA@mail.gmail.com>
Subject: Re: [PATCH] mm: clear pages_scanned only if draining a pcp adds pages
 to the buddy allocator again
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 4:19 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 14 Jun 2012 12:16:10 -0400
> kosaki.motohiro@gmail.com wrote:
>
>> commit 2ff754fa8f (mm: clear pages_scanned only if draining a pcp adds pages
>> to the buddy allocator again) fixed one free_pcppages_bulk() misuse. But two
>> another miuse still exist.
>
> This changelog is irritating.  One can understand it a bit if one
> happens to have a git repo handy (and why do this to the reader?), but
> the changelog for 2ff754fa8f indicates that the patch might fix a
> livelock.  Is that true of this patch?  Who knows...

The code in this simple patch speak the right usage, isn't it? And yes,
this patch also fixes a possibility of live lock. (but i haven't seen actual
live lock cause from this mistake)

When anyone find a function misuse and fixes it, He/She should confirm other
callsite and should all of mistake too. Otherwise we observe the same issue
sooner of later.
