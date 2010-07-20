Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580Ab0GTOjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 10:39:22 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37234 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758499Ab0GTOjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 10:39:21 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Tue, 20 Jul 2010 16:40:38 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
In-reply-to: <Pine.LNX.4.44L0.1007201007510.1631-100000@iolanthe.rowland.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
Message-id: <op.vf5cd0ap7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <Pine.LNX.4.44L0.1007201007510.1631-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010 16:08:53 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 20 Jul 2010, [utf-8] MichaÅ‚ Nazarewicz wrote:
>
>> > On Mon, 19 Jul 2010, [utf-8] Michalâ€š Nazarewicz wrote:
>> >> 1/3: http://lkml.org/lkml/2010/7/8/317
>> >> 	Adds serial to mass storage gadget and g_multi introducing
>> >> 	fsg_string_serial_fill() macro used by abovementioned
>> >> 	gadgets and file storage gadget.
>>
>> On Mon, 19 Jul 2010 19:06:32 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
>> > Ah, yes.  My personal taste would be to write fsg_string_serial_fill_n
>> > as an inline routine instead of as a macro, and not try to make it
>> > separate from fsg_string_serial_fill.
>>
>> Not sure what you meant by "make it separate from fsg_string_serial_fill".
>
> I mean have a single function, called "fsg_string_serial_fill", instead
> of two separate macros called "fsg_string_serial_fill" and
> "fsg_string_serial_fill_n".

I wanted to keep fsg_string_serial_fill() as a macro so that it can
use ARRAY_SIZE() on the first argument to check the size.  If there
was a single function it would have to explicitly take the length of
the destination array as an argument -- that's what the *_n() function
is for.

The rationale is that not having to use ARRAY_SIZE() is, well,
simpler. ;)

Basically, what you are proposing is to remove the
fsg_string_serial_fill() macro and leave only the *_n() changed to
an inline function and force all callers use sizeof/ARRAY_SIZE().

Am I getting that right?  Personally, I'd leave things like they are
changing the *_n() to a function.  What do you think?

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
