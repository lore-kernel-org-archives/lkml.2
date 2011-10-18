Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab1JRIhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 04:37:33 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49292 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab1JRIhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 04:37:31 -0400
MIME-Version: 1.0
In-Reply-To: <1318926384.23438.179.camel@vkoul-udesk3>
References: <CABE8wwsQKF9eTTU_N305hR=G5qW4Rzb7Lo-nHbc9RVYwSJVSVA@mail.gmail.com>
	<1317966346.1573.2252.camel@vkoul-udesk3>
	<CAJe_ZhdFA641AzmEmYaz++iRNYQmrHDFmAWOkrwmR_h2ie176g@mail.gmail.com>
	<CABE8wwtcO_su0cF6YocVjAYKhUb=TTwqttfaZkC+RWGLKJimdQ@mail.gmail.com>
	<0CE8B6BE3C4AD74AB97D9D29BD24E55202321E20@CORPEXCH1.na.ads.idt.com>
	<CAJe_ZhfWcUY2ctUFt0iUf2FOfjKj1Aa8hQH5LqFG+bZ+93CcNQ@mail.gmail.com>
	<0CE8B6BE3C4AD74AB97D9D29BD24E55202321F65@CORPEXCH1.na.ads.idt.com>
	<CAJe_ZhfTg17YgyQ9TuKdhtXMu+8W_E2t3cBqZybfarxWu9Zasg@mail.gmail.com>
	<0CE8B6BE3C4AD74AB97D9D29BD24E552023220AC@CORPEXCH1.na.ads.idt.com>
	<CAJe_ZhdBSxvH6Zd8JsoLrerapNbLn0a7Lv6KxwivbFuLaSavyg@mail.gmail.com>
	<20111018074211.GA13483@flint.arm.linux.org.uk>
	<CAJe_ZhdHcsBNT6iX7TJCqoGZMrPwE2BOt06e8M8PHzuDe3Z70w@mail.gmail.com>
	<1318926384.23438.179.camel@vkoul-udesk3>
Date: Tue, 18 Oct 2011 14:07:30 +0530
Message-ID: <CAJe_Zhe9B2n1ZYqSAY9gEjeJn2rx6WOVZ5Tn463=sb_H-k8xew@mail.gmail.com>
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Russell King <rmk@arm.linux.org.uk>,
        "Bounine, Alexandre" <Alexandre.Bounine@idt.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Barry Song <21cnbao@gmail.com>, linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 October 2011 13:56, Vinod Koul <vinod.koul@intel.com> wrote:
> On Tue, 2011-10-18 at 14:00 +0530, Jassi Brar wrote:
>> On 18 October 2011 13:12, Russell King <rmk@arm.linux.org.uk> wrote:
>> > On Tue, Oct 18, 2011 at 11:15:29AM +0530, Jassi Brar wrote:
>> >> On 18 October 2011 02:37, Bounine, Alexandre <Alexandre.Bounine@idt.com> wrote:
>> >> > With item #1 above being a separate topic, I may have a problem with #2
>> >> > as well: dma_addr_t is sized for the local platform and not guaranteed
>> >> > to be a 64-bit value (which may be required by a target).
>> >> > Agree with #3 (if #1 and #2 work).
>> >> >
>> >> Perhaps simply change dma_addr_t to u64 in dmaengine.h alone ?
>> >
>> > That's just an idiotic suggestion - there's no other way to put that.
>> > Let's have some sanity here.
>> >
>> Yeah, I am not proud of the workaround, so I only probed the option.
>> I think I need to explain myself.
>>
>> The case here is that even a 32-bit RapidIO host could ask transfer against
>> 64-bit address space on a remote device. And vice versa 64->32.
> I thought RIO address were always 64 + 2 bits, irrespective of what the
> host system is...
>
No, not always. RIO address could be 32, 48 or 64... with the role extra 2 bits
not very clear.
