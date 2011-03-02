Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1CBHcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 02:32:42 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37409 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab1CBHck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 02:32:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oI6xCHcxRVTtQ4406+Rb01Ggr0yJqi0FUQFf8h4tWIa/gQ2WdSAdxB86yJH5SMX90Q
         zc9KyZe8CVlcUIwuoYpzmgukie5fNQVnTnGuJBJ7huE4pBl/9zV1/0pdRHx0hi6c95ng
         ugHqi4dE4SI6B7ymdFEvyibdQZ27u2YQW7Y68=
Date: Wed, 2 Mar 2011 08:32:36 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110302073236.GC19669@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <AANLkTinpVJAsUW83Wu3GNqTzXk=QEamJ=G3N-nrJjJhO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinpVJAsUW83Wu3GNqTzXk=QEamJ=G3N-nrJjJhO@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, Mar 01, 2011 at 11:59:02PM +0100, Denys Vlasenko wrote:
> Currently strace has to keep precise track on the alternating sequence
> of syscall enter/syscall exit stops. Which gets even trickier
> with extra magic SIGTRAP thrown in by execve and such.

I see.  Yeah, it would be a good idea to make sure each trap condition
can be uniquely identified by siginfo and this should definitely be
documented in the man page.

> There were (and I suspect will be) hard to debug bugs when strace
> was getting out-of sync and printing garbage.
> 
> Defining the PTRACE_GETSIGINFO's si_code so that each of these stops
> can be easily distinguished would be useful. I propose using values
> of SI_KERNEL + 1, SI_KERNEL + 2 etc, suitably #defined of course.
> 
> 
> We also have magic SIGSTOPs (magic in a sense they aren't
> real signals sent by other processes):
> * at PTRACE_ATTACH
> * in child (if PTRACE_O_TRACE[V]FORK or PTRACE_O_TRACECLONE opt is on)
> 
> For example, flagging PTRACE_ATTACH SIGSTOP so that it can be
> uniquely identified would solve some problems gdb is having with it.

This, I don't agree with.  All we need is a better attach call without
the implied SIGSTOP, there's no reason to diddle with PTRACE_ATTACH
further.

Thanks.

-- 
tejun
