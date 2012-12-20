Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab2LTKak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 05:30:40 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:35683 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab2LTKad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 05:30:33 -0500
Message-ID: <50D2E8BB.6000108@synopsys.com>
Date: Thu, 20 Dec 2012 16:00:19 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC Patch v1 45/55] ARC: unaligned access emulation
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com> <1352720953-24321-15-git-send-email-vgupta@synopsys.com> <201211121400.13046.arnd@arndb.de> <50D2B75A.3000208@synopsys.com>
In-Reply-To: <50D2B75A.3000208@synopsys.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 December 2012 12:29 PM, Vineet Gupta wrote:
> On Monday 12 November 2012 07:30 PM, Arnd Bergmann wrote:
>> On Monday 12 November 2012, Vineet.Gupta1@synopsys.com wrote:
>>> +
>>> +config ARC_MISALIGN_ACCESS
>>> +       bool "Emulate unaligned memory access (userspace only)"
>>> +       default N
>>> +       help
>>> +         This enables misaligned 16 & 32 bit memory access from user space.
>>> +         Use ONLY-IF-ABS-NECESSARY as it will be very slow and also can hide
>>> +         potential bugs in code
>>
>> parisc and ia64 both have the same feature, and they use sysctl to configure
>> it at run-time. Maybe you should pick one of the two sysctl implementations
>> and hook that up to your implementation as well.
> 
> Sounds like a good idea.
> 
> Looking at your suggestion, the sysctl interface in both of those is for
> slightly different semantics and ARC would possibly need a bit from
> both. So to avoid duplication, I'm proposing following changes to
> kernel/sysctl.c and the generic options selected by respective arches.
> 
> * no_unaligned_warning:CONFIG_IA64 => CONFIG_SYSCTL_ARCH_UNALIGN_NO_WARN
> *unaligned_enabled: __hppa__ => CONFIG_SYSCTL_ARCH_UNALIGN_ALLOW
> 
> If you can think of better(smaller) names, please do let me know :-)
> 
> If we agree in principle, I'll cookup the patches and seek the ACKs from
> ARCH maintainers (assuming my CC list above is right). And to keep
> things simple, we can route the kernel/sysctl.c changes via the ARC
> submission tree.
> 
> Thx,
> Vineet
> 

Sorry for a naive patch submitter question (yes I've already read
SubmittingPatches and googled much already). A lot of times, I see the
"Cc: ..." lines, just below the "Signed-off-by:" lines in the patch -
e.g. https://lkml.org/lkml/2012/10/4/318
Are those added manually - because none of the xxx-cc options to
format-patch or send-email seem to be doing that - unless I missed some.

Context: I have the patch which touches ia64/parisc which I want to send
out and at the same time have those "Cc: lines for the maintainers too"

Thx,
-Vineet

* It's OK to "look" fool once - rather than actually "being" a fool rest
of your life !
