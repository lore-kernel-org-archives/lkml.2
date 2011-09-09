Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844Ab1IIM6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 08:58:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758817Ab1IIM6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 08:58:17 -0400
Subject: Re: [PATCH 1/2] ptrace: don't modify flags on PTRACE_SETOPTIONS
 failure
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Indan Zupancic <indan@nul.nu>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 09 Sep 2011 14:58:02 +0200
In-Reply-To: <2d14558326f860dea54093d31d1ba12f.squirrel@webmail.greenhost.nl>
References: <201109090822.30063.vda.linux@googlemail.com>
	 <201109090824.37366.vda.linux@googlemail.com>
	 <2d14558326f860dea54093d31d1ba12f.squirrel@webmail.greenhost.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1315573084.4127.6.camel@dhcp-25-63.brq.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-09 at 14:44 +0200, Indan Zupancic wrote:
> Hello,
> 
> On Fri, September 9, 2011 08:24, Denys Vlasenko wrote:
> > It's very unlikely that there is userspace code in the wild which
> > will be affected by this change: it should have the form
> >
> >     ptrace(PTRACE_SETOPTIONS, pid, 0, PTRACE_O_BOGUSOPT)
> >
> > where PTRACE_O_BOGUSOPT is a constant unknown to the kernel.
> > But kernel headers, naturally, don't contain any
> > PTRACE_O_BOGUSOPTs, thus the only way userspace can use one
> > if it defines one itself. I can't see why anyone would do such
> > a thing deliberately.
> 
> The only realistic case is when a program compiled on a newer
> kernel is run on an older kernel, when it does things like
> 
> #ifndef PTRACE_O_TRACEFORK
> 	opts |= PTRACE_O_TRACEFORK;
> #endif
> 
> and happened to work on older kernels because it didn't check
> the return value.

Well, older kernels, of course, will have *old* behavior
of SETOPTIONS too! My patch will not magically propagate
back in time and change behavior of old kernels :)

-- 
vda


