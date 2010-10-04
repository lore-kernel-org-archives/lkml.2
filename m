Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab0JDBNd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 21:13:33 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56542 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab0JDBNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 21:13:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
References: <20100930221351.682772535@linutronix.de>
	<m1wrpzfctu.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.1010032034420.14550@localhost6.localdomain6>
Date: Sun, 03 Oct 2010 18:13:15 -0700
In-Reply-To: <alpine.LFD.2.00.1010032034420.14550@localhost6.localdomain6>
	(Thomas Gleixner's message of "Sun, 3 Oct 2010 21:16:47 +0200 (CEST)")
Message-ID: <m11v8692vo.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Thomas Gleixner <tglx@linutronix.de>
X-Spam-Relay-Country: 
Subject: Re: [patch 00/47] Sparse irq rework
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

>> I don't know that I have a problem with this but I do have a problem
>> with using a bitmap.  A lot of the kernels irq usage has been distored
>> because we use a compact array, that we cannot grow over time.  Using a
>> bitmap here essentially removes 90% of the point of sparse irq.  The
>> ability to remove a hard coded NR_IRQS from the kernel.
>
> Well, lets look at some (un)realistic numbers:
>
> Assume 16k cores and 32 irqs / core. That's 512k interrupts and
> requires a 64k bitmap.
>
> If we hit that limit, then we have some other more serious problems to
> solve.

Possibly. 

Fundamentally keeping NR_IRQS anywhere I see as a problem, and it
really disturbs me.  Even nr_irqs I see as pretty fishy.

Looking at this objectively I see a bitmap sized to the formula
32*NR_CPUS with NR_CPUS expected to double every 18-24 months.
Which means in a decade our worst case will be 2M not 64k.

Can we please build this with scalable interfaces so we don't have to do
this again in a couple of years, and so we don't have to have little
machines paying the price for big machines, and so that big machines
aren't hamstrung because of data structures built for little machines.

Perhaps this just requires using ida instead of a bitmap.


I really think it is a mistake to use an irq number outside of the
functions in interrupt.h that go to the drivers and the userspace
display functions.

Eric

