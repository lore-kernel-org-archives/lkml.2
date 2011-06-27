Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab1F0KJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 06:09:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45912 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab1F0KHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 06:07:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E08565C.4080007@jp.fujitsu.com>
Date: Mon, 27 Jun 2011 19:07:24 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: segoon@openwall.com
CC: linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        rientjes@google.com, wilsons@start.ca, security@kernel.org,
        eparis@redhat.com, kernel-hardening@lists.openwall.com,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] proc: restrict access to /proc/PID/io
References: <1308917318-4749-1-git-send-email-segoon@openwall.com> <4E07F1C0.2070305@jp.fujitsu.com> <20110627070300.GA4463@albatros> <4E08324D.9040605@jp.fujitsu.com> <20110627085242.GA6635@albatros>
In-Reply-To: <20110627085242.GA6635@albatros>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/27 17:52), Vasiliy Kulikov wrote:
> (cc'ed Linus)
> 
> On Mon, Jun 27, 2011 at 16:33 +0900, KOSAKI Motohiro wrote:
>> (2011/06/27 16:03), Vasiliy Kulikov wrote:
>>> On Mon, Jun 27, 2011 at 11:58 +0900, KOSAKI Motohiro wrote:
>>>> (2011/06/24 21:08), Vasiliy Kulikov wrote:
>>>>> /proc/PID/io may be used for gathering private information.  E.g. for
>>>>> openssh and vsftpd daemons wchars/rchars may be used to learn the
>>>>> precise password length.  Restrict it to processes being able to ptrace
>>>>> the target process.
>>>>>
>>>>> ptrace_may_access() is needed to prevent keeping open file descriptor of
>>>>> "io" file, executing setuid binary and gathering io information of the
>>>>> setuid'ed process.
>>>>>
>>>>> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
>>>>
>>>> This description seems makes sense to me. But Vasilly, I have one question.
>>>> Doesn't this change break iotop command or other userland tools?
>>>
>>> I don't use iotop, but after reading the sources it looks like it uses
>>> taskstats for information gathering, which will be broken for sure by
>>> the second patch.  All other userland tools using alien io files will be
>>> broken too.
>>>
>>> I'd say the whole approach of world readable debugging/statistics
>>> information was broken from the beginning, now we are stuck with these
>>> interfaces because of acient mistakes.
>>
>> Just idea. (perhaps it's too dumb).
>>
>> If a user want to know throughput, usually they only need KB/s granularity.
>> If a user want to know password hints, they need to know strict bytes granularity.
>> So, adding some random bytes to this statistics may help to obscure key data,
>> or just "stat = ROUND_UP(stat, 1024)".
>>
>> But, I hope to wait another experts response. they may know better approach. :)
> 
> Yep, Linus has already suggested a similar thing:
> http://www.openwall.com/lists/oss-security/2011/06/27/4
> 
> As to random bytes - if it is very predictable (e.g. rand() % 10000) one
> may restore the original value.  But it would still do much harm to good
> programs (io stats going up and down!).  Adding really random bytes
> seems somewhat too complicated for these needs to me.
> 
> As to rounding - this is a workaround, not a fix.  What if some program
> reads one byte from tty and then do some io activity exactly of 1kb-1?
> Then you just measure kbs and get original tty activity.  (just a crazy
> example to show that it is not a full solution.)
> 
> 
> Without any proof/estimate, just an idea: it's possible to get not only
> password length, which needs as much granularity as possible, but
> another information, which doesn't need any strict value.  E.g.
> statistics changing, what should indicate that some significant event
> has just happened.

I'm ok any alternative way if you have. I only want to don't break iotop.
It's used very widely and frequently from performance tuning engineers.

I'm sorry. I can't answer your story is real threat or not. I'm not security
expert. I don't have enough knowledge.

Thanks.


