Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab1BYPvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:51:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33340 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab1BYPvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:51:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZiCmcVPIopiAA1tJ1JLqCI65MkSZfoDEZJs9cKNbPY5ay87ic6YtREfWWNZgPpHjj6
         /KhkWqfEWO+fAkyCca76JeVUb440sYrSc8cZ7mOjgvD43YtImpD8UVI84Suq4G1Ro3Uu
         fv8bw+SDNOZ79ew3XMxyuIAD+PHa8o2vRxsG8=
Date: Fri, 25 Feb 2011 16:51:42 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110225155142.GQ24828@htj.dyndns.org>
References: <20110214190141.GA19221@redhat.com>
 <AANLkTi=_af8+XKD+d-677JpQZA=AN2EsydscSYxk7z55@mail.gmail.com>
 <20110214200130.GA21559@redhat.com>
 <20110215152448.GL3160@htj.dyndns.org>
 <20110215173149.239601807B7@magilla.sf.frob.com>
 <20110215202747.GA20560@redhat.com>
 <20110218170212.GS21209@htj.dyndns.org>
 <20110218193709.GA9700@redhat.com>
 <20110221162206.GN31267@htj.dyndns.org>
 <20110224202941.GA12258@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224202941.GA12258@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 24, 2011 at 09:29:41PM +0100, Oleg Nesterov wrote:
> Damn. Today is 02/24 ;) sorry.

No need.  I've been pretty lazy with this thread too.  :-)

> > On Fri, Feb 18, 2011 at 08:37:09PM +0100, Oleg Nesterov wrote:
> >
> > > > As it currently stands, SIGSTOP/CONT while ptraced doesn't work
> > >
> > > And this is probably where we disagree the most. I think this is bug,
> > > and this should be fixed.
> >
> > I don't think we disagree that it is a bug.  I want to fix it too but
> > we definitely seem to disagree on how.
> 
> Yes, but I also think that the running tracee in the SIGNAL_STOP_STOPPED
> process is bug by itself. IIUC, you think this is fine.

Yeap, I actually think that's the better way.

> > * ptrace, sans the odd SIGSTOP on attach which we should remove, is
> >   per-task.  Sending out SIGCONT on PTRACE_CONT would break that.  I
> >   really don't think that's a good idea.
> 
> Hmm. But why do you think we should always send SIGCONT after attach?

Hmmm... my sentences were confusing.  I was trying to say,

* ptrace, as it currently stands, is largely per-task.  One exception
  is the implicit SIGSTOP which is sent on PTRACE_ATTACH but this
  should be replaced with a more transparent attach request which
  doesn't affect jctl states.

* Sending out SIGCONT on PTRACE_CONT on jctl stopped tracee adds
  another exception to per-task behavior, which I don't think is a
  good idea.

> > * PTRACE_CONT would be behaving completely differently depending on
> >   whether it's resuming from group stop or other traps.
> 
> Afaics, no. It does not matter from where the tracee resumes. See
> the [pseudo patch] I sent. Once again, it doesn't really work, it
> only tries to explain what I mean.

I see.  I'll read the patch again.

Thanks.

-- 
tejun
