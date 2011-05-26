Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab1EZKLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 06:11:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37418 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab1EZKLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 06:11:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IvYxSduguCsrMgoG8gPBhWjaFTZc0E6K/gTXUWJBYIyLsv4ys3ZmmFYgshIkoJEsMz
         PDQnNnJ0O8RkQZ2XFrUUh8H3YvarCxzCvqQqmu2kcxK5oakidhpqCyFbPL6uI9laObfX
         5fwmBIYjHxNc+1iuW9/cDvkP3Lu9OPjAxIzMk=
Date: Thu, 26 May 2011 12:11:02 +0200
From: Tejun Heo <tj@kernel.org>
To: Pedro Alves <pedro@codesourcery.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Denys Vlasenko <vda.linux@googlemail.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110526101102.GF9715@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <20110525181856.GA16575@redhat.com>
 <20110526091041.GC9715@htj.dyndns.org>
 <201105261101.43237.pedro@codesourcery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105261101.43237.pedro@codesourcery.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Pedro.

On Thu, May 26, 2011 at 11:01:42AM +0100, Pedro Alves wrote:
> SYSGOOD makes sense, it just enables a means to distinguish syscall
> SIGTRAPs from regular SIGTRAPs -- it doesn't cause child stops itself.
> TRACE_EXEC, I'm not so sure.  (and it appears to have been proposed
> on the premise that SEIZE would still report the SIGTRAP).
> Why would that make sense, and not TRACE_FORK, for example?  I can imagine
> a tracer only caring for syscall entry/exit, and not needing a special
> event on exec.  IMO, any kind of event that forces a child stop that
> would't happen if the child wasn't traced should have to be enabled
> explicitly.

The problem with exec is that very weird things happen during exec.
Tasks change their ids, tracees get silently pruned and so on, so
there might not be a transparent way for a ptracer to deal with it.
It needs to be notified and handle the situation whether it wants or
not.

What I was saying was there won't be SIGTRAP.  In general, we're
trying to move away from kernel implicitly sending actual signals.  If
we enable it by default, it will be a proper ptrace trap.

Thanks.

-- 
tejun
