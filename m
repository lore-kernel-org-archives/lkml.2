Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab0ICOqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 10:46:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39591 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab0ICOqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 10:46:15 -0400
Subject: Re: [PATCH] perf, x86: Disable perf if the BIOS got its grubby
 paws on the PMU
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.kernel.org>
In-Reply-To: <20100903143258.GB373@auslistsprd01.us.dell.com>
References: <1283505227.1783.224.camel@laptop>
	 <4C80FDF7.1080106@linux.intel.com>
	 <20100903143258.GB373@auslistsprd01.us.dell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Sep 2010 16:46:03 +0200
Message-ID: <1283525163.2050.105.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-03 at 09:32 -0500, Matt Domsch wrote:
> On Fri, Sep 03, 2010 at 06:53:59AM -0700, Arjan van de Ven wrote:
> > On 9/3/2010 2:13 AM, Peter Zijlstra wrote:
> > >
> > >+static void print_BIOS_fail(void)
> > >+{
> > >+	printk(KERN_ERR "\n");
> > >+	printk(KERN_ERR "=============================================\n");
> > >+	printk(KERN_ERR "It appears the BIOS is actively using the PMU\n");
> > >+	printk(KERN_ERR "this avoids Linux from using it, please de-  \n");
> > >+	printk(KERN_ERR "activate this BIOS feature or request a BIOS \n");
> > >+	printk(KERN_ERR "update from your vendor.                     \n");
> > >+	printk(KERN_ERR "=============================================\n");
> > >+
> > >+	memset(&x86_pmu, 0, sizeof(x86_pmu));
> > >+}

> I must object to messages that repeatedly (at least on every boot)
> tell system administrators to contact their hardware vendor's support
> lines, when it's not clear what the BIOS is doing is incorrect. 

It is using the PMU, it should not _ever_ do that.

>  There
> are plenty of valid reasons why BIOS itself would use PMU counters.
> Dell PowerEdge server power management, handled by the BIOS, certainly
> does use one.

Them make them stop doing that, or at least provide a BIOS option to
disable this Feat^WFailure-add.

An no, doing power-management from the BIOS is most certainly not a
valid reason. That's not what BIOSes are for, a BIOS should bring up the
system and then sod off.

> My understanding is that there is a mechanism for the OS to request
> BIOS to release use of PMU counters.  Are we doing that?

I'm not aware of any such thing. The Intel Arch docs most certainly
don't specify anything about that.

>   If BIOS does
> not release the counters when asked, ok, that's something to
> (potentially) warn about.  But blanket "BIOS is using a CPU feature!
> Bad BIOS!  No treat for you!" - that's not helpful to anyone.

Again, I'm not aware there is a spec on how to ask anything of the BIOS,
let alone a part pertaining to PMU functionality.
