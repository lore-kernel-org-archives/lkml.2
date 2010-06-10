Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab0FJF7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 01:59:22 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:43028 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab0FJF7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 01:59:21 -0400
Message-ID: <4C107F36.4070000@msgid.tls.msk.ru>
Date: Thu, 10 Jun 2010 09:59:18 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100411 Icedove/3.0.4
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs, 2.6.27=>.32 sync write 10 times slowdown [was: xfs, aacraid
 2.6.27 => 2.6.32 results in 6 times slowdown]
References: <4C0E13A7.20402@msgid.tls.msk.ru> <20100608122919.GC7869@dastard> <4C0EA938.9000104@msgid.tls.msk.ru> <20100608231845.GG7869@dastard> <4C0F3819.4000409@msgid.tls.msk.ru> <20100609074741.GJ7869@dastard> <4C0FE779.8010603@msgid.tls.msk.ru> <20100610004701.GN7869@dastard>
In-Reply-To: <20100610004701.GN7869@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

10.06.2010 04:47, Dave Chinner wrote:
> On Wed, Jun 09, 2010 at 11:11:53PM +0400, Michael Tokarev wrote:
>> 09.06.2010 11:47, Dave Chinner wrote:
>>> On Wed, Jun 09, 2010 at 10:43:37AM +0400, Michael Tokarev wrote:
>>>> 09.06.2010 03:18, Dave Chinner wrote:
>>>>> On Wed, Jun 09, 2010 at 12:34:00AM +0400, Michael Tokarev wrote:
>>>> []
>>>>>> Simple test doing random reads or writes of 4k blocks in a 1Gb
>>>>>> file located on an xfs filesystem, Mb/sec:
>>>>>>
>>>>>>                       sync  direct
>>>>>>               read   write   write
>>>>>> 2.6.27 xfs   1.17    3.69    3.80
>>>>>> 2.6.32 xfs   1.26    0.52    5.10
>>>>>>                      ^^^^
>>>>>> 2.6.32 ext3  1.19    4.91    5.02
>>>
>>> Out of curiousity, what does 2.6.34 get on this workload?
>>
>> 2.6.34 works quite well:
>>       2.6.34 xfs    1.14   4.75    5.00
>
> Ok, so we are looking at a fixed regression, then. What stable
> version of 2.6.32 are you testing? A large number of XFS fixes went
> into 2.6.32.12 (IIRC, it might have been .13), so maybe the problem
> is fixed there. Alternatively, can you use 2.6.34 rather than
> 2.6.32, or bisect the regression down to a specific set of fixes so
> we can consider whether a backport is worth the effort?

I tried 2.6.32.15.  A few previous versions too, but all recent
testing were with 2.6.32.15.  So no, the fix is not in 2.6.32.y
yet, since .15 is the latest currently.

Too bad it'd be very difficult for me to do any bisection, -- users
are not comfortable at all already due to all my experiments, --
f.e. their reports that are collecting for whole night stopped
working completely since a few days ago (because every night I'm
rebooting the machine).

Yes it'd be nice to have this fixed in 2.6.32.y.  And I promise I'll
try to find time for bisection (but not promise the tries will be
successful... ;).  Definitely worth a try anyway.

Thank you!

/mjt
