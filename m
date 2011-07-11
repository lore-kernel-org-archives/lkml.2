Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab1GKSXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:23:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62593 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944Ab1GKSXp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:23:45 -0400
MIME-Version: 1.0
In-Reply-To: <CANudz+vvXrw=4+tk6z8GW+2rW-ZsogN0XGcozLSyY-dJ_SoHdw@mail.gmail.com>
References: <CANudz+sqkachOT7r9=-rc98nCEO_QOCx7KiBi5=NWaj5exmEPA@mail.gmail.com>
	<CANudz+vxY_0NY2veJ9Wvr08x_z3e20m=g7ZL4bZDi=-vaOF7dQ@mail.gmail.com>
	<4E1B3816.2030606@genband.com>
	<CANudz+vvXrw=4+tk6z8GW+2rW-ZsogN0XGcozLSyY-dJ_SoHdw@mail.gmail.com>
Date: Mon, 11 Jul 2011 11:23:44 -0700
Message-ID: <CAFR8uefOCHxcyQJb3hSmjM9oWeLgvRzUbUG-Y6qOBwr6Lmk=ig@mail.gmail.com>
Subject: Re: how to find a task through name faster?
From: Muthu Kumar <muthu.lkml@gmail.com>
To: loody <miloody@gmail.com>
Cc: Chris Friesen <chris.friesen@genband.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let me ask a trivial question: Should this be done in kernel? Can't
you push it to user space and walk the /proc to find if the process is
there.

On Mon, Jul 11, 2011 at 10:57 AM, loody <miloody@gmail.com> wrote:
> hi:
>
> 2011/7/12 Chris Friesen <chris.friesen@genband.com>:
>> On 07/11/2011 10:52 AM, loody wrote:
>>>
>>> hi all:
>>> I found a way to find a task I need by name, test,  as below:
>>> for_each_process(task) {
>>>     if(strcmp(task->comm, "test")
>>>         printk(“%s[%d]\n”, task->comm, task->pid);
>>> }
>>>
>>> But it is time-consuming to do so if I periodically want to know
>>> whether "test" exist or not.
>>> is there better way to do so?
>
> Thanks for your reply
>
>> The names of tasks isn't indexed in any way so the above is about as good as
>> it gets if that's all the information you have.
>
> actually, I only have the name for searching, since the thread start
>  and finish periodically, pid of it will change dynamically. If I save
> the pid, next time it will change and be no use to me
>>
>> One common way around that is to store the PID in a file somewhere at
>> startup.  Then you can look in the file and see if that PID is present and
>> check "task->comm" to make sure it's what you expect.  This saves having to
>> search through all tasks.
>>
>> Chris
>
>
> --
> Regards,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
