Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab0LVKym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 05:54:42 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:48292 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab0LVKyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 05:54:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y0tEwtEWggdfdsAokb9QIZRrCvM1fq9XrDkiISfdPHy5XbPZ1VtE3OjsrK08RLx/tx
         2rk6Ezwy1x6QagGQzQ9zxOTT2BsuqW8tMOs5O7fLp7QOWI8X+KR4lnEft6luImP6e7iZ
         J7VaRrjySG86RzshubGpWFzmSi2/Hv6zmEvj8=
Date: Wed, 22 Dec 2010 11:54:36 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 10/16] ptrace: clean transitions between TASK_STOPPED
 and TRACED
Message-ID: <20101222105436.GE4684@htj.dyndns.org>
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

Hello,

On Tue, Dec 21, 2010 at 06:31:55PM +0100, Tejun Heo wrote:
> > This looks racy. Suppose that "current" is ptraced, in this case
> > it can initiate the new group-stop even if SIGNAL_STOP_STOPPED
> > is set and we have another TASK_STOPPED thead T.
> > 
> > Suppose that another (or same) debugger ataches to this thread T,
> > wakes it up and sets GROUP_STOP_TRAPPING.
> > 
> > T resumes, calls ptrace_stop() in TASK_STOPPED, and temporary drops
> > ->siglock.
> > 
> > Now, this task_clear_group_stop(T) confuses ptrace_check_attach(T).
> > 
> > I think ptrace_stop() should be called in TASK_RUNNING state.
> > This also makes sense because we may call arch_ptrace_stop().
> 
> I'm feeling a bit too dense to process the above right now.  I'll
> respond to the above next morning after a strong cup of coffee. :-)

Ah, right, the lock drop across arch_ptrace_stop().  Yeah, I agree
calling ptrace_stop() with TASK_RUNNING would solve it.  I'll think
about it a bit more.

Thank you.

-- 
tejun
