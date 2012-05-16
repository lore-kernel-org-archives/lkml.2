Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966096Ab2EPU3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:29:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59403 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965362Ab2EPU33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:29:29 -0400
Date: Wed, 16 May 2012 13:29:24 -0700
From: Tejun Heo <tj@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] floppy: convert to delayed work and single-thread wq
Message-ID: <20120516202924.GE21275@google.com>
References: <alpine.LNX.2.00.1205160932280.8796@pobox.suse.cz>
 <20120516170124.GA21275@google.com>
 <alpine.LNX.2.00.1205162133180.8796@pobox.suse.cz>
 <CA+55aFw-us7LnG-iq5EQmSDJ7xH9hiOMmCryAGobReko4LkVWg@mail.gmail.com>
 <20120516195332.GC21275@google.com>
 <alpine.LNX.2.00.1205162156120.8796@pobox.suse.cz>
 <20120516200147.GD21275@google.com>
 <alpine.LNX.2.00.1205162216390.8796@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1205162216390.8796@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 10:24:37PM +0200, Jiri Kosina wrote:
> In floppy_grab_irq_and_dma() the point is to drain the workqueue 
> completely (before the conversion, we were just using 
> flush_work_sync(&floppy_work) for particular work item), and for that 
> flush_work() is not sufficient any more.
> 
> So I am really considering going back to driver-specific singlethreaded 
> workqueue.

Ummm... still confused.  flush_work_sync() is fine too.  If you have
two, two calls to flush_work_sync() are equivalent to flushing the
workqueue in effect.  You just need to avoid flush_workqueue() because
system workqueues may be hosting work items which can run arbitrarily
long.

Thanks.

-- 
tejun
