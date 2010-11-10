Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab0KJPLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:11:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756130Ab0KJPLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:11:21 -0500
Date: Wed, 10 Nov 2010 07:08:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Don Zickus <dzickus@redhat.com>, fweisbec@gmail.com,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, sergey.senozhatsky@gmail.com
Subject: Re: [PATCH v3] watchdog:  touch_nmi_watchdog should only touch
 local cpu not every one
Message-Id: <20101110070808.46c4adb5.akpm@linux-foundation.org>
In-Reply-To: <20101110074941.GD29493@elte.hu>
References: <1289240913-16677-1-git-send-email-dzickus@redhat.com>
	<20101110074941.GD29493@elte.hu>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010 08:49:41 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > I ran into a scenario where while one cpu was stuck and should have panic'd 
> > because of the NMI watchdog, it didn't.  The reason was another cpu was spewing 
> > stack dumps on to the console.  Upon investigation, I noticed that when writing to 
> > the console and also when dumping the stack, the watchdog is touched.
> > 
> > This causes all the cpus to reset their NMI watchdog flags and the 'stuck' cpu 
> > just spins forever.
> 
> Hm, the flip side is that if a CPU is stuck spewing backtraces, we will now make all 
> the other CPUs a lot more noisy - which might only 'lock up' because this CPU is 
> stuck spewing oopses, right?
> 
> Andrew, what would be your preference?
> 

I saw you were cc'ed and felt rather pleased that I wouldn't have to
decide ;)

I guess the NMI really is a cpu-local concept rather than a
machine-wide one.  And touch_nmi_watchdog() says "this CPU isn't
stuck", rather than "this CPU and all those others aren't stuck", yes?
