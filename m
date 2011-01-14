Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab1ANLNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 06:13:22 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:57041 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152Ab1ANLNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 06:13:17 -0500
Message-ID: <4D302FC3.7060008@st.com>
Date: Fri, 14 Jan 2011 16:43:07 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jack Stone <jwjstone@fastmail.fm>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/async.c: fixing compilation warnings
References: <1294989246-1621-1-git-send-email-viresh.kumar@st.com> <7f454c6e-eeb9-4de0-acfe-6ced96ecdad0@email.android.com>
In-Reply-To: <7f454c6e-eeb9-4de0-acfe-6ced96ecdad0@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2011 02:48 PM, Jack Stone wrote:
> "Viresh Kumar" <viresh.kumar@st.com> wrote:
> 
>> This patch fixes following compilation warnings:
>> 270:10: warning: ‘starttime.tv64’ may be used uninitialized in this
>> function
>> 122:10: warning: ‘calltime.tv64’ may be used uninitialized in this
>> function
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
>> ---
>> kernel/async.c |    4 ++--
>> 1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/async.c b/kernel/async.c
>> index cd9dbb9..9c06931 100644
>> --- a/kernel/async.c
>> +++ b/kernel/async.c
>> @@ -119,7 +119,7 @@ static void async_run_entry_fn(struct work_struct
>> *work)
>> 	struct async_entry *entry =
>> 		container_of(work, struct async_entry, work);
>> 	unsigned long flags;
>> -	ktime_t calltime, delta, rettime;
>> +	ktime_t calltime = {0}, delta, rettime;
> 
> I think this is a false positive so we can use uninitalized_var().
> 
>> 	/* 1) move self to the running queue */
>> 	spin_lock_irqsave(&async_lock, flags);
>> @@ -267,7 +267,7 @@ EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
>> void async_synchronize_cookie_domain(async_cookie_t cookie,
>> 				     struct list_head *running)
>> {
>> -	ktime_t starttime, delta, endtime;
>> +	ktime_t starttime = {0}, delta, endtime;
>>
> 
> Same for this one.
> 

I will resend it with suggested changes.

--
viresh
