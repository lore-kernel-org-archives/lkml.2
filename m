Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab0FEDhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 23:37:42 -0400
Received: from crca.org.au ([74.207.252.120]:53079 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162Ab0FEDhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 23:37:41 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C09C662.2020705@crca.org.au>
Date: Sat, 05 Jun 2010 13:37:06 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Pavel Machek <pavel@ucw.cz>, pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [SUSPECTED SPAM] Re: [linux-pm] Proposal for a new algorithm
 for reading & writing a hibernation image.
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com>	 <1275694775.3853.29.camel@maxim-laptop>  <4C09930E.20306@crca.org.au>	 <1275698169.10045.8.camel@maxim-laptop> <1275698720.10045.15.camel@maxim-laptop>
In-Reply-To: <1275698720.10045.15.camel@maxim-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 05/06/10 10:45, Maxim Levitsky wrote:
> On Sat, 2010-06-05 at 03:36 +0300, Maxim Levitsky wrote:
>> On Sat, 2010-06-05 at 09:58 +1000, Nigel Cunningham wrote:
>>> Hi Maxim.
>>>
>>> On 05/06/10 09:39, Maxim Levitsky wrote:
>>>> On Thu, 2010-06-03 at 16:50 +0200, Pavel Machek wrote:
>>>>>
>>>>> "Nigel Cunningham"<ncunningham@crca.org.au>   wrote:
>>>>>
>>>>>> Hi.
>>>>>>
>>>>>> On 30/05/10 15:25, Pavel Machek wrote:
>>>>>>> Hi!
>>>>>>>
>>>>>>>> 2. Prior to writing any of the image, also set up new 4k page tables
>>>>>>>> such that an attempt to make a change to any of the pages we're about to
>>>>>>>> write to disk will result in a page fault, giving us an opportunity to
>>>>>>>> flag the page as needing an atomic copy later. Once this is done, write
>>>>>>>> protection for the page can be disabled and the write that caused the
>>>>>>>> fault allowed to proceed.
>>>>>>>
>>>>>>> Tricky.
>>>>>>>
>>>>>>> page faulting code touches memory, too...
>>>>>>
>>>>>> Yeah. I realise we'd need to make the pages that are used to record the
>>>>>> faults be unprotected themselves. I'm imagining a bitmap for that.
>>>>>>
>>>>>> Do you see any reason that it could be inherently impossible? That's
>>>>>> what I really want to know before (potentially) wasting time trying it.
>>>>>
>>>>> I'm not sure it is impossible, but it certainly seems way too complex to be
>>>>> practical.
>>>>>
>>>>> 2mb pages will probably present a problem, as will bat mappings on powerpc.
>>>>
>>>>
>>>> Some time ago, after tuxonce caused medium fs corruption twice on my
>>>> root filesystem (superblock gone for example), I was thinking too about
>>>> how to make it safe to save whole memory.
>>>
>>> I'd be asking why you got the corruption. On the odd occasion where it
>>> has been reported, it's usually been because the person didn't set up
>>> their initramfs correctly (resumed after mounting filesystems). Is there
>>> any chance that you did that?
> I didn't use any initramfs.
> I did use kernel modesetting and nouveau.
> I used ext4.
> The corruption happened after normal suspend.

What's 'normal suspend'?

> I replaces swsusp with tuxonice.
>
> Anyway, some more or less verified method must be used to save memory
> because fs corruption is too scary thing to have.

Agreed.

> I can't say it scared me that much 'cause I had dealt with worse
> corruptions before, but being thrown to  "grub rescue>" on boot is not
> pleasant thing to see.

Oh, I agree and don't want anyone to ever experience corruption because 
of TuxOnIce. Unfortunately my wishes don't just happen :)

Nigel
