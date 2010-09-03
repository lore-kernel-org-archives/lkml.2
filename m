Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab0ICOdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 10:33:01 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:8475 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab0ICOdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 10:33:00 -0400
X-Loopcount0: from 143.166.82.43
Date: Fri, 3 Sep 2010 09:32:58 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.kernel.org>
Subject: Re: [PATCH] perf, x86: Disable perf if the BIOS got its grubby paws on the PMU
Message-ID: <20100903143258.GB373@auslistsprd01.us.dell.com>
References: <1283505227.1783.224.camel@laptop> <4C80FDF7.1080106@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C80FDF7.1080106@linux.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 06:53:59AM -0700, Arjan van de Ven wrote:
> On 9/3/2010 2:13 AM, Peter Zijlstra wrote:
> >
> >+static void print_BIOS_fail(void)
> >+{
> >+	printk(KERN_ERR "\n");
> >+	printk(KERN_ERR "=============================================\n");
> >+	printk(KERN_ERR "It appears the BIOS is actively using the PMU\n");
> >+	printk(KERN_ERR "this avoids Linux from using it, please de-  \n");
> >+	printk(KERN_ERR "activate this BIOS feature or request a BIOS \n");
> >+	printk(KERN_ERR "update from your vendor.                     \n");
> >+	printk(KERN_ERR "=============================================\n");
> >+
> >+	memset(&x86_pmu, 0, sizeof(x86_pmu));
> >+}
> >+
> >   
> 
> 
> tell us how you really feel :-)
> 
> do you want to add a phone number of the support line of the vendor 
> (based on DMI data of course) ?

I must object to messages that repeatedly (at least on every boot)
tell system administrators to contact their hardware vendor's support
lines, when it's not clear what the BIOS is doing is incorrect.  There
are plenty of valid reasons why BIOS itself would use PMU counters.
Dell PowerEdge server power management, handled by the BIOS, certainly
does use one.

My understanding is that there is a mechanism for the OS to request
BIOS to release use of PMU counters.  Are we doing that?  If BIOS does
not release the counters when asked, ok, that's something to
(potentially) warn about.  But blanket "BIOS is using a CPU feature!
Bad BIOS!  No treat for you!" - that's not helpful to anyone.

Thanks,
Matt

-- 
Matt Domsch
Technology Strategist
Dell | Office of the CTO
