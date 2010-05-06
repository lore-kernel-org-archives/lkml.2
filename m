Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab0EFPgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 11:36:08 -0400
Received: from mail2.shareable.org ([80.68.89.115]:47654 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab0EFPgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 11:36:04 -0400
Date: Thu, 6 May 2010 16:35:46 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Changli Gao <xiaosuo@gmail.com>
Cc: akpm@linux-foundation.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [RFC] mm: generic adaptive large memory allocation APIs
Message-ID: <20100506153546.GC28512@shareable.org>
References: <1273105838-4441-1-git-send-email-xiaosuo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273105838-4441-1-git-send-email-xiaosuo@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changli Gao wrote:
> kvmalloc() will try to allocate physically contiguous memory first, and try 
> vmalloc to allocate virtually contiguous memory when the former allocation
> fails.

Note that converting users from vmalloc() to kvmalloc() may increase
fragmentation problems for other parts of the kernel, because it will
tend to use up more of the available large blocks.  Especially users
who allocate large blocks and often.  That's worth a mention
somewhere.

On the other hand, this API could make it easier to convert some kmalloc()
calls to kvmalloc(), reducing fragmentation problems. :-)

Since the caller is indicating they don't mind which happens, then
anti-fragmentation heuristics (such as checking watermarks) could be
added to kvmalloc() at some future time, if needed.

-- Jamie
