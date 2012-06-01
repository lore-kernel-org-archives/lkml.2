Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339Ab2FAUBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 16:01:09 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61765 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759240Ab2FAUAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 16:00:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120601190230.GA405@redhat.com>
References: <1338332348-3469-1-git-send-email-filbranden@gmail.com>
	<20120601190230.GA405@redhat.com>
Date: Fri, 1 Jun 2012 16:00:15 -0400
Message-ID: <CABe66sWwvCq=vWq5=ojbgHZeG764BGvts0cMJExTVrTeHRS+KA@mail.gmail.com>
Subject: Re: [PATCH 1/1] prctl: pdeath_signal sent when parent thread (instead
 of parent process) dies
From: Filipe Brandenburger <filbranden@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Fri, Jun 1, 2012 at 3:02 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> Filipe, you can't even imagine how much do I like this change
> personally ;) Although I think that pdeath_signal code should
> be moved into reparent_leader(). I suggested this many times.

Yes, that would really make sense!

> But I was told there are users which depend on current behaviour,
> they really want to know when the parent _thread_ exits.

Hmmm... but is it the parent thread inside the same process or the
thread of the parent process that forked it?

The former would kind of make sense to me, even though I would
probably implement it through another "option" parameter such as
PR_SET_TDEATHSIG or similar... the latter, doesn't really make any
sense to me...

> Why? I have no idea. And I agree this is ugly, but we can't
> break user-space.

At the very least, then, I think the man page for prctl(2) needs to be
updated, since PR_SET_PDEATHSIG and PR_GET_PDEATHSIG both refer
literally to the parent process.

Cheers,
Filipe
