Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab1DYQ2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 12:28:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40737 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab1DYQ2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 12:28:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xKFs5tBxZxATl70wermRVn5/7q/WnU+moOmuQjmfQ6ToLiDJpzfTW0qUgLjf6JiIJt
         Ohq0QhZ7SfwZgBIsCR5WwbODyq8tdGl8OMi6fPoQ1TwO8CWdirCYTCZMI2wTQ9XmyU34
         2bo85bQg6wBP40UlnIDaVENX/wDKknsLbYF0A=
Date: Mon, 25 Apr 2011 18:27:58 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] signal: do_sigtimedwait() needs
 retarget_shared_pending()
Message-ID: <20110425162758.GD30828@mtj.dyndns.org>
References: <20110418134421.GA15951@redhat.com>
 <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
 <20110418173224.GA27918@redhat.com>
 <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
 <20110423175901.GA484@redhat.com>
 <20110423180000.GD484@redhat.com>
 <20110425115253.GP17734@mtj.dyndns.org>
 <20110425160115.GC14934@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110425160115.GC14934@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Apr 25, 2011 at 06:01:15PM +0200, Oleg Nesterov wrote:
> > Maybe it would be a good idea to introduce a new helper which checks /
> > enforces that the operation indeed is only unblocking?
> 
> I hope nobody will change ->blocked directly, except this function
> and force_sig_info(). And daemonize/allow_signal/disallow_signal, but
> there are special and probably we can already kill this deprecated
> block/unblock code and forbid kernel_thread(CLONE_SIGHAND) + daemonize().
> In fact I think daemonize() should go away.
> 
> So, I don't really think we need another helper to unblock something.

Oh I see.  I thought there would be quite a number of places
unblocking directly.  If that's not the case, it's fine with me.

> > Also, it can
> > be a pure preference but I think _locked suffix is better / more
> > common for APIs which expect the caller to be responsible for locking.
> 
> Again, I can rename... Cough, but in this case please simply suggest
> another name. set_tsk_blocked_locked?

Oooh, blocked_locked, didn't see that one coming.  Maybe
set_tsk_sigmask() and set_tsk_sigmask_locked()?  I prefer sigmask to
blocked anyway, so...

Thanks.

-- 
tejun
