Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab1CASe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 13:34:58 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47828 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575Ab1CASe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 13:34:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=vnSoLHZ/JC52fskVGfbZQBTY4NvaO228rUPEpaCuTO1XoyQ1rf24HRWGLGNFVP9Te3
         LSd1VvOK7a7hPCa5WKlI9BpOjoXEnyddBBdoKJDzjmyDZKr1TyeQhuyOJPdCTlGUGACu
         ADzJ6T0jeep95tYDIqLXRM3a82Tm24cMpO2lA=
Date: Tue, 1 Mar 2011 19:34:54 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110301183454.GC23527@mtj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <201103011757.48593.vda.linux@googlemail.com>
 <20110301170953.GB17933@htj.dyndns.org>
 <AANLkTi=8=Tw2aYzvwM_s8dsMmw3W_tYjsYkqTHS9moUW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=8=Tw2aYzvwM_s8dsMmw3W_tYjsYkqTHS9moUW@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 06:21:49PM +0100, Denys Vlasenko wrote:
> I'm not saying that I like that other proposal more -
> I am saying that your proposal needs to specify whether strace
> needs to be changed, and how exactly, to correctly handle
> SIGSTOPs under this proposal.

Yeah, definitely.

> > gdb can do whatever it wants to do but I don't think the above needs
> > fixing.  In the first case, the user is explicitly telling gdb to
> > continue the tracee, so it continues as it always has.
> 
> It does not look like that to me.
> 
> User attached to some process. User might be unaware that
> the process is currently stopped (imagine a group of processes
> which use SIGSTOP/SIGCONT in their normal interactions).
> 
> User peeked some state, and then wants to let process
> continue whatever process was doing, but remain in the debugger.
> 
> What user did not know is that "whatever process was doing" =
> "being stopped by SIGSTOP, waiting to be woken up".
> Therefore, if "continue" makes process run, it does not
> return process to whatever process was doing.
>
> > In the latter
> > case, the debugging session is over.  The tracee now should do
> > whatever it's supposed to do.
> 
> It should do that in both cases.

Maybe it should, maybe not, but that's mostly irrelevant because the
described behavior is the current behavior.  There is no
continue-if-not-job-control-stopped operation and we shouldn't change
that beneath gdb because otherwise not only the behavior changes
unexpectedly but also the user doesn't have a way to resume the tracee
from within gdb.  The user has to go to another terminal and send
SIGCONT explicitly.  If gdb wants to improve the behavior, it sure can
implement proper job control behavior using the proposed changes.

Thanks.

-- 
tejun
