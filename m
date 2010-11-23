Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab0KWQ5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 11:57:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755833Ab0KWQ5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 11:57:04 -0500
Date: Tue, 23 Nov 2010 11:56:57 -0500
From: Don Zickus <dzickus@redhat.com>
To: sedat.dilek@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] x86, perf, nmi: Disable perf if counters are not
 accessable
Message-ID: <20101123165657.GF18100@redhat.com>
References: <AANLkTikzSY09i=C+A2Y=_gVa-44r_bN76P-U2-NZMnpz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikzSY09i=C+A2Y=_gVa-44r_bN76P-U2-NZMnpz@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 04:15:05PM +0100, Sedat Dilek wrote:
> Hi,
> 
> I am seeing for a while this warning in my system-wide logs:
> 
> Nov 23 11:54:14 tbox kernel: [    0.040335] NMI watchdog failed to
> create perf event on cpu0: ffffffa1
> 
> As I saw this patch from [1], I was hoping it's also fixing my problem
> on an Intel Pentium-M (Banias) Single-Core CPU:

I doubt it.  This patch was intended for virtualization where the perf
counters are not emulated but the perf subsystem didn't know that.

Your error code is 'ffffffa1'.  That translates to EOPNOTSUPP.  The only
place I can see where that is returned is if your system does not have a
local apic on it (as set by the cpu feature bits).

Applying this patch may still get you the same result because the perf
counters might be there but there is no local apic to deliver the
interrupts.

I would have to see in your log file the output starting at the line with

Performance Events:

and pasting the next dozen lines or so to have a better understanding what
is going on.  Or you can just attach the whole log in your reply.

Cheers,
Don
