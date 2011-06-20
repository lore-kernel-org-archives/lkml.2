Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab1FTRkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 13:40:16 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:40212 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577Ab1FTRkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 13:40:14 -0400
Message-ID: <4DFF85D6.1090104@ahsoftware.de>
Date: Mon, 20 Jun 2011 19:39:34 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Nicolas Pitre <nico@fluxnic.net>
CC: Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        gregkh@suse.de, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing
 the packed attribute
References: <Pine.LNX.4.44L0.1106201240240.2113-100000@iolanthe.rowland.org> <alpine.LFD.2.00.1106201306210.2142@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1106201306210.2142@xanadu.home>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.06.2011 19:10, schrieb Nicolas Pitre:
> On Mon, 20 Jun 2011, Alan Stern wrote:
>
>> On Mon, 20 Jun 2011, Nicolas Pitre wrote:
>>
>>> On Mon, 20 Jun 2011, Alan Stern wrote:
>>>
>>>> On Sun, 19 Jun 2011, Nicolas Pitre wrote:
>>>>
>>>>>>> The question is: does the structure really has to be packed?
>>>>>>
>>>>>> What do you mean?  The structure really does need to be allocated
>>>>>> without padding between the fields; is that the same thing?  So do a
>>>>>> bunch of other structures that currently have no annotations at all.
>>>>>
>>>>> Yes, that's the same thing.  The packed attribute tells the compiler
>>>>> that you don't want it to insert padding in it as it sees fit.
>>>>
>>>> I thought the packed attribute does more than that.  For example, on
>>>> some architectures doesn't it also force the compiler to use
>>>> byte-oriented instructions for accessing the structure's fields?
>>>
>>> Yes, but that's a consequence of not being able to access those fields
>>> in their naturally aligned position anymore.  Hence the addition of the
>>> align attribute to tell the compiler that we know that the structure is
>>> still aligned to a certain degree letting the compiler to avoid
>>> byte-oriented instructions when possible.
>>
>> Not exactly.  As far as I can tell, the ((packed)) attribute caused the
>> compiler to change the structure's alignment from its natural value to
>> 1.  That's why the fields weren't in their naturally aligned positions
>> and why removing ((packed)) fixed the problem.
>
> Are we talking past each other?
>
> Remember that I was the one asking if the align attribute was needed in
> the first place.  If it is not then by all means please get rid of it!
>
> But if it _is_ needed, then the generated code can be much better if the
> packed attribute is _also_ followed by the align attribute to
> increase it from 1.

That reminds me of some time where I had fun asking someone with deeper 
ppc- and xlC-knowledge than I, if he is sure that assignments, are 
atomic. He always said yes. Got something like a running gag. ;)

I see it that way: packed is needed to be sure that at least for struct 
ehci_regs there are no padding bytes inbetween the members. It might 
work without, but that depends on the compiler (-version, architecture, 
whatever).

That packed without an additional aligned() caused errors on ARM with 
gcc 4.6 is another problem which got (currently) fixed by removing packed.
But this introduces imho doubts and uncertainty about if padding bytes 
could be between the members, therefore I would prefer to use packed 
with aligned instead of removing the packed.

Regards,

Alexander
