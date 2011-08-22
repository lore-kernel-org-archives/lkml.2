Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab1HVJnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 05:43:52 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48963 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1HVJns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 05:43:48 -0400
MIME-Version: 1.0
In-Reply-To: <20110819211402.GB12654@gallagher>
References: <1313777004-4716-1-git-send-email-nbowler@elliptictech.com>
 <20110819181514.GA12654@gallagher> <20110819192638.GA21043@elliptictech.com> <20110819211402.GB12654@gallagher>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 22 Aug 2011 10:43:26 +0100
X-Google-Sender-Auth: 63WVv1sxgAMpC_kADJNT1j8YuXQ
Message-ID: <CAHkRjk6Fq+1b_uM+DFACS1QVd7B6_1XhqRw-27i88U1VyvLk+Q@mail.gmail.com>
Subject: Re: [PATCH RFC] ARM: vexpress: Use assembler mnemonic for WFI in platform_do_lowpower.
To: Jamie Iles <jamie@jamieiles.com>
Cc: Nick Bowler <nbowler@elliptictech.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 August 2011 22:14, Jamie Iles <jamie@jamieiles.com> wrote:
> On Fri, Aug 19, 2011 at 03:26:38PM -0400, Nick Bowler wrote:
>> On 2011-08-19 19:15 +0100, Jamie Iles wrote:
>> > On Fri, Aug 19, 2011 at 02:03:24PM -0400, Nick Bowler wrote:
>> [...]
>> > > -         /*
>> > > -          * here's the WFI
>> > > -          */
>> > > -         asm(".word      0xe320f003\n"
>> > > +         asm("wfi\n"
>> > >               :
>> > >               :
>> > >               : "memory", "cc");
>> >
>> > There's a wfi() macro defined in arch/arm/include/asm/system.h that
>> > could be used here.
>>
>> Indeed, thanks for pointing that out.
>>
>> I'm a little wary, however: the wfi macro does not include the "cc"
>> clobber that this code has currently, and I don't know what the
>> implications of removing it are.  There appears to be no current
>> users of the wfi macro.
>
> As far as I can tell from the ARM ARM, the instruction shouldn't alter
> the condition flags so the cc clobber shouldn't be necessary.

I also don't see why we need the 'cc' flag in here. Just use the wfi() macro.

-- 
Catalin
