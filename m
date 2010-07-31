Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab0GaBTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 21:19:00 -0400
Received: from tuxonice.net ([74.207.252.127]:53290 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab0GaBS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 21:18:59 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C537A01.5040808@tuxonice.net>
Date: Sat, 31 Jul 2010 11:18:57 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Bojan Smojver <bojan@rexursive.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
References: <1280465201.2600.10.camel@shrek.rexursive.com>	 <1280486667.2608.1.camel@shrek.rexursive.com>	 <4C534C9D.8000600@tuxonice.net>	 <1280532174.2583.1.camel@shrek.rexursive.com>	 <4C5362E7.3000706@tuxonice.net> <1280538184.2583.11.camel@shrek.rexursive.com>
In-Reply-To: <1280538184.2583.11.camel@shrek.rexursive.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 31/07/10 11:03, Bojan Smojver wrote:
> On Sat, 2010-07-31 at 09:40 +1000, Nigel Cunningham wrote:
>
>> How about vmallocing the cmp as well? That would greatly reduce the
>> potential for page allocation failures while still letting you use an
>> order 6 area.
>
> In save_image(), that worked. In load_image() it would cause a crash
> (something about kernel not being able to satisfy paging request). So, I
> just made it __get_free_pages() instead. But, yeah good point.
>
> Keep in mind that I have absolutely no idea how kernel memory allocation
> works. I'm kinda coping and pasting code and hoping it doesn't crash :-)

It should be possible to do the allocation at that point. I might see if 
I can take a look later on.

>>> PS. I guess with this, read_sync can simply disappear as well.
>>
>> I haven't looked at the code for a while, but it might still be needed
>> for the header? I know that in TuxOnIce, I need to read the first page
>> synchronously when bootstrapping reading the image (can't read the next
>> page until you know where it is, and its location is on the first page).
>> Since swsusp uses those index pages, I think it would have the same
>> issue - they would need to be read before it could read the following
>> pages. Of course I'm going off memory :)
>
> I think it can go, because the header is already read/written with&bio
> set to NULL (sync read). See patch to remove read_sync.

Okee doke.

By the way, please inline your patches. It makes it much easier to read 
and comment on them.

Oh, and I've said it privately but not publicly: great work!

Regards,

Nigel
