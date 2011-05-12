Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab1ELQHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 12:07:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36376 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918Ab1ELQHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 12:07:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DjKOHPOWU3P3oVcGauUX2VAmp31tIjJ6vdv0TQsDGca4YDnEenu88YFaK3rvcPML7a
         Rt37Rr0pgZxbsNBtYe/FDnFy91s588G+3Or5p+lUNC4Aff0FMZsAnX2bt1UJ9QKDyJcT
         M8AXLLFyxGaA4BKv7NF2h9A7U8rBpEaazZPNs=
Date: Thu, 12 May 2011 18:07:09 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 10/11] ptrace: move JOBCTL_TRAPPING wait to wait(2) and
 ptrace_check_attach()
Message-ID: <20110512160709.GL1030@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-11-git-send-email-tj@kernel.org>
 <20110511164947.GA26383@redhat.com>
 <20110511195333.GE24245@mtj.dyndns.org>
 <20110512155910.GD18599@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512155910.GD18599@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, May 12, 2011 at 05:59:10PM +0200, Oleg Nesterov wrote:
> > I don't know.  Why is retrying hairy?  The whole waiting logic is
> > built for clean retries.  The suggested change just does it without
> > intervening sleeping and waking up.  I don't see anything particularly
> > hairy there.
> 
> As always, this is subjective. But I didn't mean -EAGAIN itself. In fact
> I was going to add this (simple) logic some time ago and kill the EXIT_DEAD
> state. Hmm, and I'd still like to do this...

Oh, I've been updating code and it's now using interruptible sleep +
-ERESTARTNOINTR return.  It's simpler and the freezer problem is gone
too.

> I meant the whole ptrace_wait_trapping() + lock dance + retry thing.
> But of course I do not pretend my feeling is right.

Yeah, it's more complex than I would have liked.  The problem is that
ptrace(2) isn't really equipped with facilities to handle async
events, so it's a bit painful to add async mechanism into the existing
mechanics, but most problems seem solvable.

> Also. _Perhaps_ we can rethink the SIGCONT trapping, and perhaps in
> this case do_wait() won't need any changes. May be.

But, if there's a better way, sure.

Thanks.

-- 
tejun
