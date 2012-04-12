Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab2DLEjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 00:39:52 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48702 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab2DLEju convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 00:39:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120412042850.GA22354@redhat.com>
References: <20120412024751.GA17561@redhat.com> <20120412024810.GA17984@redhat.com>
 <20120412040059.GA20462@redhat.com> <CA+55aFyGsA5YPqrymJ8wwoS86SEeJh+X-dvfBTfo3gOTm73JNA@mail.gmail.com>
 <20120412042850.GA22354@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Apr 2012 21:39:29 -0700
X-Google-Sender-Auth: XYEgbwVW9vmuBQ5y6CvKB80hZl0
Message-ID: <CA+55aFzs=DuYibWYMUFiU_R1aJHAr-8hpQhWLew8R5q4nCDraQ@mail.gmail.com>
Subject: Re: hlist_for_each_entry && pos (Was: task_work_queue)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 9:28 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Agreed. But,
>
>        error: 'for' loop initial declaration used outside C99 mode
>
> we should change CFLAGS, I guess. BTW, personally I'd like very much
> to use "for (type var; ...")" if this was allowed.

The sad part is that if we allow that, we also get that *other* insane
C99 variable thing - mixing variables and code.

I *like* getting warnings for confused people who start introducing
variables in the middle of blocks of code. That's not well-contained
like the loop variable.

That said, most of the stuff in C99 are extensions that we used long
before C99, so I guess we might as well just add the stupid flag. And
discourage people from mixing declarations and code other ways (sparse
etc).

                         Linus
