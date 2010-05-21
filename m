Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab0EUK3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 06:29:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45842 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab0EUK3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 06:29:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hDvVXrE9pfp0eucAG9uZhNDv4XrdkDL8TCLqYIVLxmQiVTmC5iZZhy6J31CIBq4OGd
         foJk/shHTQO9DvepXBk8VQDYQE1kpX+B7p1+YTSXZMF7/oqO8cbE34T3azXS3kZONowj
         RKknWm6S+z/5WfgD7G6Ar33/+Z8i7obHrNeJ0=
Date: Fri, 21 May 2010 12:29:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/2] perf: Drop the skip argument from
	perf_arch_fetch_regs_caller
Message-ID: <20100521102928.GF30108@nowhere>
References: <1274429477-21531-1-git-send-regression-fweisbec@gmail.com> <1274429477-21531-3-git-send-regression-fweisbec@gmail.com> <1274437477.1674.1698.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274437477.1674.1698.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 12:24:37PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-05-21 at 10:11 +0200, Frederic Weisbecker wrote:
> > +static inline void perf_fetch_caller_regs(struct pt_regs *regs)
> >  {
> > -       unsigned long ip;
> > -
> >         memset(regs, 0, sizeof(*regs));
> 
> btw, do we really need that memset?
> 
> As long as we don't actually copy out to userspace, it really doesn't
> matter what is in there, and we should be setting all relevant registers
> anyway.


We probably need to decouple that yeah.

- If we don't do callchains, we don't need to deref bp
- If we don't copy to userspace, we don't need to zeroe

We should do the filling much later for tracepoints in fact,
but that doesn't concern syscalls or kprobes.

But well, I'll iterate that step by step.

