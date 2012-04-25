Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab2DYBeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 21:34:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50825 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab2DYBeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 21:34:24 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F975430.4090107@jp.fujitsu.com>
Date: Wed, 25 Apr 2012 10:32:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@openvz.org, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 09/23] kmem slab accounting basic infrastructure
References: <1334959051-18203-1-git-send-email-glommer@parallels.com> <1334959051-18203-10-git-send-email-glommer@parallels.com>
In-Reply-To: <1334959051-18203-10-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/21 6:57), Glauber Costa wrote:

> This patch adds the basic infrastructure for the accounting of the slab
> caches. To control that, the following files are created:
> 
>  * memory.kmem.usage_in_bytes
>  * memory.kmem.limit_in_bytes
>  * memory.kmem.failcnt
>  * memory.kmem.max_usage_in_bytes
> 
> They have the same meaning of their user memory counterparts. They reflect
> the state of the "kmem" res_counter.
> 
> The code is not enabled until a limit is set. This can be tested by the flag
> "kmem_accounted". This means that after the patch is applied, no behavioral
> changes exists for whoever is still using memcg to control their memory usage.
> 

Hmm, res_counter never goes naeative ?

> We always account to both user and kernel resource_counters. This effectively
> means that an independent kernel limit is in place when the limit is set
> to a lower value than the user memory. A equal or higher value means that the
> user limit will always hit first, meaning that kmem is effectively unlimited.
> 
> People who want to track kernel memory but not limit it, can set this limit
> to a very high number (like RESOURCE_MAX - 1page - that no one will ever hit,
> or equal to the user memory)
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Michal Hocko <mhocko@suse.cz>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Johannes Weiner <hannes@cmpxchg.org>


The code itself seems fine.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

