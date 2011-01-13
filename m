Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab1AML2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 06:28:01 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38314 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab1AML2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 06:28:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PFQB1mAVpQpHl9he9hhnW6d7TUVwIoj7VkpJF8q8Sp8LHcYi9qEJiurzOlRiG7ouL6
         aMgoehfgIxBJvMYmU/HOn+gEU1WmLMNdZR7ts2GoEgCfDwmd10R77WNVoJFzl7pXRvuc
         rtlzw561AXfZCDnzCCLb6V8xJNiWHag7/oma8=
Date: Thu, 13 Jan 2011 12:27:47 +0100
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        rjw@sisk.pl
Subject: Re: [PATCH 1/4] signal: fix SIGCONT notification code
Message-ID: <20110113112747.GE30719@htj.dyndns.org>
References: <1293016398-18001-1-git-send-email-tj@kernel.org>
 <1293016398-18001-2-git-send-email-tj@kernel.org>
 <20110112204136.GB13830@host1.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110112204136.GB13830@host1.dyn.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.

On Wed, Jan 12, 2011 at 09:41:36PM +0100, Jan Kratochvil wrote:
> On Wed, 22 Dec 2010 12:13:15 +0100, Tejun Heo wrote:
> > If SIGCONT is received while the child process is stopped, the code should
> > be CLD_CONTINUED.  If SIGCONT is recieved while the child process is in the
> > process of being stopped, it should be CLD_STOPPED.
> 
> If a process does
> 	kill (PID, SIGSTOP);
> 	<varying delay, possibly even from a different process>
> 	kill (PID, SIGCONT);
> 
> does it mean the PID's parent may get different waitid() results?
> Or even that PID will finally remain still `T (stopped)'?

Yeah, the @why part could be different with the fix.  Before the fix
the result was indeterministic.

> I do not see it has any userland impact, the
> PTRACE_ATTACH-to-T(stopped)-process is already racy for different reasons.

I agree that it wouldn't have any userland impact especially given
that the previous behavior was rather indeterministic.  It just fixes
an obvious bug which tested the wrong flag.

Thanks.

-- 
tejun
