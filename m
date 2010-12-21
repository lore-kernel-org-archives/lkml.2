Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab0LURdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 12:33:06 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:40399 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab0LURdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 12:33:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sM7kEbLKTyy3JNH8jBNKFWTERYDNI4noMOBM2JGaSugC05p5y8z3onqNLAeCiZd98j
         Jy2ZCRkDD4HLy7tPMLAsrt7PF/hk01wiqbhWrCH33pCQavtmKWqwWNfKsAUs5qNf6PI7
         QqQJraNX3eqB2ldc8RFLMmeJwVfOnbGcPWrHY=
Date: Tue, 21 Dec 2010 18:32:59 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 10/16] ptrace: clean transitions between TASK_STOPPED
 and TRACED
Message-ID: <20101221173258.GF13285@htj.dyndns.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
 <1291654624-6230-11-git-send-email-tj@kernel.org>
 <20101220150037.GE11583@redhat.com>
 <20101221173155.GE13285@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101221173155.GE13285@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 06:31:55PM +0100, Tejun Heo wrote:
> > > @@ -1842,7 +1879,18 @@ static int do_signal_stop(int signr)
> > >
> > >  		spin_lock_irq(&current->sighand->siglock);
> > >  	} else
> > > -		ptrace_stop(current->exit_code, CLD_STOPPED, 0, NULL);
> > > +		ptrace_stop(current->group_stop & GROUP_STOP_SIGMASK,
> > > +			    CLD_STOPPED, 0, NULL);
> > 
> > Perhaps it would be more clean to clear ->exit_code here, in the
> > "else" branch.
> 
> Hmmm... and dropping current->exit_code clearing from the
> do_signal_stop(), right?  I'm a bit confused about the use of
> current->exit_code tho.  Why aren't we clearing it from ptrace_stop()?

Ah, never mind.  It's used as the signr return from ptrace signal
trap.

Thanks.

-- 
tejun
