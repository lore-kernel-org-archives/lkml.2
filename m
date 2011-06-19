Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab1FSPvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 11:51:17 -0400
Received: from mail.southpole.se ([193.12.106.18]:45508 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab1FSPvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 11:51:16 -0400
Subject: Re: [PATCH 10/19] OpenRISC: System calls
From: Jonas Bonn <jonas@southpole.se>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTiniGVKrCJXcjBGdmQdqsbfOZ_-agw@mail.gmail.com>
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
	 <1308483825-6023-11-git-send-email-jonas@southpole.se>
	 <BANLkTiniGVKrCJXcjBGdmQdqsbfOZ_-agw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: South Pole Consulting AB
Date: Sun, 19 Jun 2011 17:51:12 +0200
Message-ID: <1308498672.3017.240.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2011-06-19 at 17:09 +0200, richard -rw- weinberger wrote:
> On Sun, Jun 19, 2011 at 1:43 PM, Jonas Bonn <jonas@southpole.se> wrote:
> > +asmlinkage int _sys_vfork(struct pt_regs *regs)
> > +{
> > +       /* This doesn't seem to work */
> > +//        return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->sp, regs, 0, NULL, NULL);
> 
> Just being curious, why does that not work?

Something about the CLONE_VM flag is breaking things... not sure what,
at this point.  I'm not sure how concerned to be about this... this
syscall is deprecated, so the code isn't really used anyway -- then
again, the fact that it causes userspace code to crash may be an
indication of an issue elsewhere.

> 
> > +       /* This works */
> > +        return do_fork(SIGCHLD, regs->sp, regs, 0, NULL, NULL);
> 
> This looks very odd.

vfork is replaced by fork (in libc) when the syscall doesn't exist so it
seemed reasonable to make vfork look like fork even when the syscall's
there.  It's worked for us up until now...

/Jonas

