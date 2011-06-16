Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab1FPT0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 15:26:13 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:47307 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab1FPT0K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 15:26:10 -0400
Message-ID: <4DFA58B4.5030101@ahsoftware.de>
Date: Thu, 16 Jun 2011 21:25:40 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
        Rabin Vincent <rabin@rab.in>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing
 the packed attribute
References: <Pine.LNX.4.44L0.1106161308310.2204-100000@iolanthe.rowland.org> <201106161955.50972.arnd@arndb.de>
In-Reply-To: <201106161955.50972.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.06.2011 19:55, schrieb Arnd Bergmann:
> On Thursday 16 June 2011, Alan Stern wrote:
>>
>> On Thu, 16 Jun 2011, Alexander Holler wrote:
>>
>>> In commit 139540170d9d9b7ead3caaf540f161756b356d56 the attribute
>>> packed is removed from the structs which are used to access the EHCI-registers.
>>>
>>> This is done to circumvent a problem with gcc 4.6, which might access members of
>>> packed structs on a byte by byte basis. But using packed, aligned(4) fixes that
>>> too and is imho the better solution. Otherwise (without packed) the compiler would be free
>>> to choose whatever alignment he thinks fits best, which might be e.g. 8-byte on 64-bit machines.
>>
>> Is that really true?
>
> No.
>
>> I thought the compiler was not allowed to insert
>> padding if the natural alignment of the data types didn't require any.
>
> It's architecture dependent. The alignment of the structure is the maximum alignment
> of its members, so it gets to be 8 bytes if there is a 64 bit member in the struct
> on most architectures, but 4 bytes on x86.

Hmm, sorry, but that sentence just says something about the alignment of 
the structure itself and nothing about the alignment of it's members or 
do I understand something wrong?

I've had a look at c99 again, and in addition to the two points in c99 I 
mentioned in the mail before (6.7.2.1 13 and 6.7.2.1. 15), I've only 
found the following on that topic:

6.7.2.1 12  Each non-bit-ﬁeld member of a structure or union object is 
aligned in an implementationdeﬁned manner appropriate to its type.

And, under "J.1 Unspecified behaviour":

Many aspects of the representations of types (6.2.6).

I even haven't found anything which says something about the alignment 
of a structure itself. But I'm no compiler expert and I look only seldom 
at c99 and usually try to avoid such aspects as the one we are talking 
about. ;)

For me that means that I understand that when packed(,aligned(4)) is 
used, it's pretty sure, that there is no padding inbetween the members 
of e.g. struct ehci_regs. But without I'm unsure, so I would avoid that.

That aligned(4) is necessary (for ARM) is only a workaround because of 
the implementation of readl(), at least that is how I understood the 
discussion. But that is discussed elsewhere and don't want to take part 
in that discussion (and can't).

Regards,

Alexander

