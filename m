Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab0IBOTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:19:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab0IBOTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:19:19 -0400
Date: Thu, 2 Sep 2010 10:19:00 -0400
From: Don Zickus <dzickus@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/4] [x86] perf: fix accidentally ack'ing a second event
 on intel perf counter
Message-ID: <20100902141900.GG4879@redhat.com>
References: <AANLkTimA-AZWJugaLR3VPGVhBaJid=t=a1rPVNUE_8Dh@mail.gmail.com>
 <20100901145728.GM22783@erda.amd.com>
 <AANLkTikOaCL8FqQuUQsYPxm19WZOdarp8AMAugN0mnqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikOaCL8FqQuUQsYPxm19WZOdarp8AMAugN0mnqQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 10:13:19AM +0200, Stephane Eranian wrote:
> Robert,
> 
> Do you have the test program you used to test this?
> I believe the NHM hack does not solve the problem, it
> just makes it harder to appear.

Could be.

> 
> I suspect the real issue is that the GLOBAL_STATUS
> bitmask cannot be trusted. I'd like to verify this.
> 
> Has the problem appear only on Nehalem or also on
> Westmere?

I was able to duplicate on

Intel(R) Core(TM) i5 CPU         650  @ 3.20GHz
Intel(R) Xeon(R) CPU           X5560  @ 2.80GHz

with just running 'perf top' for about 60 seconds.

You would need the first three patches to expose the problem.

Reading the code, it seemed like the perf counters should be disabled and
this patch should be unecessary, but after playing around with the code
for a few hours, I came up with this patch to trap the issue.

I read through the cpu errata and could not find anything related but I
might have missed something.

I am willing to help test if you have a more targeted patch.

Cheers,
Don
