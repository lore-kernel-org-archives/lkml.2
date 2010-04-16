Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab0DPAlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 20:41:51 -0400
Received: from dm-mail02.mozilla.org ([63.245.208.176]:50723 "EHLO
	dm-mail02.mozilla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab0DPAlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 20:41:49 -0400
Message-ID: <4BC7B24C.7040701@mozilla.com>
Date: Thu, 15 Apr 2010 17:41:48 -0700
From: Taras Glek <tglek@mozilla.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Downsides to madvise/fadvise(willneed) for application startup
References: <4BBA6776.5060804@mozilla.com> <20100415155309.2649a29b.akpm@linux-foundation.org>
In-Reply-To: <20100415155309.2649a29b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2010 03:53 PM, Andrew Morton wrote:
> On Mon, 05 Apr 2010 15:43:02 -0700
> Taras Glek<tglek@mozilla.com>  wrote:
>
>    
>> To make matters worse,
>> the compile-time linker + gcc lay out code in a manner that does not
>> correspond to how the resulting executable will be executed(ie the
>> layout is basically random).
>>      
> Yes, the linker scrambles the executable's block ordering.
>
> This just isn't an interesting case.  World-wide, the number of people
> who compile their own web browser and execute it from the file which ld
> produced is, umm, seven.
>    
I'm sorry that you don't find this interesting. I did not suggest that 
people compile their own browser to get a perfect layout. This is 
something that Mozilla can do when preparing builds and it's also 
something distributions can do. It just so happens that large parts of 
startup will be very similar for every single firefox install, might as 
well layout the binary accordingly.
> So I'd suggest that you always copy the executable to a temp file and
> mv it back before running any timing tests.
>    
You mean to get it into a cache or to hope to avoid fragmentation?  If 
you are suggesting this to avoid measuring the startup overhead of 
paging the binary in, I strongly disagee. It is the slowest part of 
firefox startup and needs to be addressed.

Taras


