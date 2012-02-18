Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab2BRW3n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 17:29:43 -0500
Received: from nctlincom02.orcon.net.nz ([60.234.4.75]:42956 "EHLO
	nctlincom02.orcon.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab2BRW3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 17:29:37 -0500
Message-ID: <4F40264E.6050602@orcon.net.nz>
Date: Sun, 19 Feb 2012 11:29:34 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Jim Faulkner <jfaulkne@ccs.neu.edu>
CC: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, gregkh@linuxfoundation.org, rth@twiddle.net,
        ink@jurassic.park.msu.ru, mattst88@gmail.com,
        torvalds@linux-foundation.org, jay.estabrook@gmail.com
Subject: Re: [PATCH] fix modpost when CONFIG_ALPHA_TSUNAMI=y
References: <20120109003504.GA19756@alumni-linux.ccs.neu.edu> <20120218212431.GA25058@alumni-linux.ccs.neu.edu>
In-Reply-To: <20120218212431.GA25058@alumni-linux.ccs.neu.edu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx7.orcon.net.nz on Sun, 19 Feb 2012 11:29:34 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Feb 19 11:29:35 2012
X-DSPAM-Confidence: 0.6183
X-DSPAM-Probability: 0.0000
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, default)
X-Spam-Score: 0.00 () [Hold at 5.00] 
X-CanIt-Geo: ip=60.234.221.162; country=NZ; region=E7; city=Auckland; latitude=-36.8667; longitude=174.7667; http://maps.google.com/maps?q=-36.8667,174.7667&z=6
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 05GzytKan - 198aecb3594a - 20120219
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/02/12 10:24, Jim Faulkner wrote:
> Linux 3.2.6 fails to modpost on my alpha machine when
> CONFIG_ALPHA_TSUNAMI=y.  Linux 3.3-rc3 does not appear to have a fix for
> this bug, so is likely also affected.  I've attached a patch which fixes
> this issue.  I have tested this patch on Linux 3.2.6 successfully, and
> the patch also applies cleanly to Linux 3.3-rc3.

> diff -uNr linux-3.3-rc3/arch/alpha/kernel/core_tsunami.c linux-3.3-rc3.patched/arch/alpha/kernel/core_tsunami.c
> --- linux-3.3-rc3/arch/alpha/kernel/core_tsunami.c	2012-02-08 22:21:53.000000000 -0500
> +++ linux-3.3-rc3.patched/arch/alpha/kernel/core_tsunami.c	2012-02-18 16:07:12.859977887 -0500
> @@ -11,6 +11,7 @@
>  #include <asm/core_tsunami.h>
>  #undef __EXTERN_INLINE
>  
> +#include <linux/module.h>

Wouldn't <linux/exports.h> be better?  I seem to recall that this was a
problem with EXPORT_SYMBOL not being defined and I see my own personal
fix (which I had completely forgotten to send upstream) was to include
<linux/exports.h>

>  #include <linux/types.h>
>  #include <linux/pci.h>
>  #include <linux/sched.h>

Cheers
Michael.
