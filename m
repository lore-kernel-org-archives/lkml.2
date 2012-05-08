Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab2EHO3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 10:29:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56055 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab2EHO3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 10:29:32 -0400
MIME-Version: 1.0
In-Reply-To: <CA+1xoqdk_yGQyX+6yHyvHsQ1hXiraOzbhVZAgmLmmtMtVTPeGQ@mail.gmail.com>
References: <1336004953.4240.9.camel@mop> <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop> <CA+1xoqdk_yGQyX+6yHyvHsQ1hXiraOzbhVZAgmLmmtMtVTPeGQ@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 8 May 2012 16:29:11 +0200
Message-ID: <CAPXgP11882vP5GtMmwdsw-w6-D6q9NXHNsHem3Ump17__r2xOQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 3:33 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> On Tue, May 8, 2012 at 1:14 PM, Kay Sievers <kay@vrfy.org> wrote:

> The 3rd one actually looks like the KERN_CONT problem now that you've
> explained it. You can see it in the 'saved trace' test in the boot
> log.
>
> I've attached the boot log which shows several other places with this
> issue,

The percpu stuff should be pending (thought it was in -next already):
  https://lkml.org/lkml/2012/3/29/317

The ACPI stuff was fixed here:
  https://lkml.org/lkml/2012/4/2/532

But only the vt and hpet things got merged so far:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=5da527aafed2834852fc4fe21daeaeadf7c61af3

I'll respin the ACPI parts now.

> if you're ok with it I can try patching those myself.

That would be awesome. If you decide otherwise, please let me know,
and I'll take care of them.

Even if we decide to relax the current strict behaviour later, we
should fix all stuff we run into. Userspace really relies on proper
messages, and not partial or mixed up things to guess what they mean.

The nice thing with the currently strict logic is that only two
instances of KERN_CONT running at the same time can race against each
other and mix their own messages. Unlike the old kmsg behaviour, users
which log a single proper terminated line, will never get interleaved
with the KERN_CONT users. This reduces the "risk" of garbled messages
to the users which actually decided to take this "risk".

Thanks,
Kay
