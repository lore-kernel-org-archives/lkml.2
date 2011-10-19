Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab1JSXh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:37:27 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:37755
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754680Ab1JSXhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:37:25 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK9371K1432N98dKzz1202hzzz2fh668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
X-FB-SS: 0,
Message-ID: <4E9F5F1B.1020106@am.sony.com>
Date: Wed, 19 Oct 2011 16:36:59 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ARM 4Kstacks: introduction
References: <4E9E0B71.9020708@am.sony.com> <20111019073547.GR21648@n2100.arm.linux.org.uk>
In-Reply-To: <20111019073547.GR21648@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2011 12:35 AM, Russell King - ARM Linux wrote:
> On Tue, Oct 18, 2011 at 04:27:45PM -0700, Tim Bird wrote:
>> I'm about to submit a set of patches (really pretty small)
>> to add 4K stack support to ARM (defaulted to 'N').
>>
>> This has been kicking around in my Sony tree for a few years,
>> and it's about time to mainline it.  The first patch is
>> the actual 4KSTACKS patch.  See subsequent patches
>> for tools to help with stack reduction to avoid the problems
>> that apparently led to the removal of this feature on x86.
> 
> This isn't a good idea - if the feature has been abandoned on x86,
> people aren't going to be soo concerned about the stack usage of
> each function.  They're going to accept that there's more stack
> space available, and we'll see code paths that start expecting that.

Well, the difference in size is not an order of magnitude.  Current
stacks are only twice as big as what this feature optionally allows.
So people really shouldn't go crazy with their stack usage.

Granted we're already seeing a bit of stack bloat, but IMHO this should
be nipped in the bud.  If the stack grows a lot more, it will likely
need to shift to 16K, which would REALLY be costly on machines
with lots of threads and low memory.

I don't want to give up on a small-footprint Linux so easily,
and the discipline for keeping stacks small is probably good
for code hygiene anyway.

> If we switch to 4K stacks, the problems of stack usage become ours.
> Do we have the capacity to be able to address these issues as they
> crop up?

Since it's optional, it would become the problem of the people
who actually use the option.  If you think tracking down stack
abusers is going to be a pain, just don't do it.

If I do it, and get pushback, then I'll make the case to individual
function authors, and we'll see what happens from there.  As it is,
this patch has been useful for me, and continues to be useful
even in the current kernel version, with no other changes
required in mainline.

Having said this, I've written a tool to rather easily identify
the functions which use the most stack, and so far the routines
I've looked at have had rather simple solutions.  It almost always
boils down to a single big data item on the stack.

I can understand if people don't want to take patches which
unconditionally limit their stack usage - especially if there's
a performance impact. But I don't see much rationale for not
limiting their stack usage conditionally (that is, do something
slightly different on #ifdef CONFIG_4KSTACKS).  If people
object to even that, then I'll maintain those patches out of
tree, if they're really needed.

Once again, our products work even without such patches now,
based on the configs we're using and the user-space we're running.
Note that this is defaulted to 'N', so no one should be negatively
affected unless they opt in.

So, I understand your point.  I would, however, like to have
this patch applied, and then deal with any problems as they
come up, rather than preemptively kill the feature on speculative
problems.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

