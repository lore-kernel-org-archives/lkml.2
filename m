Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab1FFMRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 08:17:12 -0400
Received: from nat-warsl417-02.aon.at ([195.3.96.120]:11987 "EHLO email.aon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754559Ab1FFMRL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:17:11 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jun 2011 08:17:10 EDT
Date: Mon, 6 Jun 2011 14:10:25 +0200 (CEST)
From: Johannes Bauer <hannes_bauer@aon.at>
Reply-To: hannes_bauer@aon.at
To: Monica Puig-Pey <puigpeym@unican.es>,
        Rolando Martins <rolando.martins@gmail.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <4829399.10721.1307362225402.JavaMail.root@WARSBL213.highway.telekom.at>
Subject: Re: Changing Kernel thread priorities
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
X-MSMail-Priority: Normal
Sensitivity: Normal
X-Originating-IP: 81.223.102.6
X-Mailer: aon Webmail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

i thought i sent you the discussion already...

But again, here is how Remy Bohmer does it using the same sched_setscheduler call!
http://www.mail-archive.com/linux-rt-users@vger.kernel.org/msg01046.html

If it does not help you, i woul dsuggest to post your code, maybe this would help people to help you...

regards JB



----- Ursprüngliche Nachricht -----
Von: "Monica Puig-Pey" <puigpeym@unican.es>
Erhalten: 06.06.2011 13:58
An: "Rolando Martins" <rolando.martins@gmail.com>

El 06/06/11 13:54, Rolando Martins escribió:
> Hi,
> I use the following:
>
> PIDs=$(ps -eLo pid,cls,rtprio,pri,nice,cmd | grep -i "irq" | awk '{
> print $1; }' | xargs echo)
> for i in $PIDs
> do
> ret=$(chrt -f -p 99 $i)
> done
>
> This will change the kernel thread associated with an irq handler to
> RT FIFO prio 99.
> Just change the script to your specific interrupt.
>
> Hope it helps,
> Rolando
>
> On Mon, Jun 6, 2011 at 12:47 PM, Monica Puig-Pey wrote:
>> I am writing a driver which has one kernel thread associated with it.
>> I want to change the priority of this thread, so that I can specify the
>> order in which it is scheduled following an interrupt.
>> I'm using:
>>
>> sched_setscheduler(struct task_struct *, int, struct sched_param *);
>>
>> but it doesn't work. I tried to change the priority from the init_module,
>> and also from the Kernel Thread, but there is no way.
>>
>> Kernel version is 2.6.31-11-rt
>>
>> What do I call to change a kernel thread priority?
>>
>> Thanks you very much
>>
>> Mónica
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>

I need to change the priority from inside the driver, when creating the 
kernel thread.
Your script is useful but it is done in user context,
Any other help please?

Mónica


--
To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at http://vger.kernel.org/majordomo-info.html
