Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2GHXcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 19:32:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab2GHXcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 19:32:14 -0400
Message-ID: <4FFA1871.7070501@redhat.com>
Date: Sun, 08 Jul 2012 19:32:01 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@inai.de>
CC: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com> <201207071927.13135.arnd@arndb.de> <4FF93C99.80203@redhat.com> <alpine.LNX.2.01.1207082229020.22454@frira.zrqbmnf.qr>
In-Reply-To: <alpine.LNX.2.01.1207082229020.22454@frira.zrqbmnf.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2012 04:31 PM, Jan Engelhardt wrote:
> 
> On Sunday 2012-07-08 09:54, Jon Masters wrote:
>>
>> FWIW I actually really like the aarch64 name (but you know that already
>> :) ). I think it clearly spells out that this is not just a 64-bit
>> extension to the existing 32-bit ARM Architecture, it is a new (inspired
>> by ARM) architecture.
> 
> IA64 also has a "arch" inside, and look where it took them.
> (The contemporary platform winner came to be x86_64 instead
> of what Intel had hoped back then.)

There is a difference here. Treading carefully to avoid upsetting
anyone, but IA64 was a complete departure in many ways from x86, whereas
AMD had something that was backward compatible more directly, and the
market reacted. In this case, it's different because of many different
things - an ARMv8 processor will also be a great ARMv7 processor (albeit
a few things nobody ever used are deprecated, but still supported), the
makeup of the existing market (ARM doesn't need a 30 year backward
compatibility story on the desktop or server and mobile platforms have
moved on to higher level stacks), the dynamics of the licensing model,
and the fact that compiled code is less relevant. I would say let's not
draw too many comparisons with x86/IA64/x86_64.

AArch64 is not a complete departure for ARM. It's a 32-bit wide RISC
instruction set that is very clean and draws on industry lessons from
the past several decades to fix (AFAICS) pretty much anything that was
really wrong with A32/T32 (ARM). They already did a lot in ARMv7 in
terms of deprecating older features, but it's nice (from an
implementation point of view) to have a chance to remove things that no
longer make sense - like many conditional instructions, modelling real
world software to optimize the encoding formats, etc. - and clean up
stuff like explicit knowledge of the pipeline depth of ten years ago.

I am very keen on the opportunity here for things like a single zImage
and a standardized platform on day one. By the time the first hardware
ships, I'm hoping that we've got a nice set of standards that everyone
can follow - all things that are needed to do AArch64 in bigger systems.

Jon.
