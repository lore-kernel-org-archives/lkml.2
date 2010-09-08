Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab0IHPFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:05:38 -0400
Received: from www.tglx.de ([62.245.132.106]:33055 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419Ab0IHPFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:05:36 -0400
Date: Wed, 8 Sep 2010 17:05:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [GIT pull] Preparatory patch for semaphore cleanup
In-Reply-To: <AANLkTikYEjV8ikkPsfJ0d7WsikWHJ0n74u9uDS4uGHC+@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1009081657550.2477@localhost6.localdomain6>
References: <alpine.LFD.2.00.1009081507250.2477@localhost6.localdomain6> <AANLkTikYEjV8ikkPsfJ0d7WsikWHJ0n74u9uDS4uGHC+@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Sep 2010, Linus Torvalds wrote:

> On Wed, Sep 8, 2010 at 6:11 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > This patch just provides the DEFINE_SEMAPHORE macro which is required
> > for the various subsystem cleanups I sent out, so we can finally get
> > rid of init_MUTEX[_LOCKED] in 2.6.37.
> 
> Why is it called DEFINE_SEMAPHORE(), when two lines later the we have
> DECLARE_MUTEX()?

DECLARE_MUTEX is what we want to get rid of. 

It's a misnomer as the semaphores are not longer used as mutexes and
the instantiation of a variable is not the declaration.
 
> IOW, the whole DEFINE vs DECLARE thing seems confused. I'm not saying
> one is better than the other (maybe "define" is), but the mixing of
> names is worse than either, I feel..

That's a temporary situaton until all users are gone, which will be in
the 37 merge window.

Thanks,

	tglx
