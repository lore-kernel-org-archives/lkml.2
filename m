Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761535Ab0HMLyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 07:54:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:46097 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761519Ab0HMLyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 07:54:05 -0400
Message-ID: <4C65323F.8090907@windriver.com>
Date: Fri, 13 Aug 2010 06:53:35 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with commit deda2e81961e96be4f2c09328baca4710a2fd1a0
References: <4C64571F.6000606@lwfinger.net> <1281646368.4002.66.camel@localhost.localdomain> <4C64B93A.5010403@lwfinger.net> <1281684638.3940.11.camel@work-vm>
In-Reply-To: <1281684638.3940.11.camel@work-vm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Aug 2010 11:53:36.0715 (UTC) FILETIME=[29B639B0:01CB3ADE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2010 02:30 AM, john stultz wrote:
> On Thu, 2010-08-12 at 22:17 -0500, Larry Finger wrote:
>   
>> On 08/12/2010 03:52 PM, john stultz wrote:
>>     
>>> Ugh. I'm surprised it picks *this* loop to optimize instead of the
>>> similar one right above. I'm guessing its the local raw_nsecs value, but
>>> whatever.  Also surprised Jason's testing didn't hit this issue, but its
>>> probably a gcc version thing.
>>>
>>> Regardless, I clearly need to give i386 more love in my testing.
>>> My profuse apologies.
>>>
>>> As suggested by Linus, here's the do_div explicit version. It builds ok
>>> on i386 & x86_64, but I have not yet tested it. 
>>>
>>> Larry, Jason: Could you verify it works for you (and avoids the original
>>> issue)?
>>>       
>> This one builds for me with both compilers. It appears to run OK. As to the
>> original issue - I don't think I ever saw the problem. I'll leave that question
>> for Jason.
>>     
>
> Thanks for the testing! 
>
> I also managed to trigger the link issue with a 64bit gcc-4.3 cross
> compiling to 32bit. However both 32bit and 64bit gcc-4.4 didn't trigger
> the link issue, so it looks like its fixed in gcc.
>
> Regardless, after my own testing, the change looks good to me. Raw time
> is accumulating properly relative to monotonic time.
>
> Assuming Jason has no complaints it should be able to be pushed in.
>
>   

No complaints here.  The edge case remains solved on the low MHZ 32 bit
system.

The reason I never saw any problem in all my test configurations was
that gcc 4.4 is the oldest compiler I have in any of the configurations
I am using.   I could have been more specific in my original mail on the
subject but it was tested with a 32bit cross compiler as well as a 64bit
cross compiler.

Many thanks to all who helped draw this odd ball case to closure.

Jason.
