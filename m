Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab1DYLhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 07:37:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34718 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758399Ab1DYLhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 07:37:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c5Mb1mUXtC/xnlLOUmg9WyPJsXmXNg6w3xTp4vCq9CX88E0OprgZ1P/nwhuOruKuiv
         OnUiw8y1VfFpLTHi/xp7TwgmK9UYD756GCXTPrtcaCm1yH5t7MLI7INmfFiLmQnYXfpH
         A+tuaOcNmQBU5jj4UQs/aUFXVBTH4uqikidnA=
Date: Mon, 25 Apr 2011 13:37:46 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signal: sys_rt_sigtimedwait: simplify the timeout
 logic
Message-ID: <20110425113746.GM17734@mtj.dyndns.org>
References: <20110418134421.GA15951@redhat.com>
 <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
 <20110418173224.GA27918@redhat.com>
 <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
 <20110423175901.GA484@redhat.com>
 <20110423175922.GB484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110423175922.GB484@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 23, 2011 at 07:59:22PM +0200, Oleg Nesterov wrote:
> No functional changes, cleanup compat_sys_rt_sigtimedwait() and
> sys_rt_sigtimedwait().
> 
> Calculate the timeout before we take ->siglock, this simplifies and
> lessens the code. Use timespec_valid() to check the timespec.
> 
> I don't understand why we are adding (ts.tv_sec || ts.tv_nsec) to
> timespec_to_jiffies(&ts). Perhaps to ensure we will sleep at least
> one jiffy if ts != 0? But in this case we should only check tv_nsec,
> I don't think timespec_to_jiffies() can return zero if tv_sec != 0.
> In fact I suspect timespec_to_jiffies() can only return zero if
> tv_sec == tv_nsec == 0 because we add "TICK_NSEC - 1", but I am not
> sure I understand correctly this math.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

It might be a good idea to note the weird jiffies calculation with a
comment?

Thanks.

-- 
tejun
