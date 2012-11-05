Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2KEUer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:34:47 -0500
Received: from smtp.getmail.no ([84.208.15.66]:56494 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889Ab2KEUeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:34:46 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: Martin <marogge@onlinehome.de>
Subject: Re: sched: SCHED_DEADLINE v6
References: <k2boS-2q4-11@gated-at.bofh.it> <k2dK1-5rL-11@gated-at.bofh.it>
 <k2ewr-6bR-15@gated-at.bofh.it> <5098204D.3080002@onlinehome.de>
Date: Mon, 05 Nov 2012 21:34:44 +0100
Cc: linux-kernel@vger.kernel.org
From: Ove Karlsen <ove.karlsen@paradoxuncreated.com>
Message-id: <op.wnbh36ga1c32bs@localhost.localdomain>
In-reply-to: <5098204D.3080002@onlinehome.de>
User-Agent: Opera Mail/12.02 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Nov 2012 21:23:41 +0100, Martin <marogge@onlinehome.de> wrote:

> On 11/04/2012 09:00 PM, Uwaysi Bin Kareem wrote:
>> Nobody knows? This is really obscure for an EDF patch. Making things a
>> bit more accessible should be a priority. I think a lot of enthusiasts
>> would like to have smooth control over stuff, without windows-jitter. If
>> you can do a robot arm, jitter-free with this, then I am very  
>> interested.
>>
>> uwaysi@Millennium:~/Kildekode/sched_deadline-schedtool-dl$ ./schedtool  
>> -E
>> -t 500:1000 3718
>> ERROR: could not set PID 3718 to E: SCHED_DEADLINE - Function not
>> implemented
>> uwaysi@Millennium:~/Kildekode/sched_deadline-schedtool-dl$
>>
>> On Sun, 04 Nov 2012 20:02:25 +0100, Uwaysi Bin Kareem
>> <uwaysi.bin.kareem@paradoxuncreated.com> wrote:
>>
>>> How does the modified schedtool work? There is no updated  
>>> documentation.
>>>
>>> http://gitorious.org/sched_deadline/schedtool-dl/commits/latest/2.6.36-dl-V3
>>>
>>>
>>> If anyone could give an example of a 1000uS period / 500uS time, with
>>> schedtool, or any other relevant information.
>>> Most examples online use parameters that are no longer supported.
>>>
>>> Peace Be With You.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"  
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> Hi,
>
> I assume the reason nobody answers is that the cpu scheduler is an  
> emotional subject.
>
> However, if you really want a smooth desktop and a deadline scheduler  
> (albeit it might not be as configurable as you seem to want it to be),  
> try BFS or the whole CK patch.
>
> http://ck-hack.blogspot.com/
>
> I have implemented it on a laptop this weekend, and I was surprised by  
> the change in user experience yet again. Mostly during 3D game play.  
> Generally the difference is felt more strongly on low end machines and  
> taxing workloads.
>
> Since you are talking about robot arms: note that BFS is not a real time  
> solution, but is designed around the physiological conditions of the  
> human perception system (where, I believe, 6 ms is equivalent to real  
> time). Maybe a similar deadline approach is useful for robot arms, no  
> idea.
>
> cu Martin
>

If you ever saw a robot-arm jitter, you`d think of it as faulty. And that  
is how people should think of their PC aswell.

Just the interrupts, preemption (points), daemons, hopefully cleverly  
arranged, to reduce jitter, is what I want.
I did already try BFS. PS: 90hz timer, is very good with BFS also, but the  
jitter-extremes are higher. Meaning large jitters last longer, while small  
jitters, seems smaller. For overall computing CFS actually has less jitter.

What would be really interesting would be to try a scheduler that tries to  
bound latencies, and have accurate timing.

There seems to be generally 3 different profiles people tuned for: Server,  
Mobile, Desktop.
Server guiless stationary, Mobile for minimal power desktop, Desktop, for  
workstation/home low-jitter high-performance.

Maybe these profiles even can be combined a bit, having several hz  
counters, and several scheduling policies.

Peace Be With You.
