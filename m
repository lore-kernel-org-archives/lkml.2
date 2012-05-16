Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab2EPUnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:43:01 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50812 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab2EPUm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:42:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120516202924.GE21275@google.com>
References: <alpine.LNX.2.00.1205160932280.8796@pobox.suse.cz>
 <20120516170124.GA21275@google.com> <alpine.LNX.2.00.1205162133180.8796@pobox.suse.cz>
 <CA+55aFw-us7LnG-iq5EQmSDJ7xH9hiOMmCryAGobReko4LkVWg@mail.gmail.com>
 <20120516195332.GC21275@google.com> <alpine.LNX.2.00.1205162156120.8796@pobox.suse.cz>
 <20120516200147.GD21275@google.com> <alpine.LNX.2.00.1205162216390.8796@pobox.suse.cz>
 <20120516202924.GE21275@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 May 2012 13:42:36 -0700
X-Google-Sender-Auth: SS2AtEtpvUl05vn2U-bfQG1QReU
Message-ID: <CA+55aFyX3OgdcWuYQO+YuS3fF_Wt1p8w-G33C5MCkiR-3ncfVA@mail.gmail.com>
Subject: Re: [PATCH] floppy: convert to delayed work and single-thread wq
To: Tejun Heo <tj@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 1:29 PM, Tejun Heo <tj@kernel.org> wrote:
>
> Ummm... still confused.  flush_work_sync() is fine too.  If you have
> two, two calls to flush_work_sync() are equivalent to flushing the
> workqueue in effect.  You just need to avoid flush_workqueue() because
> system workqueues may be hosting work items which can run arbitrarily
> long.

Umm. If there are abritrarily long things and these are serialized,
then that workqueue is not good for putting floppy work on it either,
is it? I don't think you can have it both ways.

Either it's "good enough" for putting floppy_work, fd_timeout and
fd_timer on, or it's not. If it's good enough, then flush_workqueue()
should damn well be timely enough. And if flush_workqueue() isn't
timely enough, then it doesn't sound like system_nrt_wq is the wrong
choice.

                      Linus
