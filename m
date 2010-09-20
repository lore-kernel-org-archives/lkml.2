Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab0ITSUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:20:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753720Ab0ITSUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:20:43 -0400
MIME-Version: 1.0
In-Reply-To: <1285005814.2275.790.camel@laptop>
References: <20100920151334.569154707@chello.nl> <AANLkTinjVNddRYDUBnVZ67QDEPGrpj4dmW5BMwq2+ozP@mail.gmail.com>
 <1284998339.2275.738.camel@laptop> <AANLkTikcnY7B-+2XYXronUexhgx=gQJfVtLi=RKjP1fs@mail.gmail.com>
 <1285005814.2275.790.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Sep 2010 11:19:55 -0700
Message-ID: <AANLkTimXpwFFOAk9ozZu=0srvL+cTEYkbD9qJjZudk5a@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/2] PF_flags cleaups
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 11:03 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> fs/proc/array.c:do_task_stat()

Ok, I doubt anybody cares. I think that thing is entirely historical,
and we probably should never have done it in the first place. I wonder
if we should just replace that field with a zero.

We've moved flag bits around in task->flags (and moved them to
thread->flags) before, so that /proc/<pid>/stat field has not been
stable historically either. I can't imagine what could break - it
would have broken many times before too.

                      Linus
