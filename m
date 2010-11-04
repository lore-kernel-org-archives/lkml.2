Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0KDCzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 22:55:05 -0400
Received: from smtp-out.google.com ([74.125.121.35]:8202 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab0KDCzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 22:55:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=xV9lJpJtw0yjao8oUZuzWhv7JzrMpCFhsQ4umCGsd9Rd2c3V+MMaD+Nd97CAAU1VrU
         GjqVjefsVe7+Ys881SHQ==
Date: Wed, 3 Nov 2010 19:54:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Figo.zhang" <zhangtianfei@leadcoretech.com>
cc: figo zhang <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>
Subject: Re: Re:[PATCH v2]oom-kill: CAP_SYS_RESOURCE should get bonus
In-Reply-To: <1288836733.2124.18.camel@myhost>
Message-ID: <alpine.DEB.2.00.1011031952110.28251@chino.kir.corp.google.com>
References: <1288662213.10103.2.camel@localhost.localdomain> <1288827804.2725.0.camel@localhost.localdomain> <alpine.DEB.2.00.1011031646110.7830@chino.kir.corp.google.com> <AANLkTimjfmLzr_9+Sf4gk0xGkFjffQ1VcCnwmCXA88R8@mail.gmail.com> <1288834737.2124.11.camel@myhost>
 <alpine.DEB.2.00.1011031847450.21550@chino.kir.corp.google.com> <1288836733.2124.18.camel@myhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Nov 2010, Figo.zhang wrote:

> In your new heuristic, you also get CAP_SYS_RESOURCE to protection.
> see fs/proc/base.c, line 1167:
> 	if (oom_score_adj < task->signal->oom_score_adj &&
> 			!capable(CAP_SYS_RESOURCE)) {
> 		err = -EACCES;
> 		goto err_sighand;
> 	}

That's unchanged from the old behavior with oom_adj.

> so i want to protect some process like normal process not
> CAP_SYS_RESOUCE, i set a small oom_score_adj , if new oom_score_adj is
> small than now and it is not limited resource, it will not adjust, that
> seems not right?
> 

Tasks without CAP_SYS_RESOURCE cannot lower their own oom_score_adj, 
otherwise it can trivially kill other tasks.  They can, however, increase 
their own oom_score_adj so the oom killer prefers to kill it first.

I think you may be confused: CAP_SYS_RESOURCE override resource limits.
