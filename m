Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab2GII53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 04:57:29 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:61511 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2GII52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 04:57:28 -0400
MIME-Version: 1.0
In-Reply-To: <4FFA3B71.3020105@jonmasters.org>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
 <201207071927.13135.arnd@arndb.de> <4FF93C99.80203@redhat.com>
 <4FF9D1E9.4050504@jonmasters.org> <20120708172419.2b2f2713@pegasus.ausil.us> <4FFA3B71.3020105@jonmasters.org>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 9 Jul 2012 09:57:07 +0100
X-Google-Sender-Auth: uT1nNzu6XWR7kxCwArxfYW2Jyhg
Message-ID: <CAHkRjk7yuAuijEMQ_cfA6DAoFXUOKuV7jBBnZ_Dfspj-KCvbig@mail.gmail.com>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
To: Jon Masters <jonathan@jonmasters.org>
Cc: Dennis Gilmore <dgilmore@fedoraproject.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On 9 July 2012 03:01, Jon Masters <jonathan@jonmasters.org> wrote:
> On 07/08/2012 06:24 PM, Dennis Gilmore wrote:
>> I know that the architecture really is new but thats not really clear
>> by adding AArch32 into the mix to represent 32 bit arm as ARM has done
>> or by calling it armv8. There is enough way to confuse them already why
>> confuse things more by adding yet another variable that is AArch64.
>> - From my and most of the other Fedora developers that i've discussed it
>> with its more like reluctant acceptance of AArch64 than thinking is a
>> good idea.
>
> btw, for clarification of anyone who is confused by the names...the new
> architecture is ARMv8. The 64-bit state is AArch64, during which the
> processor executes A64 instructions. The 32-bit state is AArch32, during
> which the processor executes either A32 ("ARM" version 7+) or T32
> ("Thumb" - I guess Thumb2+ really due to some of deprecation)
> instructions. I've noticed that there appears to be a clarification
> effort in which AArch64 is used as an architecture name when ARMv8 would
> be confusing, which is most of the time if you don't know whether you're
> referring to the new A64 instruction set or the older ones.

Thanks for clarifying this. I deliberately try not to use ARMv8 name
to avoid confusion. Indeed, the new architecture is ARMv8 (following
the ARM architectures numbering scheme). It has an AArch64 mode (with
new exception model, new ISA) and an *optional* AArch32 mode (pretty
much the same as ARMv7). The key here is that AArch32 is *optional* -
we can have it at all levels, only some (e.g. EL0 - user) or not at
all.

These two modes also share very little, from a software perspective
it's pretty much some register banking to allow compat mode support
(e.g. you can read the AArch32 R0 register from the lower half of
AArch64 X0). The AArch32 mode cannot switch by itself to an AArch64
mode, this requires taking an exception (can be SVC) to a higher level
that actually runs in AArch64 mode.

On an ARMv8 system, if it supports AArch32 at EL1 (kernel) you can run
an ARMv7 kernel, and that's good for virtualisation. But I have
*absolutely* no plans to support an AArch32 kernel for ARMv8 SoCs.

-- 
Catalin
