Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750880Ab0E1EF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 00:05:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64510 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab0E1EF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 00:05:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kpYrZ8vqE7gQYjWmRbbGZiKCN8RsrYylEEAaCh2xT8V0c+1JMYr0Kn46qRNhJhIe6T
         cHYScXbgQf5zdU83l/AqLOO44AagElXiM73GMRXPtJ2CeqE8+rbjBsQ4LoQaE64H31qe
         n3zVLO4AA4vkbl3VtMGF/BKseO7U+1qJIDBv4=
Message-ID: <4BFF4120.7030501@gmail.com>
Date: Thu, 27 May 2010 22:05:52 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Bastien Nocera <hadess@hadess.net>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
References: <20100513075728.GF30110@core.coreip.homeip.net> <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org> <20100513160117.GB22238@core.coreip.homeip.net> <alpine.LFD.2.00.1005130943460.3711@i5.linux-foundation.org> <4BFE0FAB.9040009@gmail.com> <alpine.LFD.2.00.1005270956380.3689@i5.linux-foundation.org> <AANLkTimkI2rLOO2vaPFBQUbzr5t0pAQGQ5R5noTOBp4K@mail.gmail.com> <alpine.LFD.2.00.1005271744410.11382@i5.linux-foundation.org> <4B59D6F4-825C-4851-929F-DCA28A343B23@gmail.com>
In-Reply-To: <4B59D6F4-825C-4851-929F-DCA28A343B23@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2010 07:03 PM, Dmitry Torokhov wrote:
> On May 27, 2010, at 5:46 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>
>>
>>
>> On Thu, 27 May 2010, Robert Hancock wrote:
>>>
>>> It's highly unlikely that they are incomplete in this respect, as
>>> since I mentioned, Windows would fail to recognize the PS/2 controller
>>> that people would expect to work, which would most likely get
>>> noticed..
>>
>> Did you miss the part where I actually quoted my own modern Core i5
>> machine that _does_ have a keyboard controller, and _does_ have a
>> keyboard
>> port, and that does _not_ mention them in the PnP tables?
>
> Except that it _does_. But _our_ ACPI implementation drops all inactive
> devices so our PNP layer does not see your mouse and keyboard ports.

That's likely true - my machine works similarly, it doesn't list any 
keyboard or mouse controller in PnP and Windows doesn't see them if no 
device is plugged in at boot. The PnP devices for them are still 
defined, but they are marked as disabled (the _STA method in the DSDT 
returns 0). So we could likely detect that case and say "hey, the device 
is there, just turned off, maybe we should try and see if it works 
anyway". Whereas if the device is not there at all, we'd likely be 
better off leaving it alone, by default anyway.

>
>
>>
>>> I think this is a case where it has to be trusted, because that's what
>>> Windows does.
>>
>> The thing is, Windows isn't used for things like headless machines. Which
>> we went over extensively in the thread. There's a _reason_ why Linux
>> probes the dang thing.
>
>

