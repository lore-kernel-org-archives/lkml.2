Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab1E3FNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 01:13:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48504 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab1E3FNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 01:13:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DE3277D.8070109@jp.fujitsu.com>
Date: Mon, 30 May 2011 14:13:33 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: vgoyal@redhat.com, xiyou.wangcong@gmail.com, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, jwilson@redhat.com
Subject: Re: [Patch] kexec: remove KMSG_DUMP_KEXEC (was Re: Query about kdump_msg
 hook into crash_kexec())
References: <20110203095837.93A2.A69D9226@jp.fujitsu.com>	<20110203020703.GB21603@redhat.com>	<20110203135324.93BC.A69D9226@jp.fujitsu.com> <20110526131028.7052a893.akpm@linux-foundation.org>
In-Reply-To: <20110526131028.7052a893.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/27 5:10), Andrew Morton wrote:
> On Thu,  3 Feb 2011 13:53:01 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
>>>> I wrote why this is no good idea by another mail. Please see it.
>>>> Anyway you have a right to don't use this feature.
>>>>
>>>
>>> But you have not explained that why do you need to hook into crash_kexec()
>>> and you have also not explained why do you need to send out kdump_msg()
>>> notification if kdump is configured.
>>>
>>> Some detailed explanation here would help.
>>
>> Hi,
>>
>> I send it you now :)
>>
> 
> What happened with this?  kexec-remove-kmsg_dump_kexec.patch has two acks
> and one unexplained nack :(

http://groups.google.com/group/linux.kernel/browse_thread/thread/1084f406573d76ac/ee19e34b45f83536?lnk=raot&pli=1

At last mail, Vivek proposed move kms_dump() instead remove. and I asked following question and
I've got no response. I'm still waiting his.


> I'm sorry I've missed this mail long time. 
> 
>> > --------------------------------------------------------------------- 
>> > @@ -74,6 +75,7 @@ NORET_TYPE void panic(const char * fmt, ...) 
>> >         dump_stack(); 
>> >  #endif 
>> > +       kmsg_dump(KMSG_DUMP_PANIC); 
>> >         /* 
>> >          * If we have crashed and we have a crash kernel loaded let it handle 
>> >          * everything else. 
>> >          * Do we want to call this before we try to display a message? 
>> >          */ 
>> >         crash_kexec(NULL); 
>> > --------------------------------------------------------------------- 
>> And I think to compensate for that somebody introduced additional 
>> kmsg_dump(KEXEC) call inside crash_kexec() and put it under CONFIG 
>> option so that one can change the behavior based on config options. 
>> I think this makes the logic somewhat twisted and an unnecessary call 
>> inside crash_kexec(). So until and unless there is a strong reason we 
>> can get rid of KEXEC event and move kmsg_dump call before crash_kexec() 
>> for now and see how does it go, IMHO. 
> 
> 
> I think I can agree your proposal. But could you please explain why do 
> you think kmsg _before_ kdump and kmsg _in_ kdump are so different? 
> I think it is only C level difference. CPU don't care C function and 
> anyway the kernel call kmsg_dump() because invoke second kernel even 
> if you proposal applied. 
> It is only curious. I'm not against your proposal. 
> Thanks. 






