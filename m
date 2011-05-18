Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab1ERT6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:58:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751723Ab1ERT6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:58:42 -0400
MIME-Version: 1.0
In-Reply-To: <1305682865-27111-1-git-send-email-john.stultz@linaro.org>
References: <1305682865-27111-1-git-send-email-john.stultz@linaro.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 May 2011 12:58:17 -0700
Message-ID: <BANLkTikV5EUfpXF1PG3wXLXhou2crm_u2Q@mail.gmail.com>
Subject: Re: [PATCH 0/4] v6 Improve task->comm locking situation
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Ingo Molnar <mingo@elte.hu>, Michal Nazarewicz <mina86@mina86.com>,
        Andy Whitcroft <apw@canonical.com>, Jiri Slaby <jirislaby@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 6:41 PM, John Stultz <john.stultz@linaro.org> wrote:
>
> While this was brought up at the time, it was not considered
> problematic, as the comm writing was done in such a way that
> only null or incomplete comms could be read. However, recently
> folks have made it clear they want to see this issue resolved.

What folks?

I don't think a new lock (or any lock) is at all appropriate.

There's just no point. Just guarantee that the last byte is always
zero, and you're done.

If you just guarantee that, THERE IS NO RACE. The last byte never
changes. You may get odd half-way strings, but you've trivially
guaranteed that they are C NUL-terminated, with no locking, no memory
ordering, no nothing.

Anybody who asks for any locking is just being a silly git. Tell them
to man the f*ck up.

So I'm not going to apply anything like this for 2.6.39, but I'm also
not going to apply it for 40 or 41 or anything else.

I refuse to accept just stupid unnecessary crap.

                      Linus
