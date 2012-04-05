Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab2DERSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 13:18:45 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43691 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab2DERSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 13:18:44 -0400
Date: Thu, 5 Apr 2012 19:18:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] printk: support structured and multi-facility log
 messages
Message-ID: <20120405171838.GA32275@gmail.com>
References: <1333569554.864.3.camel@mop>
 <20120405150516.GA27223@gmail.com>
 <CAPXgP116dUAG61Fa34BsUitH+t=zMy3krLDQofZ9=LFBTCp5KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPXgP116dUAG61Fa34BsUitH+t=zMy3krLDQofZ9=LFBTCp5KA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kay Sievers <kay@vrfy.org> wrote:

> On Thu, Apr 5, 2012 at 17:05, Ingo Molnar <mingo@kernel.org> wrote:
> > * Kay Sievers <kay@vrfy.org> wrote:
> 
> >> - Record-based stream instead of the traditional byte stream
> >>   buffer. All records carry a 64 bit timestamp, the syslog facility
> >>   and priority in the record header.
> 
> > Hm, this seems to be a conceptual duplication of the console
> > tracepoint that include/trace/events/printk.h already offers.
> 
> General purpose kernel logging should not depend on _optional_ 
> facilities mainly intended for debugging and profiling. This 
> is stuff that should be used on every box out there, very much 
> much unlike tracing.

Firstly, you modify printk() and make it less simple and break 
its ASCII oriented nature - which is my primary objection: if 
you want to emit binary data then use existing binary logging 
facilities.

If you want to extend the ASCII output then work in the ASCII, 
human readable space and improve it.

If you want binary record logging (I'm not convinced printk() 
should do that, btw. - we are keeping it ASCII for damn good 
reasons), use perf software events - check your kernel, those 
are enabled more widely than even CONFIG_PRINTK is enabled - so 
your whole "but I don't want to rely on a non-generic facility" 
objection is bogus: perf events, if you decide to use them, are 
as generic as it gets.

So unless you have better justification for it than what you 
listed so far, or unless you have a better implementation that 
either goes into the better binary logging or into the better 
ASCII logging direction:

NAcked-by: Ingo Molnar <mingo@kernel.org>

Because this one is neither.

Thanks,

	Ingo
