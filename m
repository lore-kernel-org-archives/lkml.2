Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934396Ab0HEVLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 17:11:21 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41526 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360Ab0HEVLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 17:11:18 -0400
Subject: Re: [PATCH] [RFC] notify userspace about time changes
From: john stultz <johnstul@us.ibm.com>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: gregkh@suse.de, lkml@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTin_5RVQo8qbJp=naN6WHdA39JM81Y+003E0SLOq@mail.gmail.com>
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org>
	 <1280937526.28884.21.camel@work-vm>
	 <AANLkTin_5RVQo8qbJp=naN6WHdA39JM81Y+003E0SLOq@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 14:11:05 -0700
Message-ID: <1281042665.3405.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 15:33 +0300, Alexander Shishkin wrote:
> On 4 August 2010 18:58, john stultz <johnstul@us.ibm.com> wrote:
> > Is there a actual use case that you need this for?  I don't really have
> > an issue with the code I just really want to make sure the feature would
> > be useful enough to justify the API and code maintenance going forward.
> 
> Yes. What we have here is an application which takes care of different means
> of time synchronization (trusted time servers, different GSM operators, etc)
> and also different kinds of time-based events/notifications (like "dentist
> appointment next thursday"). When it encounters a time change that is
> made by some other application, it basically wants to disable automatic
> time adjustment and trigger the events/notifications which are due at this
> (new) time.

Ok. Something specific is always more helpful then theoretical uses.

I think the filtering is still a bit controversial, so you might want to
respin it without that. But otherwise I'm ok with it as long as no one
else objects to any of the minor details of the interface 

GregKH: Does /sys/kernel/time_notify seem ok by you?

thanks
-john


