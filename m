Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab1KUSfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:35:42 -0500
Received: from service87.mimecast.com ([91.220.42.44]:59489 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1KUSfl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:35:41 -0500
Message-ID: <4ECA99F6.4080207@arm.com>
Date: Mon, 21 Nov 2011 18:35:34 +0000
From: Leif Lindholm <leif.lindholm@arm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bryanh@codeaurora.org" <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        tixy@yxit.co.uk
Subject: Re: [PATCH] arm: Add condition code check to SWP emulator
References: <CAHkRjk6Ynfh9+UbTuAtyiXCOF-yDbTNxi0ikF5ttwHViisZRZA@mail.gmail.com> <1321751070-7932-1-git-send-email-stepanm@codeaurora.org> <20111120084111.GM9581@n2100.arm.linux.org.uk> <CAHkRjk4QZxoVmCsB1A3DVb5_WCUvN5NfbYz8PNL_7np7+wHGzQ@mail.gmail.com>
In-Reply-To: <CAHkRjk4QZxoVmCsB1A3DVb5_WCUvN5NfbYz8PNL_7np7+wHGzQ@mail.gmail.com>
X-OriginalArrivalTime: 21 Nov 2011 18:35:35.0438 (UTC) FILETIME=[5BAD0AE0:01CCA87C]
X-MC-Unique: 111112118353804001
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stepan, thank you for spotting this.

On 11/20/11 10:55, Catalin Marinas wrote:
> On 20 November 2011 08:41, Russell King - ARM Linux
> <linux@arm.linux.org.uk>  wrote:
>> There's a much better algorithm to check this.  See the bottom of
>> arch/arm/nwfpe/fpopcode.c.
>>
>> It would probably be best for there to be a common function for doing
>> this kind of check, rather than having several implementations of it
>> scattered around the kernel.
>
> That's what Leif started doing.

Yes, I put together an RFC patch set based on that.
But rather than duplicating code, I was looking to break it out for 
generic use. And then it was pointed out to me that we also have an 
additional implementation in kernel/kprobes-test.c (test_check_cc()).

I forgot to add the cover message on the set I just submitted to the 
linux-arm-kernel list, but it was meant to say:
---
There are several locations in the kernel where software needs to
inspect the condition codes of trapped instructions. The original
bitmask implementation in the nwfpe code does this in an efficient
manner. This series breaks this code out of nwfpe/fpopcode.{ch} into
a standalone file for opcode operations, and contains additional
patches to kprobes and SWP eumlation to use this interface.
---

/
     Leif

