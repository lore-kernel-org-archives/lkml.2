Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025Ab1CEAwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 19:52:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55496 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab1CEAwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 19:52:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KZsqqLabd8Y/JdfpvdZ+VMjr+igxVu/zV2ZwVmoobNO1BLQ788mWGDV2prGnp+QGWl
         Y5kX1uCLXGyXnvEqu98qB+DfLGO7JNrJL6EbeBKCYObxmScHPgyHHGotEmYdaKLAYAlP
         tOYU9wabc+M1qOdRvYqWRSPdi0Z9DNJ9DlZjk=
Message-ID: <4D718933.1050106@gmail.com>
Date: Sat, 05 Mar 2011 03:52:03 +0300
From: "avagin@gmail.com" <avagin@gmail.com>
Reply-To: avagin@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH rh6] mm: skip zombie in OOM-killer
References: <1299274256-2122-1-git-send-email-avagin@openvz.org> <alpine.DEB.2.00.1103041541040.7795@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1103041541040.7795@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2011 02:41 AM, David Rientjes wrote:
> On Sat, 5 Mar 2011, Andrey Vagin wrote:
>
>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> index 7dcca55..2fc554e 100644
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
>> @@ -311,7 +311,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
>>   		 * blocked waiting for another task which itself is waiting
>>   		 * for memory. Is there a better alternative?
>>   		 */
>> -		if (test_tsk_thread_flag(p, TIF_MEMDIE))
>> +		if (test_tsk_thread_flag(p, TIF_MEMDIE)&&  p->mm)
>>   			return ERR_PTR(-1UL);
>>
>>   		/*
>
> I think it would be better to just do
>
> 	if (!p->mm)
> 		continue;
>
> after the check for oom_unkillable_task() because everything that follows
> this really depends on p->mm being non-NULL to actually do anything
> useful.
Yes. You are right. Thank you.
