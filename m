Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab0IBPvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:51:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133Ab0IBPrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:47:55 -0400
Date: Thu, 2 Sep 2010 11:47:43 -0400
From: Don Zickus <dzickus@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/4] [x86] perf: fix accidentally ack'ing a second event
 on intel perf counter
Message-ID: <20100902154743.GI4879@redhat.com>
References: <AANLkTimA-AZWJugaLR3VPGVhBaJid=t=a1rPVNUE_8Dh@mail.gmail.com>
 <20100901145728.GM22783@erda.amd.com>
 <AANLkTikOaCL8FqQuUQsYPxm19WZOdarp8AMAugN0mnqQ@mail.gmail.com>
 <20100902141900.GG4879@redhat.com>
 <AANLkTin2KVPpkQWUa_GQ66q+wvZpfYHOKAfWbG-+K5FD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin2KVPpkQWUa_GQ66q+wvZpfYHOKAfWbG-+K5FD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 04:39:02PM +0200, Stephane Eranian wrote:
> Don,
> 
> On Thu, Sep 2, 2010 at 4:19 PM, Don Zickus <dzickus@redhat.com> wrote:
> > On Thu, Sep 02, 2010 at 10:13:19AM +0200, Stephane Eranian wrote:
> >> Robert,
> >>
> >> Do you have the test program you used to test this?
> >> I believe the NHM hack does not solve the problem, it
> >> just makes it harder to appear.
> >
> > Could be.
> >
> >>
> >> I suspect the real issue is that the GLOBAL_STATUS
> >> bitmask cannot be trusted. I'd like to verify this.
> >>
> >> Has the problem appear only on Nehalem or also on
> >> Westmere?
> >
> > I was able to duplicate on
> >
> > Intel(R) Core(TM) i5 CPU         650  @ 3.20GHz
> > Intel(R) Xeon(R) CPU           X5560  @ 2.80GHz
> >
> I managed to reproduce on core i7 860 (without patch4).
> Looking at the code again, I am dubious you ever execute
> the retry goto. If the PMU is disabled and you've just
> cleared the OVF_STAT, then I don't see where the new
> overflows would come from. But that's a separate problem.

I agree with you, but a printk before the goto proved otherwise! :-)

And a printk of the status bit that triggered the goto happened to be the
same one that we initially cleared.  Like I said when I initially posted
the patch, I am not sure why it works but it does do something to stem the
NMI.

There is probably a deeper problem here, I was just trying to get the
external/unknown nmis working again.

Cheers,
Don
