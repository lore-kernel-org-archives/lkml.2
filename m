Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2GFA4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 20:56:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64910 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab2GFA4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 20:56:39 -0400
MIME-Version: 1.0
In-Reply-To: <30233.1341535279@neuling.org>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com> <20120625150722.8cd4f45d.akpm@linux-foundation.org>
 <20120625235531.GB3652@kroah.com> <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
 <20120626002307.GA4389@kroah.com> <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
 <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
 <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com>
 <1340726856.977.6.camel@mop> <22482.1341471787@neuling.org>
 <CAPXgP11=o5WB4WejaQCSCL-+5e4sL7tfVz_r3Khyrq3SyrMvsA@mail.gmail.com>
 <CAPXgP13u769nSvUdS1iqiVCsxG5nsQd7bNT1=-eNw156U-kPkQ@mail.gmail.com>
 <16043.1341483625@neuling.org> <CAPXgP11+j+fDexHHmAZbBBidtrydrpWeh3DGWOhkuoybNj9skA@mail.gmail.com>
 <1341492628.834.3.camel@mop> <30233.1341535279@neuling.org>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 6 Jul 2012 02:56:19 +0200
Message-ID: <CAPXgP12_F_H2XPpo2wFmb-u3jBdV__=h67R-LVYbqHuLh7tqLg@mail.gmail.com>
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

On Fri, Jul 6, 2012 at 2:41 AM, Michael Neuling <mikey@neuling.org> wrote:

>> > Does this happen only very early during bootup, or also later when the
>> > box fully initialized?
>
> I'm seeing during boot but not later (xmon (ppc kernel debugger) doesn't
> see it if I do 'echo x > /proc/sysrq-trigger') .  I wouldn't say
> it's "very early boot".  It's a secondary CPU coming up and the primary
> is waiting for it.  We've already configured the console when this
> happens.

Sounds like an early boot console.

>> > The output of 'dmesg' later looks always correct, right?
>
> No, dmesg also has the extra new lines: eg
>
> <4>NIP: c00000000004e234 LR: c00000000004e230 CTR: 0000000000000000
> <4>REGS: c00000007c3b7b50 TRAP: 0700   Tainted: G        W     (3.5.0-rc4-mikey)
> <4>MSR: 9000000000021032
> <4><
> <4>SF
> <4>,HV
> <4>,ME
> <4>,IR
> <4>,DR
> <4>,RI
> <4>>
> <4>  CR: 28000042  XER: 22000000

Can you please paste the output of /dev/kmsg of this section? So we
can see the timestamps and what really went into the record buffer.

>> Could you possibly try this patch?
>
> Sorry, doesn't help.  It also reprints the entire boot log to the
> console once the console get inited.

Which is the normal behaviour to do that, right? We should not have
touched any of that logic.

Thanks,
Kay
