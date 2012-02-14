Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab2BNR7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 12:59:48 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:47316 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755272Ab2BNR7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 12:59:47 -0500
Subject: Re: [PATCH 20/40] mn10300: Use set_current_blocked() and
 block_sigmask()
From: Matt Fleming <matt@console-pimps.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-am33-list@redhat.com
In-Reply-To: <17603.1329234976@redhat.com>
References: <1329219673-28711-21-git-send-email-matt@console-pimps.org>
	 <1329219673-28711-1-git-send-email-matt@console-pimps.org>
	 <17603.1329234976@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Feb 2012 17:59:38 +0000
Message-ID: <1329242378.3675.71.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 15:56 +0000, David Howells wrote:
> Matt Fleming <matt@console-pimps.org> wrote:
> 
> >  asmlinkage long sys_sigsuspend(int history0, int history1, old_sigset_t mask)
> >  {
> > -	mask &= _BLOCKABLE;
> > -	spin_lock_irq(&current->sighand->siglock);
> > +	sigset_t blocked;
> > +
> >  	current->saved_sigmask = current->blocked;
> 
> Can this line create a race, now that it's not protected by a lock?  It is
> possible for current->blocked to get altered by another thread.

->blocked can only ever be altered by current, not another thread. See
the following comment from sigprocmask() in kernel/signal.c,

       /* Lockless, only current can change ->blocked, never from irq */
        if (oldset)                                                                                      
                *oldset = tsk->blocked;                                                                  

-- 
Matt Fleming, Intel Open Source Technology Center

