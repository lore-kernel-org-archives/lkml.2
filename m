Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab0DUNCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 09:02:05 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55801 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab0DUNCB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 09:02:01 -0400
Date: Wed, 21 Apr 2010 15:02:12 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] Mass Storage Gadget: Handle eject request
In-reply-to: <w2vfb5cec441004210535j3cd72f64gd2328242eeca21a1@mail.gmail.com>
To: Chouteau Fabien <fabien.chouteau@gmail.com>, linux-usb@vger.kernel.org
Cc: Fabien Chouteau <fabien.chouteau@barco.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org
Message-id: <op.vbijtyjo7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <1271752450-13964-1-git-send-email-fabien.chouteau@gmail.com>
 <op.vbh83qxw7p4s8u@pikus>
 <w2vfb5cec441004210535j3cd72f64gd2328242eeca21a1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2010/4/21 Michał Nazarewicz <m.nazarewicz@samsung.com>
>> Clearly, suspend seems like a state of the mass storage function
>> as a whole rather then attribute of each logical unit so I think
>> it'll be better to make it global for the mass storage function
>> rather then per-LUN.
>>
>> Even more so, it's a state of the whole gadget so in my opinion the
>> whole code should be moved the the gadget rather then kept in
>> a function!
>>
>> Going even further, I would propose an sysfs entry to be added to
>> the composite framework as a single generic interface rather then
>> hacking it in each gadget/function that might need to export this
>> information to user space.
>>
>> This provided that there is no easy way of gaining that information
>> in user space through same other sysfs entry.

On Wed, 21 Apr 2010 14:35:57 +0200, Chouteau Fabien <fabien.chouteau@gmail.com> wrote:
> You're right, the suspended state should be handled in the composite
> framework, I'm going resend the patch with this modification.

That'll be great.

> I have a question about the mass/file storage gadget, why is there a
> g_mass_storage gadget and a g_file_storage gadget? Code and feature seems
> redundant.

My Mass Storage Function is relatively young and thus not so mature as
File Storage Gadget.  As a matter of fact, if one were to choose between
FSG and MSG then FSG is probably a better choice.  MSG was provided to
test the MSF and show how to write composite gadgets using it.  The
strength of MSF is of course that it is a composite function hence can
be mixed with other functions.  Maybe in the future, when MSF (and MSG)
proves stability, FSG will be removed from the kernel but for now it
has been decided to let it be there.  You may refer to my discussion with
Alan when I was posting the code.

> btw, the eject code of this patch comes from file_storage.c

It may be a good idea to point that in a comment.

Or maybe even extract the common do_*() functions to storage_common.c.
I always felt like the do_*() functions should be in the
storage_common.c but unfortunately there are many subtle differences,
which make those functions differ in little details between MSF and
FSG.

-- 
Best regards,                                           _     _
  .o. | Liege of Serenely Enlightened Majesty of       o' \,=./ `o
  ..o | Computer Science,  Michał "mina86" Nazarewicz     (o o)
  ooo +---[mina86@mina86.com]---[mina86@jabber.org]---ooO--(_)--Ooo--
