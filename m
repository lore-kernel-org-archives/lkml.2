Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496Ab2DLRmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 13:42:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933058Ab2DLRmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 13:42:04 -0400
Date: Thu, 12 Apr 2012 19:41:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, geert@linux-m68k.org, chris@zankel.net
Subject: Re: TIF_NOTIFY_RESUME [was Re: [PATCH v2 1/2] task_work_queue: add
	generic process-context callbacks]
Message-ID: <20120412174107.GB24541@redhat.com>
References: <20120412024810.GA17984@redhat.com> <20120412024751.GA17561@redhat.com> <9335.1334223342@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9335.1334223342@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > +#ifdef TIF_NOTIFY_RESUME
>
> If we're going to keep this feature, I wonder if it's worth just requiring the
> arches lacking this feature to add it at this point, rather than adding all
> this conditional logic.

Yes, agreed. But until we update m68k/xtensa task_work has to check
if it is defined.

I'll try to cleanup this in v3. In fact, task_work_queue() makes sense
even without TIF_NOTIFY_RESUME, just it lacks set_notify_resume().

> It doesn't look like it should be too hard for m68k, but xtensa looks tricky.

I was going to add the maintainers ;)

Oleg.

