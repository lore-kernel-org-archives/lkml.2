Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110Ab0G0QQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:16:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750730Ab0G0QQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:16:43 -0400
MIME-Version: 1.0
In-Reply-To: <20100727155023.GF1967@jolsa.brq.redhat.com>
References: <20100727155023.GF1967@jolsa.brq.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 27 Jul 2010 09:16:16 -0700
Message-ID: <AANLkTineVrcffFWGxQ+EzYno6xvcNS9=M7hn_KddASnQ@mail.gmail.com>
Subject: Re: [PATCH] cred - synchronize rcu before releasing cred
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 8:50 AM, Jiri Olsa <jolsa@redhat.com> wrote:
>
> got no objections on linux-security-module and acked by David.
> Noone pick it, so got advice to send this directly to you.

The patch seems fundamentally buggy.

The whole patch seems to be based on "nobody can ever use
get_cred/put_cred, because concurrent use will then trigger the
BUG_ON() in __put_cred()".

But that's a bug in general, not in this particular usage that isn't
all that different from other uses. So rather than just remove the
code that uses the refcounting, we should either:

 - FIX the damn ref-counting so that it works without bugging out

or

 - remove the broken functions entirely.

In other words - why are we working around what looks like a bug,
rather than fixing the bug itself?

In particular, the code you remove seems to be basically _identical_
to get_task_cred(). So if the code you remove is buggy, then so is any
use of get_task_cred() - no?

So please explain why get_task_cred() is ok, but the particular use of
get_cred/put_cred that you removed is not.

Hmm? What am I missing?

                                   Linus
