Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab1ANOsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:48:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53541 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757596Ab1ANOsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:48:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l79YLk0dJWRhEO59CEJTrfB1lua5tER8UAuLwv+k2L2mse+tnQehr2/yggSNEbW2t8
         Dn28PoKHZLME+Md29oppySV30rXvB2cqeppvJ7MzB0r5n5jApj0DIsExVh+svJaN95ya
         /fT21l58dmG8ZhRzlI5UNyfYZpt8SwSFcbvIg=
MIME-Version: 1.0
In-Reply-To: <4D304A84.1000601@fastmail.fm>
References: <1295005953-12173-1-git-send-email-viresh.kumar@st.com>
	<4D304A84.1000601@fastmail.fm>
Date: Fri, 14 Jan 2011 08:48:11 -0600
Message-ID: <AANLkTikQwgzTZrTVQ_kfxwNdT-_8Ly5FjCxiXB2gxj3W@mail.gmail.com>
Subject: Re: [PATCH resend] fs/eventpoll.c: fix compilation warning
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Jack Stone <jwjstone@fastmail.fm>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Viresh Kumar <viresh.kumar@st.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 7:07 AM, Jack Stone <jwjstone@fastmail.fm> wrote:
> [cc Al Viro and Shawn Bohrer]
> On 14/01/2011 11:52, Viresh Kumar wrote:
>> This patch fixes following compilation warning
>> fs/eventpoll.c:1119: warning: 'slack' may be used uninitialized in this function
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
>> ---
>>  fs/eventpoll.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
>> index 8cf0724..89b5e98 100644
>> --- a/fs/eventpoll.c
>> +++ b/fs/eventpoll.c
>> @@ -1116,7 +1116,7 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>>  {
>>       int res, eavail, timed_out = 0;
>>       unsigned long flags;
>> -     long slack;
>> +     long uninitialized_var(slack);
>>       wait_queue_t wait;
>>       struct timespec end_time;
>>       ktime_t expires, *to = NULL;
>
> Hi Viresh,
>
> This is certainly the correct thing to do if timeout cannot be negative.
>
> Al, Shawn
>
> Can timeout be negative, and if so what does it mean?

Yes timeout can be negative.  When timeout is negative it signifies an
infinite timeout.  Therefore I think the correct fix is to initialize
slack to 0.  I actually sent a patch to fix this back in November, but
it looks like it was never applied.

https://lkml.org/lkml/2010/11/27/143

Andrew, can you apply this patch?  Let me know if I need to resend.

--
Shawn
