Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab0EFVZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 17:25:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751703Ab0EFVZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 17:25:11 -0400
Date: Thu, 6 May 2010 14:24:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp,
       kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Paul Menage <menage@google.com>
Subject: Re: [PATCH 2/2] mm: memcontrol - uninitialised return value
Message-Id: <20100506142417.6d317068.akpm@linux-foundation.org>
In-Reply-To: <1273058509-16625-2-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1273058509-16625-1-git-send-email-ext-phil.2.carmody@nokia.com>
	<1273058509-16625-2-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 May 2010 14:21:49 +0300
Phil Carmody <ext-phil.2.carmody@nokia.com> wrote:

> From: Phil Carmody <ext-phil.2.carmody@nokia.com>
> 
> Only an out of memory error will cause ret to be set.
> 
> Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
> Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> ---
>  mm/memcontrol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 90e32b2..09af773 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3464,7 +3464,7 @@ static int mem_cgroup_unregister_event(struct cgroup *cgrp, struct cftype *cft,
>  	int type = MEMFILE_TYPE(cft->private);
>  	u64 usage;
>  	int size = 0;
> -	int i, j, ret;
> +	int i, j, ret = 0;
>  
>  	mutex_lock(&memcg->thresholds_lock);
>  	if (type == _MEM)

afacit the return value of cftype.unregister_event() is always ignored
anyway.  Perhaps it should be changed to void-returning, or fixed.


