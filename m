Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750916Ab1INEkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 00:40:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41206 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1INEkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 00:40:18 -0400
Date: Wed, 14 Sep 2011 05:40:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Lockdep and rw_semaphores
Message-ID: <20110914044013.GD2203@ZenIV.linux.org.uk>
References: <4E6C1016.8030703@vlnb.net>
 <20110911023840.GZ2203@ZenIV.linux.org.uk>
 <4E6EBDA8.2040401@vlnb.net>
 <20110913051714.GC2203@ZenIV.linux.org.uk>
 <4E70098D.2050504@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E70098D.2050504@vlnb.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 09:55:25PM -0400, Vladislav Bolkhovitin wrote:

> > thread 1:
> > 	down_read(&A); /* got it */
> > thread 2:
> > 	down_read(&B); /* got it */
> > thread 3:
> > 	down_write(&A);	/* blocked until thread 1 releases A */

That's the only thread here doing down_write() on A

> > thread 4:
> > 	down_write(&B);	/* blocked until thread 2 releases B */

... and that's the only thread here doing down_write() on B.  And neither
of those is holding any other locks.  No nesting.

> 1. Reverse read locking isn't always a deadlock. For instance, if only 1 write
> thread participating and doesn't do nested write locking, which is a quite valid
> scenario, because by design of rw locks they are used with many readers and
> limited amount of rare writers.

Um?  If you mean that here we have two threads doing down_write(), remember
that you've got two locks.

> So, it should be better if this warning is issued, if there is >1 thread write
> locking detected on any participated rw lock, and illustrated with a correct
> explanation.

Which would be which threads, in the situation described above?  Again,
we have no nesting for writes and we have one thread attempting down_write()
for any given lock.  Two locks, two writers in total...
