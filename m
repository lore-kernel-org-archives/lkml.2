Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab0KNVdy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 16:33:54 -0500
Received: from smtp-out.google.com ([74.125.121.35]:16183 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006Ab0KNVdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 16:33:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=EpOko9qreGXV0IOHHeYqasto72kaNAAPkflaP70maRF2JPw1+Ww/BKwvqPiIhXK0O/
         tg6BWt0UmSu5luFJ7MdQ==
Date: Sun, 14 Nov 2010 13:33:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: "Figo.zhang" <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Figo.zhang" <zhangtianfei@leadcoretech.com>
Subject: Re: [PATCH v3]mm/oom-kill: direct hardware access processes should
 get bonus
In-Reply-To: <20101114141913.E019.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1011141330120.22262@chino.kir.corp.google.com>
References: <1289402093.10699.25.camel@localhost.localdomain> <1289402666.10699.28.camel@localhost.localdomain> <20101114141913.E019.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Nov 2010, KOSAKI Motohiro wrote:

> > the victim should not directly access hardware devices like Xorg server,
> > because the hardware could be left in an unpredictable state, although 
> > user-application can set /proc/pid/oom_score_adj to protect it. so i think
> > those processes should get bonus for protection.
> > 
> > in v2, fix the incorrect comment.
> > in v3, change the divided the badness score by 4, like old heuristic for protection. we just
> > want the oom_killer don't select Root/RESOURCE/RAWIO process as possible.
> > 
> > suppose that if a user process A such as email cleint "evolution" and a process B with
> > ditecly hareware access such as "Xorg", they have eat the equal memory (the badness score is 
> > the same),so which process are you want to kill? so in new heuristic, it will kill the process B.
> > but in reality, we want to kill process A.
> > 
> > Signed-off-by: Figo.zhang <figo1802@gmail.com>
> > Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> Sorry for the delay. I've sent completely revert patch to linus. It will
> disappear your headache, I believe. I'm sorry that our development
> caused your harm. We really don't want it.
> 

Oh please, your dramatics are getting better and better.

Figo.zhang never described a problem that was being addressed but rather 
proposed several different variants of a patch (some with CAP_SYS_ADMIN, 
some with CAP_SYS_RESOURCE, some with CAP_SYS_RAWIO, some with a 
combination, some with a 3% bonus, some with a order-of-2 bonus, etc) to 
return the same heuristic used in the old oom killer.  I asked several 
times to show the oom killer log from the problematic behavior and none 
were presented.
