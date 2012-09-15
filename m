Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2IORJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 13:09:37 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52482 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab2IORJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 13:09:01 -0400
MIME-Version: 1.0
In-Reply-To: <1347727001.7029.37.camel@marge.simpson.net>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	<20120914212717.GA29307@liondog.tnic>
	<CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
	<1347680006.4340.142.camel@marge.simpson.net>
	<m24nmzz2f8.fsf@firstfloor.org>
	<1347727001.7029.37.camel@marge.simpson.net>
Date: Sat, 15 Sep 2012 19:08:59 +0200
Message-ID: <CAFLxGvy_yu3L5HrsuF9A=4HpbB-5twjkaswUbb0PUhK9NjKtvA@mail.gmail.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2012 at 6:36 PM, Mike Galbraith <efault@gmx.de> wrote:
>> Just using futex is unfortunately not the answer either.
>
> Yes, postgress performs loads better with it's spinlocks, but due to
> that, it necessarily _hates_ preemption.  How the is the scheduler
> supposed to know that any specific userland task _really_ shouldn't be
> preempted at any specific time, else bad things follow?

Why perform custom userspace spinlocks better than futex() based ones?
I thought we have futex() to get rid of the custom ones...
Makes futex() only sense when things like priority inheritance are needed?

-- 
Thanks,
//richard
