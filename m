Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599Ab1ESQ65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:58:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54387 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933494Ab1ESQ64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:58:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ovMKXVbMQxHypfovIFWFAzb7HUbOSN6Kp2GJeLlQcCYATL0r668zer4D5ONyrJBP1p
         X5A/0s7yTHp8h54VNlQFyGKY3lmzzNYP5b5mfmjEw6Exgv46yCn56h7nAPIDd7z0oN5f
         TviYnUcF5Jm60N8dQj/QiG5wutf9F4OvaqUW8=
Date: Thu, 19 May 2011 18:58:51 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 09/10] ptrace: add JOBCTL_BLOCK_NOTIFY
Message-ID: <20110519165851.GQ627@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-10-git-send-email-tj@kernel.org>
 <20110519163233.GE17265@redhat.com>
 <20110519164402.GO627@htj.dyndns.org>
 <20110519164833.GA19053@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519164833.GA19053@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 06:48:33PM +0200, Oleg Nesterov wrote:
> On 05/19, Tejun Heo wrote:
> >
> > Hello,
> >
> > On Thu, May 19, 2011 at 06:32:33PM +0200, Oleg Nesterov wrote:
> > > > +	/*
> > > > +	 * Make sure @chlid is still ptraced by us and clear BLOCK_NOTIFY.
> > > > +	 */
> > > > +	if (likely((child->ptrace & PT_PTRACED) && child->parent == current))
> > >
> > > This looks a bit confusing... It is either traced or not. If it is traced,
> > > nobody else can trace it. In fact even PT_PTRACED is not strictly needed
> > > but I agree this check makes the code cleaner.
> >
> > Hmmm... I suppose we can make the error paths finer grained so that
> > attach failure
> 
> Ah, you are right again, I forgot about PTRACE_ATTACH path.

We can move the PT_PTRACED and parenthood test outside the siglock tho
and I agree that the 'still ptraced' comment is misleading.  I'll
update it.

Thanks.

-- 
tejun
