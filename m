Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab2K3RCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:02:16 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64293 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab2K3RCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:02:12 -0500
MIME-Version: 1.0
In-Reply-To: <50B7D28A.4000401@linux.intel.com>
References: <1354132230-21854-1-git-send-email-hpa@linux.intel.com>
 <1354132230-21854-9-git-send-email-hpa@linux.intel.com> <20121128204158.GC14635@liondog.tnic>
 <50B7D28A.4000401@linux.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Nov 2012 09:01:50 -0800
X-Google-Sender-Auth: fChoGjZ3xPHCIrjX4OiP6k4ilFM
Message-ID: <CA+55aFziiaWt1nU-EPKc=tFd0EvSm2iSBJ2MAqxNiWP5O0mv+w@mail.gmail.com>
Subject: Re: [PATCH 8/8] x86, cleanups: Simplify sync_core() in the case of no CPUID
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mario Gzuk <mariogzuk@technikz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 1:24 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>
> Thinking about it some more, there is another reason to not do this,
> which is that we don't want this particular CPUID to be paravirtualized;
> we're after the synchronizing side effect, not the CPUID return value
> itself.
>
> So let's leave it as a primitive; it gets too confusing otherwise.

Hmm. The virtualization issue brings up another point: do we *really*
want to use cpuid for serialization at all?

Exactly because under _real_ virtualization (as opposed to para-virt),
it can cause unnecessary exits in a virtualized environment, no?

So I'm wondering if there is any better synchronizing instruction..

I guess sync_core() isn't used *that* much, so maybe we don't care,
but I thought I'd ask...

                Linus
