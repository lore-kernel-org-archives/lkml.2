Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2DEP0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:26:13 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:42558 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab2DEP0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 11:26:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120405150516.GA27223@gmail.com>
References: <1333569554.864.3.camel@mop> <20120405150516.GA27223@gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 5 Apr 2012 17:25:51 +0200
Message-ID: <CAPXgP116dUAG61Fa34BsUitH+t=zMy3krLDQofZ9=LFBTCp5KA@mail.gmail.com>
Subject: Re: [PATCH] printk: support structured and multi-facility log messages
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 5, 2012 at 17:05, Ingo Molnar <mingo@kernel.org> wrote:
> * Kay Sievers <kay@vrfy.org> wrote:

>> - Record-based stream instead of the traditional byte stream
>>   buffer. All records carry a 64 bit timestamp, the syslog facility
>>   and priority in the record header.

> Hm, this seems to be a conceptual duplication of the console
> tracepoint that include/trace/events/printk.h already offers.

General purpose kernel logging should not depend on _optional_
facilities mainly intended for debugging and profiling. This is stuff
that should be used on every box out there, very much much unlike
tracing.

I can understand that you propose the trace things, but I'm not
convinced that tracing is the same as system logging, or it will ever
become it.

Tracing is either duplicating everything in the kmsg buffer, or it
will possibly provide dangling pointers into it. Both doesn't sound
too convincing. If printk_time is used, you can even store more
messages in the same buffer as today.

The added code is less than 100 lines, if you remove the export to
/dev/kmsg. We get what we are looking for basically for free, without
to mandate any additional subsystem to built into the kernel/.

I doubt we can here talk about "yet another logging"; it is exactly
the intention _not _ to have another copy of the same data, like
tracing would introduce. This is just an improved version of the good
old kmsg buffer without really changing its interface.

Kay
