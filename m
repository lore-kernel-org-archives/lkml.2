Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab0FEAFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 20:05:21 -0400
Received: from crca.org.au ([74.207.252.120]:52455 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757454Ab0FEAFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 20:05:20 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C0994B9.6070406@crca.org.au>
Date: Sat, 05 Jun 2010 10:05:13 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [SUSPECTED SPAM] Re: [linux-pm] Proposal for a new algorithm
 for reading & writing a hibernation image.
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com>
In-Reply-To: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 04/06/10 00:50, Pavel Machek wrote:
> "Nigel Cunningham"<ncunningham@crca.org.au>  wrote:
>> On 30/05/10 15:25, Pavel Machek wrote:
>>> Hi!
>>>
>>>> 2. Prior to writing any of the image, also set up new 4k page tables
>>>> such that an attempt to make a change to any of the pages we're about to
>>>> write to disk will result in a page fault, giving us an opportunity to
>>>> flag the page as needing an atomic copy later. Once this is done, write
>>>> protection for the page can be disabled and the write that caused the
>>>> fault allowed to proceed.
>>>
>>> Tricky.
>>>
>>> page faulting code touches memory, too...
>>
>> Yeah. I realise we'd need to make the pages that are used to record the
>> faults be unprotected themselves. I'm imagining a bitmap for that.
>>
>> Do you see any reason that it could be inherently impossible? That's
>> what I really want to know before (potentially) wasting time trying it.
>
> I'm not sure it is impossible, but it certainly seems way too complex to be
> practical.

Oh. I thought this bit would actually be quite simple if it was 
technically possible. I'm more concerned about the potential for 
difficulties with restoring the state successfully.

> 2mb pages will probably present a problem, as will bat mappings on powerpc.

I have the idea that 2MB pages are only used for the kernel text and 
read only data. Is that right? If so, perhaps they can just be 
unconditionally copied (so that we can restore the image if a different 
kernel is booted) and wouldn't need any page protection. Does that sound 
right?

 From the small bit I've read about bat mappings on the powerpc, it 
looks like they could be replaced with normal ptes while doing 
hibernation. More than willing to be told I don't understand what's 
going on there :)

Nigel
