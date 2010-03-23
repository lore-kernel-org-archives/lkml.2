Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab0CWSOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:14:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754247Ab0CWSOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:14:47 -0400
Date: Tue, 23 Mar 2010 11:13:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
       bugme-daemon@bugzilla.kernel.org, ant.starikov@gmail.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge
 regression in performance
Message-Id: <20100323111351.756c8752.akpm@linux-foundation.org>
In-Reply-To: <20100323173409.GA24845@elte.hu>
References: <bug-15618-10286@https.bugzilla.kernel.org/>
	<20100323102208.512c16cc.akpm@linux-foundation.org>
	<20100323173409.GA24845@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Mar 2010 18:34:09 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> It shows a very brutal amount of page fault invoked mmap_sem spinning 
> overhead.
> 

Yes.  Note that we fall off a cliff at nine threads on a 16-way.  As
soon as a core gets two threads scheduled onto it?  Probably triggered
by an MM change, possibly triggered by a sched change which tickled a
preexisting MM shortcoming.  Who knows.

Anton, we have an executable binary in the bugzilla report but it would
be nice to also have at least a description of what that code is
actually doing.  A quick strace shows quite a lot of mprotect activity.
A pseudo-code walkthrough, perhaps?

Thanks.
