Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab2GZM43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 08:56:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64078 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2GZM41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 08:56:27 -0400
Date: Thu, 26 Jul 2012 14:56:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] jiffies: Allow CLOCK_TICK_RATE to be undefined
Message-ID: <20120726125620.GD24672@gmail.com>
References: <1342660753-10382-1-git-send-email-john.stultz@linaro.org>
 <1342660753-10382-2-git-send-email-john.stultz@linaro.org>
 <20120719093704.GB27086@gmail.com>
 <500DA7EB.1030608@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500DA7EB.1030608@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> On 07/19/2012 02:37 AM, Ingo Molnar wrote:
> >* John Stultz <john.stultz@linaro.org> wrote:
> >
> >>From: Catalin Marinas <catalin.marinas@arm.com>
> ...
> >>diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
> >>index 265e2c3..a2134be 100644
> >>--- a/include/linux/jiffies.h
> >>+++ b/include/linux/jiffies.h
> >>@@ -39,9 +39,6 @@
> >>  # error Invalid value of HZ.
> >>  #endif
> >>-/* LATCH is used in the interval timer and ftape setup. */
> >>-#define LATCH  ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
> >>-
> >>  /* Suppose we want to divide two numbers NOM and DEN: NOM/DEN, then we can
> >>   * improve accuracy by shifting LSH bits, hence calculating:
> >>   *     (NOM << LSH) / DEN
> >>@@ -54,8 +51,15 @@
> >>  #define SH_DIV(NOM,DEN,LSH) (   (((NOM) / (DEN)) << (LSH))              \
> >>                               + ((((NOM) % (DEN)) << (LSH)) + (DEN) / 2) / (DEN))
> >>+#ifdef CLOCK_TICK_RATE
> >>+/* LATCH is used in the interval timer and ftape setup. */
> >>+#define LATCH ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
> >>+
> >>  /* HZ is the requested value. ACTHZ is actual HZ ("<< 8" is for accuracy) */
> >>  #define ACTHZ (SH_DIV (CLOCK_TICK_RATE, LATCH, 8))
> >>+#else
> >>+#define ACTHZ (HZ << 8)
> >>+#endif
> >The ACTHZ naming ugliness slipped past me. 'ACT' can mean so
> >many things - please improve it to something more obvious, like
> >'REAL_HZ' or 'KERNEL_HZ'.
> 
> ACTHZ has been around for a while. ~2002 I think?

Time flies!

> Is it ok if I do the rename in a following patch?

Sure.

> >Also, we tend to write such #if/#else/#endif patterns as:
> >
> >#if FOO
> ># define BAR
> >#else
> ># define BAZ
> >#endif
> I'll fix this.

Thanks!

	Ingo
