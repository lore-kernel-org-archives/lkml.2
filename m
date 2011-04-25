Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642Ab1DYQZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 12:25:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39197 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757590Ab1DYQZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 12:25:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bzgqdkswmGwbB0UgXhBE0DdWx3NTB3YnnMGbJeEGAtqDu4b+o6WYe1E8uT4UEcuDai
         hKjr0AIJOtxLnC6bTxiifknwq+KNfEUYnIMcISZWQqgfzoh+1wyx/D/dKdmyfLfJK8Ic
         2X01AMAIe40TeAzTumXs88EY1le2zyH6pICrY=
Date: Mon, 25 Apr 2011 18:25:04 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] signal: introduce do_sigtimedwait() to factor out
 compat/native code
Message-ID: <20110425162504.GC30828@mtj.dyndns.org>
References: <20110418134421.GA15951@redhat.com>
 <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
 <20110418173224.GA27918@redhat.com>
 <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
 <20110423175901.GA484@redhat.com>
 <20110423175940.GC484@redhat.com>
 <20110425114942.GO17734@mtj.dyndns.org>
 <20110425153316.GB14934@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110425153316.GB14934@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Apr 25, 2011 at 05:33:16PM +0200, Oleg Nesterov wrote:
> On 04/25, Tejun Heo wrote:
> >
> > Just one more thing.
> >
> > On Sat, Apr 23, 2011 at 07:59:40PM +0200, Oleg Nesterov wrote:
> > > +int do_sigtimedwait(sigset_t *these, siginfo_t *info, long timeout)
> >
> > Maybe @these isn't the base name here?  It implies that these are the
                           ^^^^
                     oops, best

> > signals the function is interested in but in reality it is the
> > negation of that.
> 
> Yees, I simply copied the old name. And yes, I tried to invent the
> better name but failed.
> 
> Hmm. I think this patch can do a bit more. We can factor out
> sigdelsetmask(SIGKILL | SIGSTOP) + signotset() as well, I'll resend.
> 
> Still, what should be the name? @set? @mask? @which?

Given that next_signal() and friends already use @mask, probably
@mask?  As long as positive selection and negative masking are clearly
distinguishible...

Thanks.

-- 
tejun
