Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab1DRRRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 13:17:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754667Ab1DRRRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 13:17:33 -0400
MIME-Version: 1.0
In-Reply-To: <20110418134421.GA15951@redhat.com>
References: <20110418134421.GA15951@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 Apr 2011 10:16:43 -0700
Message-ID: <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/7] signal: sigprocmask fixes
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 6:44 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Once again: if we need this, then we need a lot more (trivial) changes
> like 6/7 and 7/7. Basically every change of ->blocked should be converted
> to use set_current_blocked(). OTOH, perhaps this makes sense by itself.

Hmm. The more I think about this, the less I like it.

What if the pending thread signal was thread-specific to begin with?

For example, if we have a SIGFPE and a SIGKILL that happen at the same
time, a dying task may have a SIGFPE pending when it dies, and that
SIGFPE should _not_ be just distributed out to the other threads in
the thread group.

Am I missing something that protects against this?

                  Linus
