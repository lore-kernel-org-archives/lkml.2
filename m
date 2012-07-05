Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab2GELrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 07:47:48 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:33875 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2GELrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 07:47:47 -0400
MIME-Version: 1.0
In-Reply-To: <16043.1341483625@neuling.org>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com> <20120625150722.8cd4f45d.akpm@linux-foundation.org>
 <20120625235531.GB3652@kroah.com> <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
 <20120626002307.GA4389@kroah.com> <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
 <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
 <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com>
 <1340726856.977.6.camel@mop> <22482.1341471787@neuling.org>
 <CAPXgP11=o5WB4WejaQCSCL-+5e4sL7tfVz_r3Khyrq3SyrMvsA@mail.gmail.com>
 <CAPXgP13u769nSvUdS1iqiVCsxG5nsQd7bNT1=-eNw156U-kPkQ@mail.gmail.com> <16043.1341483625@neuling.org>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 5 Jul 2012 13:47:26 +0200
Message-ID: <CAPXgP11+j+fDexHHmAZbBBidtrydrpWeh3DGWOhkuoybNj9skA@mail.gmail.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
To: Michael Neuling <mikey@neuling.org>
Cc: linuxppc-dev@ozlabs.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 12:20 PM, Michael Neuling <mikey@neuling.org> wrote:

> I can only make 2) happen on SMP.  It's when the second CPU is coming up
> and it's printing something.  The first CPU isn't printing anything at
> this stage (there is no garbled console here) so I don't think it's a
> race.  I see it consistently in show_regs().  Every printk without a
> newline.  ie I get this:
> ---
> NIP: c000000000048164 LR: c000000000048160 CTR: 0000000000000000
> REGS: c00000007e59fb50 TRAP: 0700   Tainted: G        W     (3.5.0-rc5-mikey)
> MSR: 9000000000021032
> <
> SF
> ,HV
> ,ME
> ,IR
> ,DR
> ,RI
>>
>   CR: 28000042  XER: 22000000
> SOFTE: 0
> CFAR: c0000000007402f8
> TASK = c00000007e56bb40[0] 'swapper/1' THREAD: c00000007e59c000
>  CPU: 1
> ---
>
> It's consistent for printks without newlines in show_regs().  MSR
> through to XER should all be on the same line.

I see. Something to fix then, I'll have a look.

Does this happen only very early during bootup, or also later when the
box fully initialized?

The output of 'dmesg' later looks always correct, right?

Thanks,
Kay
