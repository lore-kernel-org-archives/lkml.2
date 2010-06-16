Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992Ab0FPOlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 10:41:37 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64636 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758912Ab0FPOlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 10:41:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rHGjgrSMTCS351LW6WV05KRZWc/GkMn9ZJXKUQNhiEA20sOEfx4FflZ/zawL+nrlch
         6ax/MMn7bJZI3Y8jQs+R9TqbIejJ4pW0wf6qTWrTaBbabfiGwX9SzAuLpfPptZCEFAL/
         1XtRQo3Fx2qb4DzR6qvZWt2KpYF2098QM2ZRw=
Date: Wed, 16 Jun 2010 23:41:27 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/9] oom: don't try to kill oom_unkillable child
Message-ID: <20100616144127.GA9278@barrios-desktop>
References: <20100616201948.72D7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616201948.72D7.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 08:29:13PM +0900, KOSAKI Motohiro wrote:
> Now, badness() doesn't care neigher CPUSET nor mempolicy. Then
> if the victim child process have disjoint nodemask, __out_of_memory()
> can makes kernel hang eventually.
> 
> This patch fixes it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

This patch inclues two things. 

1. consider cpuset and mempolicy in oom_kill_process
2. Simplify mempolicy oom check with nodemask != NULL 
   in select_bad_process.

1) change behavior but 2) is just cleanup. 
It should have been in another patch to reivew easily. :)

-- 
Kind regards,
Minchan Kim
