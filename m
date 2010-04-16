Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab0DPEXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 00:23:48 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49399 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab0DPEXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 00:23:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 16 Apr 2010 13:18:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Message-Id: <20100416131823.c874125a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100416101339.a501f554.kamezawa.hiroyu@jp.fujitsu.com>
References: <1271117878-19274-1-git-send-email-david@fromorbit.com>
	<20100416101339.a501f554.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Apr 2010 10:13:39 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
 
> Hmm. Then, if memoy cgroup is filled by dirty pages, it can't kick writeback
> and has to wait for someone else's writeback ?
> 
> How long this will take ?
> # mount -t cgroup none /cgroup -o memory
> # mkdir /cgroup/A
> # echo 20M > /cgroup/A/memory.limit_in_bytes
> # echo $$ > /cgroup/A/tasks
> # dd if=/dev/zero of=./tmpfile bs=4096 count=1000000
> 
> Can memcg ask writeback thread to "Wake Up Now! and Write this out!" effectively ?
> 

Hmm.. I saw an oom-kill while testing several cases but performance itself
seems not to be far different with or without patch.
But I'm unhappy with oom-kill, so some tweak for memcg will be necessary
if we'll go with this.

Thanks,
-Kame

