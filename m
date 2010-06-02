Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab0FBPCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 11:02:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:40315 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560Ab0FBPCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 11:02:37 -0400
Date: Wed, 2 Jun 2010 17:02:35 +0200
From: Michal Hocko <mhocko@suse.cz>
To: S?bastien Paumier <sebastien.paumier@univ-mlv.fr>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: getpid() returning same value as getppid()
Message-ID: <20100602150235.GD12784@tiehlicka.suse.cz>
References: <4BFD33F0.1060908@univ-mlv.fr>
 <20100526151651.GA21197@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526151651.GA21197@elliptictech.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 26-05-10 11:16:51, Nick Bowler wrote:
> On 16:45 Wed 26 May     , S?bastien Paumier wrote:
> > Hi,
> > here is a bug that occurs on my kernel 2.6.31-21, maybe with older ones. 
> >   If a C program contains a function with the constructor attribute that 
> > calls getpid(), then, a call to syscall(SYS_fork) produces a son that 
> > obtains the same value calling getpid() or getppid().
> 
> The GNU C library caches the results of getpid, which is probably the
> cause of your grief.  This cache relies on the glibc wrappers for fork
> and friends, which you have bypassed by using syscall directly.

man page for getpid states that explicitly:
NOTES
       Since  glibc  version  2.3.4, the glibc wrapper function for
       getpid() caches PIDs, so as to avoid additional system calls when
       a process calls getpid() repeatedly.  Normally this caching is
       invisible, but its correct operation relies on support in the
       wrapper  functions for  fork(2), vfork(2),  and  clone(2):
       if an application bypasses the glibc wrappers for these system
       calls by using syscall(2), then a call to getpid() in the child
       will return the wrong value (to be precise: it will return the
       PID of the parent process).  See also clone(2) for  discussion
       of  a case where getpid() may return the wrong value even when
       invoking clone(2) via the glibc wrapper function.

> 
> -- 
> Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
