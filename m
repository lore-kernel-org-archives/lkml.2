Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab0JKVLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 17:11:48 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41529 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330Ab0JKVLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 17:11:47 -0400
From: "Tim Pepper" <lnxninja@linux.vnet.ibm.com>
Date: Mon, 11 Oct 2010 14:11:40 -0700
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Marcio Saito <marcio@cyclades.com>, Jiri Slaby <jirislaby@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        John Stultz <johnstul@us.ibm.com>,
        Avantika Mathur <mathur@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] [PATCH] allow low HZ values?
Message-ID: <20101011211140.GC953@tpepper-t61p.dolavim.us>
References: <20101011201121.GA953@tpepper-t61p.dolavim.us>
 <alpine.LFD.2.00.1010112227190.2909@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010112227190.2909@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 11 Oct at 22:32:06 +0200 tglx@linutronix.de said:
> On Mon, 11 Oct 2010, Tim Pepper wrote:
> 
> > I'm not necessarily wanting to open up the age old question of "what is
> > a good HZ", but we were doing some testing on timer tick overheads for
> > HPC applications and this came up...
> 
> Yeah. This comes always up when the timer tick overhead on HPC is
> tested. And this patch is again the fundamentally wrong answer.

Yep.  Long term no hz is definitely the goal.  I'm not sufficiently
connected to the -rt space I guess to have followed that there's somebody
again looking in that direction.  The rfc patch was mostly just a minimal
is there anything simple we can do in the meantime exercise.

> We have told HPC folks for years that we need a kind of "NOHZ" mode
> for HPC where we can transparently switch off the tick when only one
> user space bound thread is active and switch back to normal once this
> thing terminates or goes into the kernel via a syscall.

I'd not heard of this in between NOHZ-y idea...sounds promising.
We'd talked about different non-idle no hz approaches in the past year
or so, some of which were on the veeery complicated side of the spectrum.

> Sigh, nothing
> happened ever except for repeating the same crap patches over and
> over.

I'll check out what Frederic is doing.  Thanks for the pointer and
apologies for the noise.

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
