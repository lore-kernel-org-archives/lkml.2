Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab1ANJjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:39:05 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:51520 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753339Ab1ANJiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:38:55 -0500
Message-ID: <4D30198D.9080206@st.com>
Date: Fri, 14 Jan 2011 15:08:21 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jack Stone <jwjstone@fastmail.fm>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] fs/eventpoll.c: fix compilation warning
References: <1294989352-2003-1-git-send-email-viresh.kumar@st.com> <2426ea8f-7e52-4329-bf20-884c2b996f98@email.android.com>
In-Reply-To: <2426ea8f-7e52-4329-bf20-884c2b996f98@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2011 03:03 PM, Jack Stone wrote:
>> >-	long slack;
>> >+	long slack = 0;
>> > 	wait_queue_t wait;
>> > 	struct timespec end_time;
>> > 	ktime_t expires, *to = NULL;
> I don't think this is the correct fix. This function is fine unless timeout is negative.
> 
> If a negative timeout is possible then this function will create timer far in the future.
>I'll leave it up to the maintainer how to solve that one. The two solutions I can see are making
>timeout unsigned or extending the bottom case of the if to <=0.
> 
> Either way we should use uninitalized_var() rather than setting it to zero.

Using uninitialized var gives compilation warning, How should we fix that.

-- 
viresh
