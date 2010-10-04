Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab0JDGhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 02:37:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51825 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408Ab0JDGhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 02:37:01 -0400
Date: Mon, 4 Oct 2010 08:36:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [patch 00/47] Sparse irq rework
Message-ID: <20101004063634.GA2230@elte.hu>
References: <20100930221351.682772535@linutronix.de>
 <m1wrpzfctu.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.1010032034420.14550@localhost6.localdomain6>
 <m11v8692vo.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11v8692vo.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Looking at this objectively I see a bitmap sized to the formula 
> 32*NR_CPUS with NR_CPUS expected to double every 18-24 months. Which 
> means in a decade our worst case will be 2M not 64k.

On a 16 TB box? Noise.

> Can we please build this with scalable interfaces so we don't have to 
> do this again in a couple of years, and so we don't have to have 
> little machines paying the price for big machines, and so that big 
> machines aren't hamstrung because of data structures built for little 
> machines.

Bitmaps are rather scalable, we use them all around the place.

> Perhaps this just requires using ida instead of a bitmap.

Erm, IDA/IDR uses a bitmap ...

IDA is a dynamically allocated bitmap - but for something as critical as 
IRQs i'd rather like to see a preallocated bitmap and platform control 
over the max (nr_irqs). We dont want to allow crappy drivers to install 
irq 0x12345678 and blow up the bitmap size to dozens of MB, etc.

Bitmaps are simple - and that's a virtue.

Thanks,

	Ingo
