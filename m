Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab1BYVpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 16:45:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248Ab1BYVpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 16:45:31 -0500
Date: Fri, 25 Feb 2011 16:45:12 -0500
From: Don Zickus <dzickus@redhat.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        gorcunov@gmail.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] x86, NMI: Allow NMI reason io port (0x61) to be
 processed on any CPU
Message-ID: <20110225214512.GA25823@redhat.com>
References: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
 <1294348732-15030-6-git-send-email-dzickus@redhat.com>
 <alpine.LFD.2.00.1102230227010.31425@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1102230227010.31425@eddie.linux-mips.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 02:39:58AM +0000, Maciej W. Rozycki wrote:
>  [Catching up with old e-mail...]
> 
>  In line with the comment above that you're removing -- have you (or 
> anyone else) adjusted code elsewhere so that external NMIs are actually 
> delivered to processors other than the BSP?  I can't see such code in this 
> series nor an explanation as to why it wouldn't be needed.
> 
>  For the record -- the piece of code above reflects our setup where the 
> LINT1 input is enabled and configured for the NMI delivery mode on the BSP 
> only and all the other processors have this line disabled in their local 
> APIC units.  If system NMIs are to be handled after the removal of the 
> BSP, then another processor has to be selected and configured for NMI 
> reception.  Alternatively, all local units could have their LINT1 input 
> enabled and arbitrate handling, although it would be quite disruptive as 
> all the processors would take the interrupt if it happened.  OTOH it would 
> be more fault-tolerant in the case of a CPU failure.  On a typical x86 box 
> the system NMI cannot be routed to an I/O APIC input.

Intel requested this.  From my understanding they are working on
technology to allow removal of the BSP and still having the system work
correctly.  This patch is probably just the first step of many.  But I
don't really know what they are working on nor what else they need.

Cheers,
Don
