Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab0EYIri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 04:47:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48522 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab0EYIrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 04:47:37 -0400
Subject: Re: [PATCH 00/11] V4: rwsem changes + down_read_critical() proposal
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
In-Reply-To: <1274733081-4623-1-git-send-email-walken@google.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 May 2010 10:47:19 +0200
Message-ID: <1274777239.5882.581.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 13:31 -0700, Michel Lespinasse wrote:
> This is version 4 of my rwsem changes.
> 
> Changes since V3:
> 
> - Split first x86 rwsem change in two smaller parts
> - Added David's rwsem_waiter_type enum suggestion into
>   'rwsem: down_read_critical infrastructure support'
> - Lots of minor style fixes and comments clarified
> 
> I would hope the entire series can be considered for inclusion;
> however if we can not agree on the down_read_critical() bits I would
> still like patches 1-7 to be independently considered as I think they
> still have merit on their own.
> 
> Michel Lespinasse (11):
>   x86 rwsem: stay on fast path when count>0 in __up_write()
>   x86 rwsem: minor cleanups
>   rwsem: fully separate code pathes to wake writers vs readers
>   rwsem: lighter active count checks when waking up readers
>   rwsem: let RWSEM_WAITING_BIAS represent any number of waiting threads
>   rwsem: wake queued readers when writer blocks on active read lock
>   rwsem: smaller wrappers around rwsem_down_failed_common
>   generic rwsem: implement down_read_critical() / up_read_critical()
>   rwsem: down_read_critical infrastructure support
>   x86 rwsem: down_read_critical implementation
>   Use down_read_critical() for /proc/<pid>/exe and /proc/<pid>/maps files


So what happened to those patches that dropped mmap_sem during I/O?

I really don't like people tinkering with the lock implementations like
this. Nor do I like the naming, stats are in no way _critical_.

I really think adding something like this utterly defeats the purpose of
having a fair lock.
