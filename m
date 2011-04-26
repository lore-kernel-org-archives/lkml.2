Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1DZKkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:40:36 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:58743 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754177Ab1DZKkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:40:31 -0400
Date: Tue, 26 Apr 2011 11:40:28 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] signal: do_sigtimedwait() needs
 retarget_shared_pending()
Message-ID: <20110426114028.74c5a8a1@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110425170737.GB18363@redhat.com>
References: <20110418134421.GA15951@redhat.com>
	<BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
	<20110418173224.GA27918@redhat.com>
	<BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
	<20110423175901.GA484@redhat.com>
	<20110423180000.GD484@redhat.com>
	<20110425115253.GP17734@mtj.dyndns.org>
	<20110425160115.GC14934@redhat.com>
	<20110425162758.GD30828@mtj.dyndns.org>
	<20110425170737.GB18363@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011 19:07:38 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 04/25, Tejun Heo wrote:
> >
> > On Mon, Apr 25, 2011 at 06:01:15PM +0200, Oleg Nesterov wrote:
> > >
> > > Again, I can rename... Cough, but in this case please simply suggest
> > > another name. set_tsk_blocked_locked?
> >
> > Oooh, blocked_locked, didn't see that one coming.  Maybe
> > set_tsk_sigmask()
> 
> but it is not _tsk, it is specially named set_current_blocked() to
> show that it only applies to current. And _blocked clearly shows what
> it should change, like set_current_state().
> 
> OK, this is purely cosmetic, and __set_tsk_blocked() is static and has
> a single caller. Can we keep this naming for now? it would be trivial
> to rename later.

It might be worth adding a comment to __set_tsk_blocked() saying that
it expects to be called with ->siglock held.

-- 
Matt Fleming, Intel Open Source Technology Center
