Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab0CUOoN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 10:44:13 -0400
Received: from www.tglx.de ([62.245.132.106]:54928 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab0CUOoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 10:44:11 -0400
Date: Sun, 21 Mar 2010 15:43:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH] irq: Start the transition of irq_chip methods taking a
 desc
In-Reply-To: <m1eijd3jl7.fsf_-_@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1003211541120.3147@localhost.localdomain>
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org> <1267697339-5491-7-git-send-email-yinghai@kernel.org> <alpine.LFD.2.00.1003041142460.2014@localhost.localdomain> <4B900250.8020100@kernel.org> <Pine.LNX.4.64.1003050847170.21768@ask.diku.dk>
 <m1eije71et.fsf@fess.ebiederm.org> <Pine.LNX.4.64.1003211153470.7805@ask.diku.dk> <m1eijd3jl7.fsf_-_@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

On Sun, 21 Mar 2010, Eric W. Biederman wrote:
> 
> With SPARSE_IRQ irq_to_desc becomes an unnecessary lookup operation on
> the fast path of dispatching irqs to their handlers.  We can avoid
> this cost by passing an irq_desc pointer instead of using an integer
> irq token to the irq_chip methods.
> 
> A single patch to convert all of the architectures is an unreviewable
> 2000+ line patch.  A gradual transition scenario with two sets of
> irq_chip methods in irq_chip is an unmanageable mess in kernel/irq.
> 
> So instead I define some macros so the generic irq code in kernel/irq/
> can compile either way based on a boolean Kconfig variable
> CONFIG_CHIP_PARAM_DESC.  This allows us to convert one architecture at
> a time, reducing the follow on patches to manageable proportions.  It
> is a little bit ugly but it is much better than the alternatives, and
> as soon as we finish the transition we can kill the macros.
> 
> I introduce the macros CHIP_ARG, CHIP_VAR, and CHIP_PARAM where
> appropriate.  I change a few declarations of irq as int to unsigned
> int.  I normalize the variables names in the functions that call
> chip methods to ensure that I have the variables irq and desc present
> allowing CHIP_ARG to work properly.  Most importantly none of the irq
> logic changes with this patch.

I like that approach very much. Is the output binary equivivalent?

Thanks,

	tglx
