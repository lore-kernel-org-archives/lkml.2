Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab0EGDBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 23:01:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46878 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab0EGDBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 23:01:33 -0400
Message-ID: <4BE38290.6040404@cnu.edu>
Date: Thu, 06 May 2010 23:01:36 -0400
From: James Kosin <james.kosin.04@cnu.edu>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
References: <eGToe-3b9-5@gated-at.bofh.it> <eGUaB-4mU-1@gated-at.bofh.it>	 <eGUtX-4Kd-3@gated-at.bofh.it> <eGWvL-7Fy-1@gated-at.bofh.it>	 <eGWFt-7S7-17@gated-at.bofh.it> <eGWP9-8jH-17@gated-at.bofh.it>	 <4BE37DDD.8000402@cox.net> <p2jd6200be21005061953y497b0766k15123f69ff7db630@mail.gmail.com>
In-Reply-To: <p2jd6200be21005061953y497b0766k15123f69ff7db630@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/6/2010 10:53 PM, Arve Hjønnevåg wrote:
> On Thu, May 6, 2010 at 7:41 PM, James Kosin <james.kosin.04@cnu.edu> wrote:
>   
>> On 5/5/2010 8:10 PM, Tony Lindgren wrote:
>>     
>>> * Brian Swetland <swetland@google.com> [100505 16:51]:
>>>       
>>>> On Wed, May 5, 2010 at 4:47 PM, Tony Lindgren <tony@atomide.com> wrote:
>>>>         
>>>>> * Brian Swetland <swetland@google.com> [100505 14:34]:
>>>>>           
>>>>>> On Wed, May 5, 2010 at 2:12 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>>>>>>             
>> <<-- snip -->>
>>     
>>>>>>> At no point does the user program have to communicate anything to the
>>>>>>> modem driver, and at no point does it have to do anything out of the
>>>>>>> ordinary except to enable and disable a suspend blocker.
>>>>>>>               
>>>>>> Exactly -- and you can use the same style of overlapping suspend
>>>>>> blockers with other drivers than input, if the input interface is not
>>>>>> suitable for the particular interaction.
>>>>>>             
>>>>> Would the suspend blockers still be needed somewhere in the example
>>>>> above?
>>>>>           
>>>> How often would we retry suspending?
>>>>         
>>> Well based on some timer, the same way the screen blanks? Or five
>>> seconds of no audio play? So if the suspend fails, then reset whatever
>>> userspace suspend policy timers.
>>>
>>>       
>> Tony,
>> Wouldn't this be handled by the idle task, or task manager?
>>
>> When all tasks are suspended and not doing anything that should be the
>> first clue that a real suspend cycle could be attempted.
>>
>>     
> One if the benefit we get from using suspend is that an unprivileged
> app that does not have access to suspend blockers cannot prevent
> suspend. You lose this advantage if you trigger suspend only from the
> idle task.
>
>   
If the process (privileged or unprivileged) doesn't want to suspend, why
not just provide an interface to allow suspend to be turned off at the
user level.  This could block the suspend cycle in itself, and you
shouldn't need fine grained off/on cycles.  If an application really
needs the system not to suspend then they (the user) should know the
consequences and power requirements for such a task.

I didn't say it had to be only from the idle task; but, that is the most
logical place.  If the other threads are not idle then they really
require work and will most likely already have a bock on the suspend anyway.

James
