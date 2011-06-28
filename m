Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab1F1K4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:56:37 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50442 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188Ab1F1Kzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:55:41 -0400
MIME-Version: 1.0
In-Reply-To: <20110627142253.cc35bfbe.sfr@canb.auug.org.au>
References: <20110627142253.cc35bfbe.sfr@canb.auug.org.au>
Date: Tue, 28 Jun 2011 12:55:38 +0200
Message-ID: <BANLkTim2aZB6a_2wgA=5wLNYh-SaQfupvQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the tip tree
From: Stijn Devriendt <highguy@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've already reported this to Thomas with a patch attached.

See https://lkml.org/lkml/2011/6/25/62

Regards,
Stijn

On Mon, Jun 27, 2011 at 6:22 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>
> arch/x86/kernel/i8253.c: In function 'setup_pit_timer':
> arch/x86/kernel/i8253.c:22:2: error: implicit declaration of function 'clockevent_i8253_init'
> arch/x86/kernel/i8253.c:23:24: error: 'i8253_clockevent' undeclared (first use in this function)
>
> Caused by commit 2739ce151665 ("x86: Use common i8253 clockevent").
> clockevent_i8253_init() doesn't appear to be declared in any header file
> even though it is introduced as a global function in commit 9f9119424bbc
> ("i8253: Create common clockevent implementation").  Similarly for
> i8253_clockevent.
>
> I have used the tip tree from next-20110624 for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>
