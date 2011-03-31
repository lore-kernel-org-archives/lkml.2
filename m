Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab1CaDel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 23:34:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568Ab1CaDek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 23:34:40 -0400
Date: Wed, 30 Mar 2011 23:34:33 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: excessive kworker activity when idle. (was Re: vma corruption in
 today's -git)
Message-ID: <20110331033432.GA434@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20110329040939.GA32764@redhat.com>
 <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
 <20110331030917.GB26057@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331030917.GB26057@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 11:09:18PM -0400, Dave Jones wrote:
 
 > I can still reproduce the problem where kworker threads go nutso
 > when the machine should be completely idle.
 > 
 > top shows two kworker threads constantly at >80% cpu.
 > 
 > I can now profile it with perf though, so I'll dig deeper.
 > I need to try a build with slab debug etc turned off, just to be sure that
 > isn't throwing things into a spin.

so 'perf kmem record sleep 5' shows hundreds of calls kmem_cache_free from
the kworker processes. Called from shmem_i_callback, __d_free and file_free_rcu.
My guess is that my fuzzing caused so many allocations that the rcu freeing is
still ongoing an hour or so after the process has quit.  does that make any sense?

Although if that hypothesis is true, shouldn't I be able to observe this
by watching slabtop ? because I don't see anything decreasing...


	Dave

