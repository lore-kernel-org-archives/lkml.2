Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab0JLObX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 10:31:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45038 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab0JLObW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 10:31:22 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Marcio Saito <marcio@cyclades.com>, John Stultz <johnstul@us.ibm.com>,
        Jiri Slaby <jirislaby@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Avantika Mathur <mathur@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, jblunck@infradead.org
Subject: Re: [RFC] [PATCH] allow low HZ values?
References: <20101011201121.GA953@tpepper-t61p.dolavim.us>
	<alpine.LFD.2.00.1010112227190.2909@localhost6.localdomain6>
Date: Tue, 12 Oct 2010 16:31:20 +0200
In-Reply-To: <alpine.LFD.2.00.1010112227190.2909@localhost6.localdomain6>
	(Thomas Gleixner's message of "Mon, 11 Oct 2010 22:32:06 +0200
	(CEST)")
Message-ID: <871v7v32kn.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> On Mon, 11 Oct 2010, Tim Pepper wrote:
>
>> I'm not necessarily wanting to open up the age old question of "what is
>> a good HZ", but we were doing some testing on timer tick overheads for
>> HPC applications and this came up...
>
> Yeah. This comes always up when the timer tick overhead on HPC is
> tested. And this patch is again the fundamentally wrong answer.

That's a unfair description of the proposal.

> We have told HPC folks for years that we need a kind of "NOHZ" mode
> for HPC where we can transparently switch off the tick when only one
> user space bound thread is active and switch back to normal once this
> thing terminates or goes into the kernel via a syscall. Sigh, nothing
> happened ever except for repeating the same crap patches over and
> over.

Jan Blunck posted a patch for this exactly few months ago.
Unfortunately it didn't get the accounting right, but other than
that it seemed like a reasonable starting point.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
