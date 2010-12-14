Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057Ab0LNCNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 21:13:05 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33507 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758901Ab0LNCNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 21:13:02 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 14 Dec 2010 11:07:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Ben Gamari <bgamari.foss@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH v4 4/7] Reclaim invalidated page ASAP
Message-Id: <20101214110711.af70b5b0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101213153105.GA2344@barrios-desktop>
References: <cover.1291568905.git.minchan.kim@gmail.com>
	<0724024711222476a0c8deadb5b366265b8e5824.1291568905.git.minchan.kim@gmail.com>
	<20101208170504.1750.A69D9226@jp.fujitsu.com>
	<AANLkTikG1EAMm8yPvBVUXjFz1Bu9m+vfwH3TRPDzS9mq@mail.gmail.com>
	<87oc8wa063.fsf@gmail.com>
	<AANLkTin642NFLMubtCQhSVUNLzfdk5ajz-RWe2zT+Lw6@mail.gmail.com>
	<20101213153105.GA2344@barrios-desktop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010 00:31:05 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Test Environment :
> DRAM : 2G, CPU : Intel(R) Core(TM)2 CPU
> Rsync backup directory size : 16G
> 
> rsync version is 3.0.7.
> rsync patch is Ben's fadivse.
> stress scenario do following jobs with parallel.
> 
> 1. make all -j4 linux, git clone linux-kernel
> 2. git clone linux-kernel
> 3. rsync src dst
> 
> nrns : no-patched rsync + no stress
> prns : patched rsync + no stress
> nrs  : no-patched rsync + stress
> prs  : patched rsync + stress
> 
> pginvalidate : the number of dirty/writeback pages which is invalidated by fadvise
> pgreclaim : pages moved PG_reclaim trick in inactive's tail
> 
> In summary, my patch enhances a littie bit about elapsed time in
> memory pressure environment and enhance reclaim effectivness(reclaim/reclaim)
> with x2. It means reclaim latency is short and doesn't evict working set
> pages due to invalidated pages.
> 
> Look at reclaim effectivness. Patched rsync enhances x2 about reclaim
> effectiveness and compared to mmotm-12-03, mmotm-12-03-fadvise enhances
> 3 minute about elapsed time in stress environment. 
> I think it's due to reduce scanning, reclaim overhead.
> 
> In no-stress enviroment, fadivse makes program little bit slow.
> I think because there are many pgfault. I don't know why it happens.
> Could you guess why it happens?
> 
> Before futher work, I hope listen opinions.
> Any comment is welcome.
> 

At first, the improvement seems great. Thank you for your effort.

> In no-stress enviroment, fadivse makes program little bit slow.
> I think because there are many pgfault. I don't know why it happens.
> Could you guess why it happens?
>

Are there no program which accesses a directory rsync'ed ?

Thanks,
-Kame

