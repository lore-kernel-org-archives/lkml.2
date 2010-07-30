Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab0G3Xk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 19:40:27 -0400
Received: from tuxonice.net ([74.207.252.127]:47130 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab0G3Xk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 19:40:26 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C5362E7.3000706@tuxonice.net>
Date: Sat, 31 Jul 2010 09:40:23 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Bojan Smojver <bojan@rexursive.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
References: <1280465201.2600.10.camel@shrek.rexursive.com>	 <1280486667.2608.1.camel@shrek.rexursive.com>	 <4C534C9D.8000600@tuxonice.net> <1280532174.2583.1.camel@shrek.rexursive.com>
In-Reply-To: <1280532174.2583.1.camel@shrek.rexursive.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again.

On 31/07/10 09:22, Bojan Smojver wrote:
> On Sat, 2010-07-31 at 08:05 +1000, Nigel Cunningham wrote:
>> Is an order 6 allocation really necessary,
>> though?
>
> I tried with 5 and 4 and got slightly lower throughput numbers. With 6,
> I was getting 145 to 150 MB/s, with 4 I'm getting around 130 MB/s (this
> is all on hibernate).
>
> So, here is one with 4.

How about vmallocing the cmp as well? That would greatly reduce the 
potential for page allocation failures while still letting you use an 
order 6 area.

I might try this for TuxOnIce too - I'm only using order 0 allocations 
at the moment and have been wondering how I can get the higher write 
speed I think should be possible on my system :) I was thinking along 
the lines of locking, but perhaps that was the wrong area to pursue! :)

> PS. I guess with this, read_sync can simply disappear as well.

I haven't looked at the code for a while, but it might still be needed 
for the header? I know that in TuxOnIce, I need to read the first page 
synchronously when bootstrapping reading the image (can't read the next 
page until you know where it is, and its location is on the first page). 
Since swsusp uses those index pages, I think it would have the same 
issue - they would need to be read before it could read the following 
pages. Of course I'm going off memory :)

Nigel
