Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618Ab2EPUBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:01:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37194 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760081Ab2EPUBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:01:52 -0400
Date: Wed, 16 May 2012 13:01:47 -0700
From: Tejun Heo <tj@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] floppy: convert to delayed work and single-thread wq
Message-ID: <20120516200147.GD21275@google.com>
References: <alpine.LNX.2.00.1205160932280.8796@pobox.suse.cz>
 <20120516170124.GA21275@google.com>
 <alpine.LNX.2.00.1205162133180.8796@pobox.suse.cz>
 <CA+55aFw-us7LnG-iq5EQmSDJ7xH9hiOMmCryAGobReko4LkVWg@mail.gmail.com>
 <20120516195332.GC21275@google.com>
 <alpine.LNX.2.00.1205162156120.8796@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1205162156120.8796@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 09:57:22PM +0200, Jiri Kosina wrote:
> On Wed, 16 May 2012, Tejun Heo wrote:
> 
> > > On Wed, May 16, 2012 at 12:37 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> > > > +       cancel_delayed_work_sync(&fd_timeout);
> > > > +       cancel_delayed_work_sync(&fd_timer);
> > > > +       destroy_workqueue(system_nrt_wq);
> > > 
> > > Well, *that* doesn't look right.
> > > 
> > > I think just a "flush_workqueue()" is in order.
> > 
> > System wqs shouldn't be flushed (nothing guarantees that flush will
> > finish in fixed amount of time).  We probably should make that
> > explicit by whining when someone tries to flush one of the system wqs.
> > Here, the two cancel_delayed_work_sync() calls should be enough.
> 
> Well, then I think this might be an issue for straightforward conversion 
> of floppy driver to system_nrt_wq -- see floppy_grab_irq_and_dma().

Hmmm? flush_work() is fine.  flush_workqueue() isn't.  Am I missing
something?

-- 
tejun
