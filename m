Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab2FNP5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 11:57:44 -0400
Received: from gateway.alibaba-inc.com ([121.0.29.147]:23942 "EHLO
	CNHZ-ExGW-02.ali.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752151Ab2FNP5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 11:57:43 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2012 11:57:42 EDT
X-AuditID: 0a14034d-b7b71ae000001ff5-d5-4fda066d6ac5
Message-ID: <4FDA066D.2060507@taobao.com>
Date: Thu, 14 Jun 2012 23:42:37 +0800
From: Charles Wang <muming.wq@taobao.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Doug Smythies <dsmythies@telus.net>
CC: "'Charles Wang'" <muming.wq@gmail.com>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>, "'Ingo Molnar'" <mingo@redhat.com>,
        "'Tao Ma'" <tm@tao.ma>,
        =?ISO-2022-JP?B?JxskQjReQmMbKEIn?= <handai.szj@taobao.com>
Subject: Re: [PATCH] sched: Folding nohz load accounting more accurate
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>	 <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com> <1339494970.31548.66.camel@twins> <004701cd4929$200d4600$6027d200$@net> <4FD84795.20409@gmail.com> <000301cd49e8$1dbd2db0$59378910$@net>
In-Reply-To: <000301cd49e8$1dbd2db0$59378910$@net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.20.8.3]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 Thursday, June 14, 2012 12:41 PM, Doug Smythies 写道:

>> On 2012.06.13 00:56 - 0700, Charles Wang wrote:
>
>> Every cpu's load should be the load right on the time executing
>> calculation.
>> This is what my patch expected to do.
>
>> After my patch, it's supposed to let every cpu's load calculation be
>> independent from
>> its idle and other cpus' influence when the calculation is finished.
>> But it seems other problem exists.
>
>> I recorded some trace, show as below:
>
> Charles thanks for your detailed reply.
> I am not sure I agree.
>
> On purpose, I have left out your trace detail from this reply.
> Why? Because I want to take a step back and answer a more fundamental
> question first:
> Is there (or was there) actually a problem that needed to be solved?
>
> I am still not understanding what your expected reported load averages
> for your 16 processes should be. How do you know that the 8 to 10 that
> was being reported was incorrect?
>

I re-create the problem by waiter, using following parameters:
./waiter 16 1800 900 9444 100 1

9444 and 100 is the key point that can make
"processing time+sleeping time" less than 1 tick.

We have 16 processors, and the load of every processor is about 0.25~0.3,
so the actual load should be 16*0.25=4. But the loadavg calculated by the
current logic is only about 1.

> I want to understand so that I can re-create your same reported load
> averages are still to low situation on my test computer, before your patch.
> Then show that it is fixed after your patch.
> I have tried to re-create it and have been unsuccessful. Today, and since
> you
> showed at least 16 CPUs on your system, and I only have 8 CPUs, I tried with
> 8 processes at high duty cycle. The reported load average was always pretty
> close to the actual load (see also attachment).
>
> Perhaps I have some fundamental misunderstanding as to how reported load
> averages should work. I have always used kernels compiled with
> CONFIG_NO_HZ=no (tick based, rather than tickless) as the control reference.
>



________________________________

This email (including any attachments) is confidential and may be legally privileged. If you received this email in error, please delete it immediately and do not copy it or use it for any purpose or disclose its contents to any other person. Thank you.

本电邮(包括任何附件)可能含有机密资料并受法律保护。如您不是正确的收件人，请您立即删除本邮件。请不要将本电邮进行复制并用作任何其他用途、或透露本邮件之内容。谢谢。
