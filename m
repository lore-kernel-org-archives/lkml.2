Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab0FGF2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 01:28:44 -0400
Received: from crca.org.au ([74.207.252.120]:43778 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583Ab0FGF2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 01:28:42 -0400
X-Bogosity: Ham, spamicity=0.000003
Message-ID: <4C0C8386.1040209@crca.org.au>
Date: Mon, 07 Jun 2010 15:28:38 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [SUSPECTED SPAM] Re: Proposal for a new algorithm
 for reading & writing a hibernation image.
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com>	<201006052121.45816.rjw@sisk.pl>	<1275784828.17835.4.camel@maxim-laptop> <201006061557.20482.rjw@sisk.pl>
In-Reply-To: <201006061557.20482.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 06/06/10 23:57, Rafael J. Wysocki wrote:
> On Sunday 06 June 2010, Maxim Levitsky wrote:
>> On Sat, 2010-06-05 at 21:21 +0200, Rafael J. Wysocki wrote:
>>> On Saturday 05 June 2010, Maxim Levitsky wrote:
>>>> On Sat, 2010-06-05 at 20:45 +0200, Rafael J. Wysocki wrote:
>>>>> On Saturday 05 June 2010, Nigel Cunningham wrote:
>>>>>> Hi again.
>>>>>>
>>>>>> As I think about this more, I reckon we could run into problems at
>>>>>> resume time with reloading the image. Even if some bits aren't modified
>>>>>> as we're writing the image, they still might need to be atomically
>>>>>> restored. If we make the atomic restore part too small, we might not be
>>>>>> able to do that.
>>>>>>
>>>>>> So perhaps the best thing would be to stick with the way TuxOnIce splits
>>>>>> the image at the moment (page cache / process pages vs 'rest'), but
>>>>>> using this faulting mechanism to ensure we do get all the pages that are
>>>>>> changed while writing the first part of the image.
>>>>>
>>>>> I still don't quite understand why you insist on saving the page cache data
>>>>> upfront and re-using the memory occupied by them for another purpose.  If you
>>>>> dropped that requirement, I'd really have much less of a problem with the
>>>>> TuxOnIce's approach.
>>>> Because its the biggest advantage?
>>>
>>> It isn't in fact.
>>>
>>>> Really saving whole memory makes huge difference.
>>>
>>> You don't have to save the _whole_ memory to get the same speed (you don't
>>> do that anyway, but the amount of data you don't put into the image with
>>> TuxOnIce is smaller).  Something like 80% would be just sufficient IMO and
>>> then (a) the level of complications involved would drop significantly and (2)
>>> you'd be able to use the image-reading code already in the kernel without
>>> any modifications.  It really looks like a win-win to me, doesn't it?
>>
>>
>> Well, in fact on modern systems its not possible to save 100% of ram
>> even if we save it all because of video memory.
>> Look I got 256MB of video ram, and when compiz is used I say most of it
>> is used, and its isn't going to be magically preserved during suspend.
>> So system still has to free about 256MB of memory before suspend (which
>> means around 80% percent of ram is saved in best case :-) )
>
> So how TuxOnIce helps here?

The 256MB of video ram is irrelevant, unless it's 'stolen', in which 
case it will be saved.
