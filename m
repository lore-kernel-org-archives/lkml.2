Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909Ab1EaFzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 01:55:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37877 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1EaFzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 01:55:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZDvOg0CKB3FxyHVOhmTJC+OoGRfUz4MoYe/9HDMRyUxX1eLZD3b5X5KV+PNeWbQyTS
         ASUg6BIMRDncjpPb3Pa+qGVMiNp1QpNjkfWBIcJy3IX1BEylyO8RWjCohYPeywtXMWZe
         f5a2JKM8otriOJTuvBy6L+MFjegDlh69flu1g=
Date: Tue, 31 May 2011 14:55:28 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Christoph Lameter <cl@linux.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] mm, vmstat: Use cond_resched only when !CONFIG_PREEMPT
Message-ID: <20110531055528.GB1519@barrios-laptop>
References: <1306774744.4061.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306774744.4061.5.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 10:59:04PM +0600, Rakib Mullick wrote:
> commit 468fd62ed9 (vmstats: add cond_resched() to refresh_cpu_vm_stats()) added cond_resched() in refresh_cpu_vm_stats. Purpose of that patch was to allow other threads to run in non-preemptive case. This patch, makes sure that cond_resched() gets called when !CONFIG_PREEMPT is set. In a preemptiable kernel we don't need to call cond_resched().
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

Let me ask questions.

1. What's bad if we call cond_resched on CONFIG_PREEMPT?
   Is refresh_cpu_vm_stats a hot path?
2. There is no help to call explicit scheduling point on CONFIG_PREEMPTION?
 
We used cond_resched without any ifdef/endif of CONFIG_PREEMPT.
In addtion, cond_resched includes __might_sleep which is debugging help for lock.
So I hope let it be if you have a big concern.

-- 
Kind regards
Meinchan Kim
