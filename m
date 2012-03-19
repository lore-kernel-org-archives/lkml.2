Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031504Ab2CSOfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 10:35:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031244Ab2CSOfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 10:35:34 -0400
Date: Mon, 19 Mar 2012 15:35:19 +0100
From: Johannes Weiner <jweiner@redhat.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: forbid lumpy-reclaim in shrink_active_list()
Message-ID: <20120319143519.GD1699@redhat.com>
References: <20120319091821.17716.54031.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319091821.17716.54031.stgit@zurg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 01:18:21PM +0400, Konstantin Khlebnikov wrote:
> This patch reset reclaim mode in shrink_active_list() to RECLAIM_MODE_SINGLE | RECLAIM_MODE_ASYNC.
> (sync/async sign is used only in shrink_page_list and does not affect shrink_active_list)
> 
> Currenly shrink_active_list() sometimes works in lumpy-reclaim mode,
> if RECLAIM_MODE_LUMPYRECLAIM left over from earlier shrink_inactive_list().
> Meanwhile, in age_active_anon() sc->reclaim_mode is totally zero.
> So, current behavior is too complex and confusing, all this looks like bug.
> 
> In general, shrink_active_list() populate inactive list for next shrink_inactive_list().
> Lumpy shring_inactive_list() isolate pages around choosen one from both active and
> inactive lists. So, there no reasons for lumpy-isolation in shrink_active_list()
> 
> Proposed-by: Hugh Dickins <hughd@google.com>
> Link: https://lkml.org/lkml/2012/3/15/583
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
