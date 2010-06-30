Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab0F3OUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 10:20:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42018 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab0F3OUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 10:20:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ndq9gQaeSGVXaNXrCBgaw97Dp9pGa36I71z77CqurqFe4RDIQcoIryzDkCK66EVMKs
         uk8tvH321oB1nzRZwN8KHqX1XWoFf9ouoP8y5L2EznddRRiWI/4INjXnGZXeSR8MZkna
         sObq53p9jcOr3HzDeCxzo+9UBwgNmi1slcLVQ=
Date: Wed, 30 Jun 2010 23:20:34 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 07/11] oom: move OOM_DISABLE check from oom_kill_task
 to out_of_memory()
Message-ID: <20100630142034.GF15644@barrios-desktop>
References: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
 <20100630183059.AA5C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630183059.AA5C.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 06:31:36PM +0900, KOSAKI Motohiro wrote:
> Now, if oom_kill_allocating_task is enabled and current have
> OOM_DISABLED, following printk in oom_kill_process is called twice.
> 
>     pr_err("%s: Kill process %d (%s) score %lu or sacrifice child\n",
>             message, task_pid_nr(p), p->comm, points);
> 
> So, OOM_DISABLE check should be more early.

If we check it in oom_unkillable_task, we don't need this patch. 

-- 
Kind regards,
Minchan Kim
