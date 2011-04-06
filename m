Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab1DFEnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 00:43:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54132 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab1DFEnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 00:43:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: BUG: sleeping function called from invalid context at kernel/mutex.c
Date: Wed, 6 Apr 2011 06:43:38 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Xiaotian Feng <dfeng@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <4D970CB6.3070604@redhat.com> <alpine.LFD.2.00.1104021653010.22266@localhost6.localdomain6> <1301989276.2225.1.camel@twins>
In-Reply-To: <1301989276.2225.1.camel@twins>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104060643.38301.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 05, 2011, Peter Zijlstra wrote:
> On Sat, 2011-04-02 at 21:12 +0200, Thomas Gleixner wrote:
> > 
> > And it is safe enough for the resume case as well, it simply cannot go
> > to sleep because nothing else can hold that mutex in the early resume
> > code. We take the mutex during early boot as well, but there the might
> > sleep checks are disabled. And we should do the very same thing in the
> > early resume code as well. Rafael, PeterZ ??? 
> 
> the $subject text sound like it triggered might_sleep(), and that had a
> system_state != SYSTEM_RUNNING bail condition, but then, I've no clue
> what resume looks like.

Early resume looks pretty much like the system startup, e.g. everything
called from syscore_ops should not be sleepable (although mutexes shouldn't
trigger, because that code is effectively single-threaded, unless somebody
holds the mutex in question when that code is being executed, but that would
deadlock anyway).

Thanks,
Rafael
