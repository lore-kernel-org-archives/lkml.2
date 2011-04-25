Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758441Ab1DYQY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 12:24:27 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39040 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab1DYQY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 12:24:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZTd4BAo/UBud9CuJWBYItrTxF4wYJ+dxGmwCjBkMBxY+K7L19sOyXbR+Yaqq6gCtLz
         KzDzJM546LAKhk8qyciqc6HHkDNYnpqNQzwW7AyPoUslAejm/M93ax3tgdEMBoSkA4ms
         ZLcXyh/x5Q0W0X0GwegPVdjkmvwNTdjVscFGM=
Date: Mon, 25 Apr 2011 18:17:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "v2 . 6 . 33 . ." <stable@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 0/5] hw_breakpoints: Fix racy ptrace breakpoint
 acccesses
Message-ID: <20110425161716.GA5055@nowhere>
References: <1302284067-7860-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302284067-7860-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 07:34:22PM +0200, Frederic Weisbecker wrote:
> I should have fixed that a few month ago but got sidetracked.
> Please have a look at this. x86 and powerpc already had support
> for breakpoints before so it fixes a regression there (cf stable tag)
> For the others it only a fix.
> 
> Other archs than x86 have been only compile tested.
> 
> Thanks.
> 
> Frederic Weisbecker (5):
>   ptrace: Prepare to fix racy accesses on task breakpoints
>   x86, hw_breakpoints: Fix racy access to ptrace breakpoints
>   powerpc, hw_breakpoints: Fix racy access to ptrace breakpoints
>   arm, hw_breakpoints: Fix racy access to ptrace breakpoints
>   sh, hw_breakpoints: Fix racy access to ptrace breakpoints

Thanks a lot guys for your acks. I'm reposting with these
and pushing for Ingo.

> 
>  arch/arm/kernel/ptrace.c     |    8 ++++++++
>  arch/powerpc/kernel/ptrace.c |    3 +++
>  arch/sh/kernel/ptrace_32.c   |    4 ++++
>  arch/x86/kernel/ptrace.c     |   36 ++++++++++++++++++++++++++----------
>  include/linux/ptrace.h       |   13 ++++++++++++-
>  include/linux/sched.h        |    3 +++
>  kernel/exit.c                |    2 +-
>  kernel/ptrace.c              |   17 +++++++++++++++++
>  8 files changed, 74 insertions(+), 12 deletions(-)
> 
> -- 
> 1.7.3.2
> 
