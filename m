Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab1DMSlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 14:41:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:24889 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab1DMSlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 14:41:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=gjPYSSVGyci9ioZdDTvBIG6BNHKZUsK3TlQyR0DW+0aCl3tyT9ePFk6Q08jh0gFX7z
         yi0GEu99KWiDOCk4qg6w==
Date: Wed, 13 Apr 2011 11:41:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrey Vagin <avagin@openvz.org>, Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/4] remove boost_dying_task_prio()
In-Reply-To: <20110411143215.0074.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1104131141040.5563@chino.kir.corp.google.com>
References: <20110411142949.006C.A69D9226@jp.fujitsu.com> <20110411143215.0074.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011, KOSAKI Motohiro wrote:

> This is a almost revert commit 93b43fa (oom: give the dying
> task a higher priority).
> 
> The commit dramatically improve oom killer logic when fork-bomb
> occur. But, I've found it has nasty corner case. Now cpu cgroup
> has strange default RT runtime. It's 0! That said, if a process
> under cpu cgroup promote RT scheduling class, the process never
> run at all.
> 
> Eventually, kernel may hang up when oom kill occur.
> I and Luis who original author agreed to disable this logic at
> once.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: Luis Claudio R. Goncalves <lclaudio@uudg.org>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
