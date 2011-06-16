Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab1FPULQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:11:16 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:49752 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293Ab1FPULM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:11:12 -0400
Message-ID: <4DFA634D.6000907@ahsoftware.de>
Date: Thu, 16 Jun 2011 22:10:53 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Arnd Bergmann <arnd@arndb.de>, gregkh@suse.de,
        Rabin Vincent <rabin@rab.in>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing
 the packed attribute
References: <Pine.LNX.4.44L0.1106161541260.1697-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106161541260.1697-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.06.2011 21:46, schrieb Alan Stern:
> On Thu, 16 Jun 2011, Alexander Holler wrote:
>
>>>> I thought the compiler was not allowed to insert
>>>> padding if the natural alignment of the data types didn't require any.
>>>
>>> It's architecture dependent. The alignment of the structure is the maximum alignment
>>> of its members, so it gets to be 8 bytes if there is a 64 bit member in the struct
>>> on most architectures, but 4 bytes on x86.
>>
>> Hmm, sorry, but that sentence just says something about the alignment of
>> the structure itself and nothing about the alignment of it's members or
>> do I understand something wrong?
>
> We're talking about padding, not alignment.  Obviously these two
> concepts are related, since fields with differing alignment
> requirements sometimes force the compiler to insert padding.  But they
> aren't the same thing.
>
> The question is whether gcc will insert padding in a structure that
> doesn't need it.  The kernel depends on peculiarities of gcc in many
> ways; basing your strategy on what the C99 spec says is not always a
> good idea.
 >
>> For me that means that I understand that when packed(,aligned(4)) is
>> used, it's pretty sure, that there is no padding inbetween the members
>> of e.g. struct ehci_regs. But without I'm unsure, so I would avoid that.
>>
>> That aligned(4) is necessary (for ARM) is only a workaround because of
>> the implementation of readl(), at least that is how I understood the
>> discussion. But that is discussed elsewhere and don't want to take part
>> in that discussion (and can't).
>
> Hmmm.  I won't say that ((packed,aligned(4))) is wrong.  But it's not
> clearly necessary either.

Maybe I should have added a "cosmetic:" in front of the subject of the 
patch. ;)

Using packed doesn't seem to be necessary (at least not with those 
versions of gcc I'm using here), I've tried both versions (on arm, 
without packed and with packed, aligned(4)) and both are working. I've 
only posted the patch because I found the usage of packed, aligned(4) 
much clearer than without packed. And It might help avoiding such 
discussions like this with people like me who aren't that deep involved 
in gcc-specific implementation details. ;)

Anyway, feel free to nack that patch. I don't really care and just 
thought I should post it (e.g. as an alternative to removing that packed).

Regards,

Alexander
