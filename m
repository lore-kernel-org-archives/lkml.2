Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab1FCPsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:48:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab1FCPso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:48:44 -0400
Date: Fri, 3 Jun 2011 17:46:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and
	group stop notification, take#4
Message-ID: <20110603154632.GD23757@redhat.com>
References: <1306710760-16440-1-git-send-email-tj@kernel.org> <BANLkTik5hV8dnyspyGz8YAAdtoQNQDyOSw@mail.gmail.com> <20110603012445.GA14872@mtj.dyndns.org> <201106031357.02859.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106031357.02859.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03, Denys Vlasenko wrote:
>
> On Friday 03 June 2011 03:24, Tejun Heo wrote:
> >
> > Anyways, let's think about that, but SIGSTOP on clone is closely
> > linked to why SEIZE is used in the first place and I currently lean
> > toward tying it to SEIZE.
>
> Ok.
>
> SIGSTOP on clone is less problematic because in practice it's
> rather hard to send a real SIGSTOP to a thread which is _just_ created.
> So the race window is mostly theoretical

It is not. The new child can dequeue a signal which was sent to the
process (thread group). How the tracer can distinguish? Also, SIGSTOP
can be sent to pgrp and the new tracee can be forked.

I think that SEIZE should never send SIGSTOP on auto-attach, without
any options.

Oleg.

