Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab2ERQKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:10:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42702 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab2ERQKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:10:07 -0400
Date: Sat, 19 May 2012 01:10:01 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com,
        mtosatti@redhat.com, yoshikawa.takuya@oss.ntt.co.jp
Subject: Re: [RFC] sched: make callers check lock contention for
 cond_resched_lock()
Message-Id: <20120519011001.521acd09c636f97e38f000d6@gmail.com>
In-Reply-To: <20120518072604.GG429@gmail.com>
References: <20120503171244.2debdd80931ccf35f387c5fe@gmail.com>
	<1336034127.13683.197.camel@twins>
	<20120503212244.6abbfa8bc3f46a7f7a932bb7@gmail.com>
	<1336048150.22523.17.camel@twins>
	<20120503220050.e91938418f882b4075526e08@gmail.com>
	<1336060050.22523.23.camel@twins>
	<20120511070357.9bf8f9b6636a12927f26bfed@gmail.com>
	<20120518072604.GG429@gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2012 09:26:05 +0200
Ingo Molnar <mingo@kernel.org> wrote:

> I'm not sure we had a usable spin_is_contended() back then, nor 
> was the !PREEMPT case in my mind really.

The fact that both spin_needbreak() and spin_is_contended() can be
used outside of sched is a bit confusing.

For example, in mm/compaction.c we are using spin_is_contended(), but
in mm/memory.c spin_needbreak().

BTW, the actual users of spin_is_contended() look to be only:
	mm/compaction.c
	security/keys/gc.c

> ( The patch looks ugly though, in 99% of the lines it just does
>   something that cond_resched_lock() itself could do. )

Please ignore the patch.  I have already found a way to solve my
problem without cond_resched().

Thanks,
	Takuya
