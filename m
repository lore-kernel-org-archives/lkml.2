Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab1BAPHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 10:07:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44928 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab1BAPHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:07:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Lnt5/Tar+XOUVtUA/00Yd3NW/2U3Pixm8zS/7z2GBjcgfWueYMa+4gwGG+yxbOeI72
         Y7l7mJBWGpYR3OllTsnvzNObgoEYZq3bSkyPMlk+hh2hgS9MAhzPwP6IVbhZBJ1sEJPm
         kn08vAlUo5BkNAoXY8YnC5lURZLRbFPUvAIto=
Date: Tue, 1 Feb 2011 16:07:27 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] ptrace: use safer wake up on ptrace_detach()
Message-ID: <20110201150727.GP14211@htj.dyndns.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
 <1296227324-25295-3-git-send-email-tj@kernel.org>
 <20110128184601.CBF7C180996@magilla.sf.frob.com>
 <20110131103855.GD7459@htj.dyndns.org>
 <20110201102618.GE14211@htj.dyndns.org>
 <20110201134037.GA25392@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201134037.GA25392@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 01, 2011 at 02:40:37PM +0100, Oleg Nesterov wrote:
> On 02/01, Tejun Heo wrote:
> >
> > --- work.orig/kernel/ptrace.c
> > +++ work/kernel/ptrace.c
> > @@ -313,7 +313,7 @@ int ptrace_detach(struct task_struct *ch
> >  		child->exit_code = data;
> >  		dead = __ptrace_detach(current, child);
> >  		if (!child->exit_state)
> > -			wake_up_process(child);
> > +			wake_up_state(child, TASK_TRACED | TASK_STOPPED);
> 
> Well, it can't be TASK_TRACED at this point. And of course this still
> contradicts to __set_task_state(child, TASK_STOPPED) in ptrace_untrace().
> IOW, to me the previous patch makes more sense.

Yeah, it can't be in TRACED but the whole point of the patch is
avoiding rude wakeups, so as long as it doesn't end up waking random
[un]interruptible sleeps...  It will be removed later anyway.

> But OK, I understand Roland's concerns. And, at least this change
> fixes the bug mentioned in 95a3540d.
> 
> Acked-by: Oleg Nesterov <oleg@redhat.com>

Oleg, Roland, you guys are the maintainers, so how do you guys want to
route the patches which have been acked?  As it's likely that there
will be quite some number of ptrace patches, it will be better to have
a git tree.

Thank you.

-- 
tejun
