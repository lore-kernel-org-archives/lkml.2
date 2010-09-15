Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab0IONUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 09:20:32 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:48035 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab0IONUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 09:20:31 -0400
Date: Wed, 15 Sep 2010 22:50:19 +0930
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Cross Memory Attach
Message-ID: <20100915225019.4ca665fc@lilo>
In-Reply-To: <20100915080235.GA13152@elte.hu>
References: <20100915104855.41de3ebf@lilo>
	<20100915080235.GA13152@elte.hu>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 10:02:35 +0200
Ingo Molnar <mingo@elte.hu> wrote:
> 
> What did those OpenMPI facilities use before your patch - shared
> memory or sockets?

This comparison is against OpenMPI using the shared memory btl.

> I have an observation about the interface:
> 
> A small detail: 'int flags' should probably be 'unsigned long flags'
> - it leaves more space.

ok.

> Also, note that there is a further performance optimization possible 
> here: if the other task's ->mm is the same as this task's (they share 
> the MM), then the copy can be done straight in this process context, 
> without GUP. User-space might not necessarily be aware of this so it 
> might make sense to express this special case in the kernel too.

ok.

> More fundamentally, wouldnt it make sense to create an iovec
> interface here? If the Gather(v) / Scatter(v) / AlltoAll(v) workloads
> have any fragmentation on the user-space buffer side then the copy of
> multiple areas could be done in a single syscall. (the MM lock has to
> be touched only once, target task only be looked up only once, etc.)

yes, I think so. Currently where I'm using the interface in OpenMPI I
can't take advantage of this, but it could be changed in the future- and
its likely other MPI's could take advantage of it already.

> Plus, a small naming detail, shouldnt the naming be more IO like:
> 
>   sys_process_vm_read()
>   sys_process_vm_write()

Yes, that looks better to me. I really wasn't sure how to name them.

Regards,

Chris
-- 
cyeoh@au.ibm.com
