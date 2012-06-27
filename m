Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab2F0LMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 07:12:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53351 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab2F0LMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 07:12:48 -0400
MIME-Version: 1.0
In-Reply-To: <1340795162.10063.28.camel@twins>
References: <CAPXgP124qFG=QdO4H7qsp1bhY4BOp-PJEz7-4v-Dhi13LW+GDQ@mail.gmail.com>
 <20120627060939.GD14913@gmail.com> <CAPXgP10OLwd2v57qJqoJMTkXrM+7C8uhFoydy6HUEbfPfFVN8Q@mail.gmail.com>
 <1340795162.10063.28.camel@twins>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 27 Jun 2012 13:12:27 +0200
Message-ID: <CAPXgP117sDoiuA-i3LWFPnj+VN5BbOQrYGM8KXYCqGSan7ZZMg@mail.gmail.com>
Subject: Re: cosmetic printk() issue with lockdep warning in arch/x86/kernel/alternative.c
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartmann <greg@kroah.com>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 1:06 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2012-06-27 at 12:49 +0200, Kay Sievers wrote:
>> All we want is a reliable printk
>
> We too, but we define reliable differently. I want printk() to dump data
> ASAP so that it has better chance to get out of the system and onto my
> console in case of a crash. I don't give a rats arse about interleaved
> text, any text is better than no text.

Sure, I fully understand that this is useful.

> So if you go add separate buffers in there that will delay writing text,
> you're actively destroying printk().
>
> Any change that makes it harder to get text out is bad.

The text is always flushed immediately for full lines, there is no
change at all. Since yesterday, continuation lines (which are
buffered) are flushed immediately to the console too.

I don't think there will be a substantial difference anymore to the
old behaviour, but we still get reliable records stored in the kmsg
buffer.

Kay
