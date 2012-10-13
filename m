Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab2JMBtD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 21:49:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37383 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab2JMBtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 21:49:01 -0400
Date: Sat, 13 Oct 2012 02:48:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, dl8bcu@dl8bcu.de, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org
Subject: Re: [PATCH 1/1] task_work: Add local_irq_enable() into
 task_work_run()
Message-ID: <20121013014852.GN2616@ZenIV.linux.org.uk>
References: <20121006204736.GA1830@ds20.borg.net>
 <20121012160337.GA30881@redhat.com>
 <20121012160359.GB30881@redhat.com>
 <CA+55aFwXiu1znTkksgSyxa7v1-3cPWZL5dvth_8hQygSKE1utw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwXiu1znTkksgSyxa7v1-3cPWZL5dvth_8hQygSKE1utw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2012 at 10:09:36AM +0900, Linus Torvalds wrote:
> On Sat, Oct 13, 2012 at 1:03 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > arch/alpha and probably some other architectures call
> > do_notify_resume()->task_work_run() with irqs disabled.
> 
> I'm going to ignore this patch because I *hope* it is unnecessary
> after the pull from Al that I just did.
> 
> But if that turns out to be not the case, please holler. Torsten, you
> seem to be the one who reported this, can you check the current git
> tree?

For alpha it shouldn't be needed, but it's a good idea in general -
it detects bugs of that kind we might very well have on some other
architectures, warns about them and attempts to minimize the damage.
I think x86, arm, sparc, ppc, s390, x86, mips and m68k are OK, judging
by the local testing I've done (alpha did trigger that mess during the
same testing, until I'd added those patches).  As for everything else...
no idea at the moment.  Unfortunately, TFS to read through for that
includes an unhealthy amount of asm glue on all sorts of strange
architectures ;-/
