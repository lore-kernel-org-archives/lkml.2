Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab0F3OEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 10:04:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54240 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab0F3OEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 10:04:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oqNE1g8UswtM6X5Op6fGqhL25qAK6E7SZggaJ8K7J4+l4QaQECU+p9RDjFSytWse+e
         TNCcCnKuiWYgU3TZl0044lY3SpMUEvaxBtAIhTLVQJXCVFnWxDykj9MWl5KkxN336sof
         79II9e2Mm6V8n0kr2foKEnVR2N+hRUYVn/quc=
Date: Wed, 30 Jun 2010 23:03:53 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 05/11] oom: /proc/<pid>/oom_score treat kernel thread
 honestly
Message-ID: <20100630140328.GC15644@barrios-desktop>
References: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
 <20100630182922.AA56.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630182922.AA56.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 06:30:19PM +0900, KOSAKI Motohiro wrote:
> If kernel thread are using use_mm(), badness() return positive value.
> This is not big issue because caller care it correctly. but there is
> one exception, /proc/<pid>/oom_score call badness() directly and
> don't care the task is regular process.
> 
> another example, /proc/1/oom_score return !0 value. but it's unkillable.
> This incorrectness makes confusing to admin a bit.

Hmm. If it is a really problem, Could we solve it in proc_oom_score itself?

-- 
Kind regards,
Minchan Kim
