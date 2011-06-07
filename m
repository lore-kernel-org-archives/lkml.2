Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab1FGJa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 05:30:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52104 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1FGJa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:30:26 -0400
Message-ID: <4DEDF1F2.2080204@steinhoff.de>
Date: Tue, 07 Jun 2011 11:40:02 +0200
From: Armin Steinhoff <armin@steinhoff.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Johannes Bauer <hannes_bauer@aon.at>,
        Peter Zijlstra <peterz@infradead.org>,
        Monica Puig-Pey <puigpeym@unican.es>,
        Rolando Martins <rolando.martins@gmail.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Changing Kernel thread priorities
References: <17185480.5304.1307435255996.JavaMail.root@WARSBL214.highway.telekom.at> <alpine.LFD.2.02.1106071033350.11814@ionos>
In-Reply-To: <alpine.LFD.2.02.1106071033350.11814@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:lIBGmwjp3ppHE4Cf1q+W2RaxtGAa0FyapVHxgd9/gBu
 Pvaa1eKwEFlI3zpf8MZ+nVouHZI1kq6+bg1Rnj0aP3v5blolZQ
 h6xcJpSPoovC55gjJj76iJTlIFSWltyxcGuKYzMkbB1a5d/JDw
 lUAWeshzpZ++Woo476r+/Z89stDU2WE8vH3eA8dl25ePJYF5/s
 F9x9r9T/x2WKZETJCUvCQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

when I read all these confusing statements here ( in german it looks 
like an "Eiertanz")  ... I can only say:

- do the basic stuff in a minimal kernel driver
- use UIO (or VFIO for PCI devices)

and you get clean control about your real-time priorities.

I think changing the priorities of "interrupt threads" inside the kernel 
could lead to strange race conditions in the kernel.
That seems to be the reason for that "Eiertanz" here :)

--Armin





Thomas Gleixner wrote:
> On Tue, 7 Jun 2011, Johannes Bauer wrote:
>
> Please stop top-posting and use proper line breaks at 78
>
>>> Peter Zijlstra wrote:
>>>> "Monica Puig-Pey" wrote:
>>>> I need to change the priority from inside the driver, when creating the
>>>> kernel thread.
>>> No you don't. How does you driver know about what priority is correct
>>> wrt all the other running RT tasks on the system?
>>>
>>> Determining the right priority in a fixed priority scheduling system is
>>> a system wide problem, nobody but the administrator can possibly even
>>> begin to solve it.
>>>
>>> There's a reason all RT irq threads are started at 50, its plain
>>> impossible to do better.
>> Absolutly correct!
>>
>> However, if you are running the system on an embedded platform,
>> where the _WHOLE_ system (including priorities) is preconfigured and
>> never touched, starting a irq thread with the right prio from start
>> is a more straightforward method than having to invoke a script that
>> changes it using userspace chrt tool.
> Feel free to do that for your embedded system and carry the patch for
> yourself if you think it's worth to avoid the extra init script.
>
> But we do _not_ add stuff like this to the mainline simply because
> there is no way to find a prio setting which is appropriate for all
> users of a particular driver.
>
> Aside of that the extra init script is definitely less annoying to
> maintain than the crap you need to hack into random drivers.
>
> Thanks,
>
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

