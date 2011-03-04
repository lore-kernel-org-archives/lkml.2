Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264Ab1CDIqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 03:46:35 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34400 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1CDIqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 03:46:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pZimROn9bXzdJBW8fZ0iuWFzdFpY+bJN2PjytPnB3aFP53uR7VF5u2DMHTfzbs6cb8
         qAYr7YgmhSL6tlFznXtT4ynXm9p6V3sxrH1JmDDflRVSyXhVNBkr2A6e+0S7HXCdue3i
         tNvh+wSdIc21ny0EbVuGC0QDonMADCQLniusw=
Date: Fri, 4 Mar 2011 09:44:41 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110304084441.GB20499@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <20110303173422.GA27960@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303173422.GA27960@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On Thu, Mar 03, 2011 at 06:34:22PM +0100, Oleg Nesterov wrote:
> > P4. PTRACE_SEIZE
> 
> This is the new request. You know, I'd like to discuss the details
> later and separately. Actually, I think the user-space developers
> should participate and tell what they need. As for me, I certainly
> agree that SIGSTOP from PTRACE_ATTACH is very wrong, and it is very
> bad that gdb has to send SIGSTOP if it wants to stop the tracee.
> IOW, I agree that something like this is needed and useful. In
> particular,

While discussing is good, I'd like to keep things slightly more
driven.  I think, as anything else, there's a balance to hit between
discussing and just pushing things forward.  We did fair amount of
discussion past two+ months and well I think it's about time to push
forward.

By now gdb/strace ppl should be aware of what's going on, right?  So,
if you guys have something on mind w.r.t. kernel behavior, please
share, but I won't wait for some discussion elsewhere to reach a
conclusion especially because the issues which seem to cause the most
amount of delay are not really about what's necessary to achieve the
desired functionalities but wildly different wet wild dreams about
sexy unicorns.

> > A better way to solve this is simply giving the tracer the capability
> > to listen for the end of jctl stop.
> 
> Hmm. I don't understand what "the end of jctl stop" actually means.
> 
> Since you are talking about WCONTINUED below, I guess it means that
> the process is not group-stopped any longer, say, SIGCONT comes.

Yeap, I meant emssion of SIGCONT ending the job control stop in
effect.

> > What state the tracee is in can be determined by retriving siginfo
> > using PTRACE_GETSIGINFO.
> 
> I don't understand this this details right now... But I guess this
> doesn't matter right now.
> 
> Either way, debugger should have the ability to know the tracee's
> state wrt group-stop. To oversimplify, it should know the state of
> SIGNAL_STOP_STOPPED bit. Correct?

Yes, that information should be available via PTRACE_GETSIGINFO.

Thanks.

-- 
tejun
