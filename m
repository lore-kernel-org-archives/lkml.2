Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062Ab0ITEtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 00:49:32 -0400
Received: from ozlabs.org ([203.10.76.45]:52197 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773Ab0ITEta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 00:49:30 -0400
Date: Mon, 20 Sep 2010 14:20:11 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, dhowells <dhowells@redhat.com>,
        Russell King <rmk@arm.linux.org.uk>, Kyle McMartin <kyle@mcmartin.ca>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        davem <davem@davemloft.net>, Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH -tip -v5] irq_work: generic hard-irq context callbacks
Message-ID: <20100920042011.GA13542@drongo>
References: <1284689131.32373.63.camel@yhuang-dev>
 <1284728802.28028.470.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284728802.28028.470.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 03:06:42PM +0200, Peter Zijlstra wrote:

> Provide a mechanism that allows running code in IRQ context. It is most
> useful for NMI code that needs to interact with the rest of the system
> -- like wakeup a task to drain buffers.
> 
> Perf currently has such a mechanism, so extract that and provide it as a
> generic feature, independent of perf so that others may also benefit.
> 
> The IRQ context callback is generated through self-IPIs where possible,
> or on architectures like powerpc which have soft-disabled IRQs, its ran
> on the soft-enable path.

Actually these days we do it by setting the decrementer (the built-in
timer facility) to generate an interrupt immediately (well, within one
timebase tick, i.e. a small number of nanoseconds).

Paul.
