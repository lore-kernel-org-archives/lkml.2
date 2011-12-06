Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab1LFUbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:31:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43376 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab1LFUbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:31:51 -0500
Date: Tue, 6 Dec 2011 12:31:48 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [3.2-rc3] OOM killer doesn't kill the obvious memory hog
In-Reply-To: <20111202144441.4c2ff29e.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1112061231320.28251@chino.kir.corp.google.com>
References: <20111201093644.GW7046@dastard> <20111201185001.5bf85500.kamezawa.hiroyu@jp.fujitsu.com> <20111201124634.GY7046@dastard> <alpine.DEB.2.00.1112011432110.27778@chino.kir.corp.google.com> <20111202015921.GZ7046@dastard> <20111202033148.GA7046@dastard>
 <20111202144441.4c2ff29e.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Dec 2011, KAMEZAWA Hiroyuki wrote:

> From ed565cbf842e0b30827fba7bfdbc724fe21d9d2d Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Fri, 2 Dec 2011 14:10:51 +0900
> Subject: [PATCH] oom_score_adj trace point.
> 
> oom_score_adj is set by some daemon and launch tasks ans inherited
> to applications, sometimes unexpectedly.
> 
> This patch is for debugging oom_score_adj inheritance. This
> adds trace points for oom_score_adj inheritance.
> 
>     bash-2501  [002]   448.860197: oom_score_adj_update: task 2501[bash] updates oom_score_adj=-1000
>     bash-2501  [002]   455.678190: oom_score_adj_inherited: new task 2527 inherited oom_score_adj -1000
>     ls-2527  [007]   455.678683: oom_score_task_rename: task 2527[bash] to [ls] oom_score_adj=-1000
>     bash-2501  [007]   461.632103: oom_score_adj_inherited: new task 2528 inherited oom_score_adj -1000
>     bash-2501  [007]   461.632335: oom_score_adj_inherited: new task 2529 inherited oom_score_adj -1000
>     ls-2528  [003]   461.632983: oom_score_task_rename: task 2528[bash] to [ls] oom_score_adj=-1000
>     less-2529  [005]   461.633086: oom_score_task_rename: task 2529[bash] to [less] oom_score_adj=-1000
>     bash-2501  [004]   474.888710: oom_score_adj_update: task 2501[bash] updates oom_score_adj=0
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>

Thanks Kame!
