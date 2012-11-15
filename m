Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768620Ab2KOR75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 12:59:57 -0500
Received: from www.linutronix.de ([62.245.132.108]:36505 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768575Ab2KOR74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 12:59:56 -0500
Date: Thu, 15 Nov 2012 18:59:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.5-rt15
In-Reply-To: <CACxGe6uau6HCa3jpSzw7uwNtufCNCPN=Pt3BuoFBuNE_D7WFAw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1211151858450.2701@ionos>
References: <alpine.LFD.2.02.1211022303510.2756@ionos> <CACxGe6uau6HCa3jpSzw7uwNtufCNCPN=Pt3BuoFBuNE_D7WFAw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Grant Likely wrote:
> Hey Thomas,
> 
> I get a kernel bug when going from rt14 to rt15. It appears that
> preempt_lazy on my ARM platform causes (or exposes) the following
> backtrace on boot. I'm basing this on the only relevant change between
> rt14 and rt15 is the typo fix that enables PREEMPT_LAZY. I also see
> the problem on -rt16 and -rt17.
> 
> (full boot log also attached below)
> 
> The actual backtrace changes every time, but it is always related to
> an rt_spin_lock() call.
> 
> This is on a TI AM3894 platform which is equivalent to a TI8160
> without the DSP. The board support isn't mainlined, but there is
> nothing particularly exotic about the changes. It is primarily device
> drivers and device driver data. Cortex-A8 platform.
> 
> Any thoughts on how to debug this?

Probably by staring at the patch to the ASM code in arch/arm. I bet I
messed that up somehow :)

Thanks,

	tglx
