Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab2JZMFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:05:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932369Ab2JZMFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:05:36 -0400
Date: Fri, 26 Oct 2012 14:06:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] brw_mutex: big read-write mutex
Message-ID: <20121026120605.GA23545@redhat.com>
References: <20121018163833.GK2518@linux.vnet.ibm.com> <20121018175747.GA30691@redhat.com> <Pine.LNX.4.64.1210181525010.32376@file.rdu.redhat.com> <1350650286.30157.28.camel@twins> <Pine.LNX.4.64.1210191058060.13298@file.rdu.redhat.com> <1350668451.2768.60.camel@twins> <Pine.LNX.4.64.1210191758570.12753@file.rdu.redhat.com> <20121024030845.GT4291@dastard> <Pine.LNX.4.64.1210251008330.1849@file.rdu.redhat.com> <20121025234048.GH29378@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025234048.GH29378@dastard>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26, Dave Chinner wrote:
>
> On Thu, Oct 25, 2012 at 10:09:31AM -0400, Mikulas Patocka wrote:
> >
> > Yes, mnt_want_write()/mnt_make_readonly() do the same thing as percpu rw
> > semaphores. I think you can convert mnt_want_write()/mnt_make_readonly()
> > to use percpu rw semaphores and remove the duplicated code.
>
> I think you misunderstood my point - that rather than re-inventing
> the wheel, why didn't you just copy something that is known to
> work?

I don't understand why do you both think that __mnt_want_write()
and mnt_make_readonly() provides the same functionality. I looked
at this code before I started this patch, and unless I completely
misread it this does very different things. It is not "lock" at all.

Oleg.

