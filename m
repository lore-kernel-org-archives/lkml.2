Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482Ab1DYLOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 07:14:53 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45454 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331Ab1DYLOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 07:14:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ab8P1fa+a4LhgJOuwUGZ17nQqiEW6XkF1UgEJaCXMdEB3zCpJ3zdVrq/O9pTORpJna
         ePtXmiW60oIFkvnq+NLoWER8jVFUE0Kw28gLvN/M13vqzkZpxasLTjK5e5SIZc1tIwZG
         vJ2f3B13xcvVG/jdB5j+zIBr03n/zZK0BgDRQ=
Date: Mon, 25 Apr 2011 13:14:47 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/7] signal: sigprocmask() should do
 retarget_shared_pending()
Message-ID: <20110425111447.GH17734@mtj.dyndns.org>
References: <20110418134421.GA15951@redhat.com>
 <20110418134557.GF15951@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418134557.GF15951@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, again.

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

But, I really think we can use some comments around here.  Things
might look obvious now but it isn't very intuitive piece of code.

> +void set_current_blocked(const sigset_t *newset)
> +{
> +	struct task_struct *tsk = current;
> +
> +	spin_lock_irq(&tsk->sighand->siglock);
> +	if (signal_pending(tsk) && !thread_group_empty(tsk)) {
> +		sigset_t newblocked;
> +		signandsets(&newblocked, newset, &current->blocked);

While you're touching code around here, can you please rename
signandsets() to sigandnsets()?  It ain't nand!!!

Thanks.

-- 
tejun
