Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630Ab2COLGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 07:06:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:43412 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab2COLGw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 07:06:52 -0400
Message-ID: <1331809597.18960.171.camel@twins>
Subject: Re: [PATCH] watchdog: Make sure the watchdog thread gets CPU on
 loaded system
From: Peter Zijlstra <peterz@infradead.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Ingo Molnar <mingo@elte.hu>
Date: Thu, 15 Mar 2012 12:06:37 +0100
In-Reply-To: <1331809239.18960.168.camel@twins>
References: <1331757525-5755-1-git-send-email-dzickus@redhat.com>
	 <20120314161906.e53359d3.akpm@linux-foundation.org>
	 <20120315014511.GT27051@google.com> <1331809239.18960.168.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 12:00 +0100, Peter Zijlstra wrote:
> On Wed, 2012-03-14 at 18:45 -0700, Mandeep Singh Baines wrote:
> > You could make MAX_RT_PRIO greater than MAX_USER_RT_PRIO but that
> > might
> > have some impact on real-time applications. A simple one-line patch:
> > 
> > - #define MAX_RT_PRIO           MAX_USER_RT_PRIO
> > + #define MAX_RT_PRIO           (MAX_USER_RT_PRIO + 1)
> > 
> > would prevent user-space from causing a false lockup detection.
> 
> We're so not going to muck with the fifo priorities just for this stupid
> soft watchdog,.. I already hate that I can't disable the piece of crap,
> making it more involved is just really not going to happen.

And before people start to whinge about that, all the soft watchdog
issues I've seen fly by the past year or so all were bugs in the
watchdog itself, I can't actually remember it flagging a real problem.

The NMI watchdog otoh works like a charm for me and regularly helps out
when I done stupid.

