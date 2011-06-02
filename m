Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab1FBFNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 01:13:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34529 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab1FBFNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 01:13:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZhrukdXhIOdES/F2Prt8hms1mf9NgL1gPTn1UIslMtG77hVFgTD/yb1ErPH42EoOXO
         bufq1gclFEWluOFKSvsHrh2l8kL0qqyP7iRsu3Q0CYtdNAYR3LZirsFy4+gkxGWLJ8MQ
         wb6MzwnaqUGqOo9/ZuAJS2WjAXtqJbxwLhF7Q=
Date: Thu, 2 Jun 2011 14:13:35 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCH 11/17] ptrace: implement PTRACE_SEIZE
Message-ID: <20110602051335.GC17434@mtj.dyndns.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
 <1306710760-16440-12-git-send-email-tj@kernel.org>
 <20110601190117.GB6504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110601190117.GB6504@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, Jun 01, 2011 at 09:01:17PM +0200, Oleg Nesterov wrote:
> On 05/30, Tejun Heo wrote:
> > implements a new ptrace request PTRACE_SEIZE which attaches and traps
> > tracee
> 
> it doesn't trap the tracee ;)

Ah, missed that one.  Will update.

> > * PTRACE_SEIZE, unlike ATTACH, doesn't force tracee to trap.  After
> >   attaching tracee continues to run unless a trap condition occurs.
> 
> OK.
> 
> Just to remind, tracehook_report_clone() shouldn't send SIGSTOP if
> the auto-attached tracee is PT_SEIZED.

Yeap, let's deal with it (and others) later.

> > * If PTRACE_SEIZE'd, group stop uses PTRACE_EVENT_STOP trap which uses
> >   exit_code of (SIGTRAP | PTRACE_EVENT_STOP << 8) instead of the
> >   stopping signal number
> 
> Hmm. May be it would be better to report stopping_signal | PTRACE_EVENT_STOP
> instead... I am not sure yet, but it seems this way we can avoid the
> PTRACE_GETSIGINFO changes. I'll try to explain later, when I finsh the
> reading.

Maybe, unsure.  Currently all the existing PTRACE_EVENT_* codes use
SIGTRAP and requiring GETSIGINFO on TRAP_STOP seems reasonable enough.
So, (stopping signo) | EVENT_STOP on stops, SIGTRAP | EVENT_STOP on
INTERRUPT and SIGCONT | EVENT_STOP (hmm....) on continued?

Thanks.

-- 
tejun
