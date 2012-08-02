Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab2HBV5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 17:57:21 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:46025 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752217Ab2HBV5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 17:57:17 -0400
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX19RIokJFqNRjtbRqWNPMXjyUGu2RCALBmvfN4qchN
	Y1wQkGhdzEX1ZY
Message-ID: <501AF7B2.50601@gmx.net>
Date: Thu, 02 Aug 2012 23:57:06 +0200
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120623 Thunderbird/10.0.5
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Borislav Petkov <bp@alien8.de>, bhelgaas@google.com, lenb@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH V3 0/3] PNP: Allow PNP resources to be disabled (interface)
References: <50158321.4030007@gmx.net> <201208022209.16015.rjw@sisk.pl> <501AE10E.6080606@gmx.net> <201208022340.16948.rjw@sisk.pl>
In-Reply-To: <201208022340.16948.rjw@sisk.pl>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/12 23:40, Rafael J. Wysocki wrote:

> On Thursday, August 02, 2012, Witold Szczeponik wrote:
>> On 02/08/12 22:09, Rafael J. Wysocki wrote:
>>> On Monday, July 30, 2012, Borislav Petkov wrote:
>>>> On Sun, Jul 29, 2012 at 09:31:53PM +0200, Witold Szczeponik wrote:

[... snip ...]

>>>>
>>>> Shouldn't this be rather "disable_irq" or something which is a single
>>>> word and thus would simplify parsing a lot?
>>>
>>> Or just "irq", which isn't going to be confused with anything else it seems.
>>>
>>> Thanks,
>>> Rafael
>>>
>>
>> Hi Rafael, 
>>
>> the code in "drivers/pnp/interface.c" implements a (non-trivial) interface
>> which accepts the keywords "disable", "activate", "fill", "auto", "clear",
>> and "get" as simple, one word commands.  The remaining "set" command is
>> more complex, for it determines which resource is to be set ("io", "mem",
>> "irq", "dma", and "bus"), followed by the actual value(s) of this resource
>> (e.g., "0x0200-0x021f", or "7"). 
>>
>> The patch series allows to use the term "disabled" or "<none>" as a 
>> resource value (c.f. my example above) when needed (c.f. my motivation for
>> the patch series). 
>>
>> We could, of course, change the parser in "interface.c", but this would 
>> change the ABI, I am afraid.  Something that I'd rather not do... 
> 
> Still, you _are_ doing that by extending the ABI, aren't you?

As the special value "disabled" is available as of these patches, one could
consider this an extension.  I agree. 

> 
>> I hope, this makes the scope of the patch series clear(er).
> 
> Yes, it does, thanks.
> 
> My opinion is that the whole interface is wrong and should be changed.  How to
> do that is a different matter that would require some consideration.  Perhaps
> the least painful way would be to add a new, hopefully better, interface along
> with the old one and then deprecate the latter at one point.

Personally, I too think that the PNP ABI in sysfs has its rough edges.  However, 
as with the deprecation of any existing ABI, this would require a new ABI first, 
then some time where the old and new ABI live in co-existence, and then to remove 
the currently available ABI. 

> 
> Now, since I don't like the existing interface, I'd prefer it not to be
> extended.

The current ABI does not allow for the kernel to run on my hardware: this is 
a/the problem.  The proposed extension fixes the problem.  

While I agree with your first statement, for the time being I do not see a 
better solution other than to extend the ABI. 

At this point I am repeating my "call for comments" to the community. :-) 

--- Witold

> 
> Thanks,
> Rafael
> 
