Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab1ANKzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 05:55:23 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46391 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152Ab1ANKzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 05:55:17 -0500
X-Sasl-enc: hoXp0ppuQ1T8LumRVW/aT9bVqJi3ARlaKnJpp2VGq1V5 1295002516
Message-ID: <4D302B92.902@fastmail.fm>
Date: Fri, 14 Jan 2011 10:55:14 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: viresh kumar <viresh.kumar@st.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] fs/eventpoll.c: fix compilation warning
References: <1294989352-2003-1-git-send-email-viresh.kumar@st.com> <2426ea8f-7e52-4329-bf20-884c2b996f98@email.android.com> <4D30198D.9080206@st.com>
In-Reply-To: <4D30198D.9080206@st.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/2011 09:38, viresh kumar wrote:
> On 01/14/2011 03:03 PM, Jack Stone wrote:
>>>> -	long slack;
>>>> +	long slack = 0;
>>>> 	wait_queue_t wait;
>>>> 	struct timespec end_time;
>>>> 	ktime_t expires, *to = NULL;
>> I don't think this is the correct fix. This function is fine unless timeout is negative.
>>
>> If a negative timeout is possible then this function will create timer far in the future.
>> I'll leave it up to the maintainer how to solve that one. The two solutions I can see are making
>> timeout unsigned or extending the bottom case of the if to <=0.
>>
>> Either way we should use uninitalized_var() rather than setting it to zero.
> 
> Using uninitialized var gives compilation warning, How should we fix that.
> 

I meant something like
-  long slack;
+  long uninitialized_var(slack);

I just had a go at generating this warning and couldn't. I've tried GCC
4.4.5 (From Fedora 13) and latest sparse.

Thanks,

Jack
