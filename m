Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab0LVKgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 05:36:36 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:41631 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab0LVKgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 05:36:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Gnw9ZiszgjvVrd0tePRe3Du9bHsYWzD1STB2GFlhQeJFl5UA442UkbsCtEEaPBYA8b
         RgY/QbYvvPDpph3w+jeXro/c+SzKRRbTmqvmVrB7tIuHcAx+VadJsYqtrcJHfWMGVO1K
         P3hZsGTa2z0Tenh2NWSSZr3WjtijW4MJFdVh8=
Date: Wed, 22 Dec 2010 11:36:30 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 16/16] ptrace: remove the extra wake_up_process() from
 ptrace_detach()
Message-ID: <20101222103630.GD4684@htj.dyndns.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
 <1291654624-6230-17-git-send-email-tj@kernel.org>
 <20101221175439.GA19434@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101221175439.GA19434@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 06:54:39PM +0100, Oleg Nesterov wrote:
> On 12/06, Tejun Heo wrote:
> >
> > --- a/kernel/ptrace.c
> > +++ b/kernel/ptrace.c
> > @@ -391,8 +391,6 @@ int ptrace_detach(struct task_struct *child, unsigned int data)
> >  	if (child->ptrace) {
> >  		child->exit_code = data;
> >  		dead = __ptrace_detach(current, child);
> > -		if (!child->exit_state)
> > -			wake_up_process(child);
> 
> I can only repeat that I obviously like this change ;)
> 
> Now that Jan and Roland do not object, perhaps it can be sent as 2/X.
> This is bugfix, after all (like the first patch).

I'll send out the acked ones as a separate patchset so that they can
be merged.

Thanks.

-- 
tejun
