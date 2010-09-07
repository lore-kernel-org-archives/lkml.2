Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab0IGQyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:54:01 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:46921
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757943Ab0IGQx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:53:59 -0400
X-SpamScore: -25
X-BigFish: VPS-25(zzbb2dKbb2cK1432N98dN9371Pzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8DYUK-01-4H5-02
X-M-MSG: 
Date: Tue, 7 Sep 2010 18:51:58 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Matt Domsch <Matt_Domsch@dell.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.kernel.org>
Subject: Re: [PATCH] perf, x86: Disable perf if the BIOS got its grubby
 paws on the PMU
Message-ID: <20100907165158.GB13563@erda.amd.com>
References: <1283505227.1783.224.camel@laptop>
 <4C80FDF7.1080106@linux.intel.com>
 <20100903143258.GB373@auslistsprd01.us.dell.com>
 <1283525163.2050.105.camel@laptop>
 <20100907151541.GA13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100907151541.GA13563@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.09.10 17:15:41, Robert Richter wrote:
> > > > On 9/3/2010 2:13 AM, Peter Zijlstra wrote:
> > > > >+static void print_BIOS_fail(void)
> > > > >+{
> > > > >+	printk(KERN_ERR "\n");
> > > > >+	printk(KERN_ERR "=============================================\n");
> > > > >+	printk(KERN_ERR "It appears the BIOS is actively using the PMU\n");
> > > > >+	printk(KERN_ERR "this avoids Linux from using it, please de-  \n");
> > > > >+	printk(KERN_ERR "activate this BIOS feature or request a BIOS \n");
> > > > >+	printk(KERN_ERR "update from your vendor.                     \n");
> > > > >+	printk(KERN_ERR "=============================================\n");
> 
> I would rather prefer this:
> 
>  BIOS bug, cpu 1, invalid  <register=value> ...

I got the note there is already a macro for this in kernel.h:

 #define FW_BUG          "[Firmware Bug]: "

So, we would have something like:

 [Firmware Bug]: cpu 1, invalid  <register=value> ...

in dmesg.

-Robert

> 
> ... which is a much better information on one line, explains the bug
> and is also better parsable. I intend to implement messages like
> this. So maybe we could find consensus with this or something similar.
> 
> A simple grep of dmesg will then give a list of BIOS bugs.
> 
> -Robert
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

