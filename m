Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab0DLC4g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 22:56:36 -0400
Received: from xenotime.net ([72.52.64.118]:54113 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751184Ab0DLC4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 22:56:34 -0400
Message-ID: <33355.71.245.98.113.1271040992.squirrel@www.xenotime.net>
In-Reply-To: <alpine.LFD.2.00.1004120022230.18009@localhost.localdomain>
References: <20100411164701.GA7558@elf.ucw.cz> <20100412185136.GA13171@x200>
    <g2v10f740e81004111158r4d4714a1w23b8521d5d595b29@mail.gmail.com>
    <20100411201426.GC25294@elf.ucw.cz>
    <alpine.LFD.2.00.1004120022230.18009@localhost.localdomain>
Date: Sun, 11 Apr 2010 19:56:32 -0700 (PDT)
Subject: Re: LOCALVERSION_AUTO considered harmful
From: rdunlap@xenotime.net
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: "Pavel Machek" <pavel@ucw.cz>, "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@osdl.org>
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, April 11, 2010 3:24 pm, Thomas Gleixner wrote:
> On Sun, 11 Apr 2010, Pavel Machek wrote:
>
>
>> On Sun 2010-04-11 20:58:58, Geert Uytterhoeven wrote:
>>
>>> On Mon, Apr 12, 2010 at 20:51, Alexey Dobriyan <adobriyan@gmail.com>
>>> wrote:
>>>
>>>> On Sun, Apr 11, 2010 at 06:47:01PM +0200, Pavel Machek wrote:
>>>>
>>>>> @@ -99,6 +98,11 @@ config LOCALVERSION_AUTO
>>>>>         appended after any matching localversion* files, and after
>>>>> the value         set in CONFIG_LOCALVERSION.
>>>>>
>>>>>
>>>>> +       Unfortunately, such finegrained versioning will mean that
>>>>> you will +       not be able to use modules for development; even
>>>>> "make modules"
>>>>> +       will change module versions, making recompiled modules
>>>>> impossible +       to insert into old kernel.
>>>>>
>>>>
>>>> That's conditional BS.
>>>> Turn off CONFIG_MODVERSIONS already.
>>>>
>>>
>>> Yeah, I disabled it ages ago. Even then (before git, probably even
>>> before bitkeeper) I had hard times inserting modules...
>>>
>>
>> I _had_ it off
>>
>>
>> # CONFIG_MODVERSIONS is not set
>>
>>
>> It seems some checking survives CONFIG_MODVERSIONS unset and that
>> checking is strict enough to refuse module load after one "make modules"
>> with LOCALVERSION_AUTO on...
>
> So instead of fixing the CONFIG_MODVERSIONS=n case you go the easy way
> of killing LOCALVERSION_AUTO ? Brilliant.

Pavel's original example (afaik) was on April 5:
Subject: 2.6.34-rc3: Can't insmod after make, because versions now differ?!

Apr  5 07:33:16 amd kernel: udlfb: version magic
'2.6.34-rc3-00345-ge8240f9-dirty SMP mod_unload CORE2 ' should be
'2.6.34-rc3-00344-g548fc0a-dirty SMP mod_unload CORE2 '


So what do you suggest?  If the "magic" strings contain "-dirty ",
then ignore that and the 2 preceding hyphen-separated fields?

That could be dangerous if some kernel internal structures have changed.
I.e., user/developer beware.

Maybe ignore those strings iff some override has been set somewhere?

---
~Randy

