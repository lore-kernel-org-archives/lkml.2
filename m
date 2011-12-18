Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab1LRI3H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 03:29:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50991 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab1LRI3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 03:29:05 -0500
Date: Sun, 18 Dec 2011 09:27:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [git pull] RAS changes (queue for 3.3)
Message-ID: <20111218082708.GC4144@elte.hu>
References: <4eeb9b412912414dcf@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4eeb9b412912414dcf@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> Hi Ingo,
> 
> Kicking the tires on the new version of the RAS tree at kernel.org 2.0 (so
> please say if you'd like to see my "please pull" script to format this e-mail
> differently).
> 
> Only one patch for this test - you said you liked it in https://lkml.org/lkml/2011/12/9/24
> 
> please pull from:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git mce-inject
> 	HEAD=2c29d9dd577b74b44e580f957ea44d1df73af23a
> 
> This will update the files shown below.
> 
> Thanks!
> 
> -Tony
> 
>  arch/x86/include/asm/mce.h              |    9 ++++---
>  arch/x86/kernel/cpu/mcheck/mce-inject.c |   34 +++++++++++++++++++++++++++---
>  2 files changed, 35 insertions(+), 8 deletions(-)

Pulled, thanks Tony!

Small nit for future pulls:

> Chen Gong (1):
>       x86: add IRQ context simulation in module mce-inject

In -tip we standardized on one particular convention of 
capitalizing commit tites, i.e. the above should have been:

>       x86: Add IRQ context simulation in module mce-inject

And we also try to put (sub-)subsystem qualifiers into the 
title, i.e.:

>       x86/mce: Add IRQ context simulation in module mce-inject

Another capitalization detail is comment blocks:


+                               /*
+                                * don't wait because mce_irq_ipi is necessary
+                                * to be sync with following raise_local
+                                */

We try to capitalize these consistently as well - i.e. "Don't".

This bit also shows an ugly looking line wrapping symptom:

+                               smp_call_function_many(mce_inject_cpumask,
+                                       mce_irq_ipi, NULL, 0);

which suggests that raise_mce() would be grateful for some 
cleanup and refactoring love. The whole injection logic is now 
large and complex enough to move into its own helper function.

Btw., the printk()s could be standardized as well:

                                printk(KERN_ERR
-                               "Timeout waiting for mce inject NMI %lx\n",
+                               "Timeout waiting for mce inject %lx\n",

You could use a standard prefix like "x86 RAS: Timeout waiting 
for ..." for all RAS related messages.

These are small details, not worth rebasing your tree for, but 
would be nice to fix these things in followup cleanup commit(s).

Thanks,

	Ingo
