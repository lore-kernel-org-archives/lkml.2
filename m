Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab1DYRI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 13:08:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369Ab1DYRI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 13:08:56 -0400
Date: Mon, 25 Apr 2011 19:07:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] signal: do_sigtimedwait() needs
	retarget_shared_pending()
Message-ID: <20110425170737.GB18363@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com> <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com> <20110423175901.GA484@redhat.com> <20110423180000.GD484@redhat.com> <20110425115253.GP17734@mtj.dyndns.org> <20110425160115.GC14934@redhat.com> <20110425162758.GD30828@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110425162758.GD30828@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Tejun Heo wrote:
>
> On Mon, Apr 25, 2011 at 06:01:15PM +0200, Oleg Nesterov wrote:
> >
> > Again, I can rename... Cough, but in this case please simply suggest
> > another name. set_tsk_blocked_locked?
>
> Oooh, blocked_locked, didn't see that one coming.  Maybe
> set_tsk_sigmask()

but it is not _tsk, it is specially named set_current_blocked() to
show that it only applies to current. And _blocked clearly shows what
it should change, like set_current_state().

OK, this is purely cosmetic, and __set_tsk_blocked() is static and has
a single caller. Can we keep this naming for now? it would be trivial
to rename later.

Oleg.

