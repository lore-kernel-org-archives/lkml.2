Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab2EPT5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:57:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760588Ab2EPT5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:57:31 -0400
Date: Wed, 16 May 2012 21:57:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] floppy: convert to delayed work and single-thread wq
In-Reply-To: <20120516195332.GC21275@google.com>
Message-ID: <alpine.LNX.2.00.1205162156120.8796@pobox.suse.cz>
References: <alpine.LNX.2.00.1205160932280.8796@pobox.suse.cz> <20120516170124.GA21275@google.com> <alpine.LNX.2.00.1205162133180.8796@pobox.suse.cz> <CA+55aFw-us7LnG-iq5EQmSDJ7xH9hiOMmCryAGobReko4LkVWg@mail.gmail.com> <20120516195332.GC21275@google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012, Tejun Heo wrote:

> > On Wed, May 16, 2012 at 12:37 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> > > +       cancel_delayed_work_sync(&fd_timeout);
> > > +       cancel_delayed_work_sync(&fd_timer);
> > > +       destroy_workqueue(system_nrt_wq);
> > 
> > Well, *that* doesn't look right.
> > 
> > I think just a "flush_workqueue()" is in order.
> 
> System wqs shouldn't be flushed (nothing guarantees that flush will
> finish in fixed amount of time).  We probably should make that
> explicit by whining when someone tries to flush one of the system wqs.
> Here, the two cancel_delayed_work_sync() calls should be enough.

Well, then I think this might be an issue for straightforward conversion 
of floppy driver to system_nrt_wq -- see floppy_grab_irq_and_dma().

So perhaps going back to the original version with separate 
single-threaded workqueue would be a reasonable idea.

-- 
Jiri Kosina
SUSE Labs
