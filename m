Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab1GUJde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:33:34 -0400
Received: from ozlabs.org ([203.10.76.45]:42107 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab1GUJdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:33:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [may-be-patch?] introduce MODULE_USE_UNEXPORTED()
In-Reply-To: <20110719184536.GA27224@redhat.com>
References: <20110719184536.GA27224@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 21 Jul 2011 17:29:25 +0930
Message-ID: <87zkk812ua.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jul 2011 20:45:36 +0200, Oleg Nesterov <oleg@redhat.com> wrote:
> Hi.
> 
> >From time to time I need to write a module for debugging purposes,
> and it is a bit annoying I can't simply use, say, put_task_struct().
> 
> Can't we do something like the simple patch below? Of course, it
> is very unsafe to use kallsyms_lookup_name() by many reasons. But
> it looks handy for the testing/debugging.
> 
> Yes, I am not saying this feature is terribly useful, so I agree
> in advance with the "go away, we don't need this hack" nack.
> 
> Still, what do you think?
> 
> Oleg.

I hate it, but I've wanted it too...

Can we bury it under a CONFIG_DEBUG_KERNEL option?  I don't want
distributions turning this on.  And add a GPL license check.

Alternative is to have a "void *khacker_lookup_sym(const char *)" which
does this at runtime, but that's less convenient to use than this.

Thanks,
Rusty.
