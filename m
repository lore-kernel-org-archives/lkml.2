Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab1EaF6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 01:58:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58582 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab1EaF6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 01:58:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YBWgW53bXvmQ5p8yu2opP/OfBJekQxYE9skJYTVQ69WBwSonFEhC7vurxziokSdGY7
         QbsLt+CwrX3fbgV28Hx8exNODue5+wFhDsryvOTVVfVUzmI2FIamRlTB0d4sseR52Fyv
         l5TuDrCPy03urS4gWH1iOADX+zxjnIo2j0oAA=
Date: Tue, 31 May 2011 14:57:57 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Christoph Lameter <cl@linux.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] mm, vmstat: Use cond_resched only when !CONFIG_PREEMPT
Message-ID: <20110531055756.GA2829@barrios-laptop>
References: <1306774744.4061.5.camel@localhost.localdomain>
 <20110531055528.GB1519@barrios-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110531055528.GB1519@barrios-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 02:55:28PM +0900, Minchan Kim wrote:
> On Mon, May 30, 2011 at 10:59:04PM +0600, Rakib Mullick wrote:
> > commit 468fd62ed9 (vmstats: add cond_resched() to refresh_cpu_vm_stats()) added cond_resched() in refresh_cpu_vm_stats. Purpose of that patch was to allow other threads to run in non-preemptive case. This patch, makes sure that cond_resched() gets called when !CONFIG_PREEMPT is set. In a preemptiable kernel we don't need to call cond_resched().
> > 
> > Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> 
> Let me ask questions.
> 
> 1. What's bad if we call cond_resched on CONFIG_PREEMPT?
>    Is refresh_cpu_vm_stats a hot path?
> 2. There is no help to call explicit scheduling point on CONFIG_PREEMPTION?
>  
> We used cond_resched without any ifdef/endif of CONFIG_PREEMPT.
> In addtion, cond_resched includes __might_sleep which is debugging help for lock.
> So I hope let it be if you have a big concern.
		typo  ^^
		      unless

-- 
Kind regards
Minchan Kim
