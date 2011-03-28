Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab1C1FDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 01:03:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab1C1FDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 01:03:32 -0400
Message-ID: <4D90167F.5080308@redhat.com>
Date: Mon, 28 Mar 2011 13:02:55 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric B Munson <emunson@mgebm.net>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Patch] proc: check error pointer returned by m_start()
References: <20110327175203.GA15862@fibrous.localdomain> <1301284006-18808-1-git-send-email-amwang@redhat.com> <AANLkTi=mqKF=xeMYbj9LZgPfSLHSkO1JRXsNTW3LyHqu@mail.gmail.com>
In-Reply-To: <AANLkTi=mqKF=xeMYbj9LZgPfSLHSkO1JRXsNTW3LyHqu@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年03月28日 11:58, Linus Torvalds 写道:
> On Sun, Mar 27, 2011 at 8:46 PM, Amerigo Wang<amwang@redhat.com>  wrote:
>>
>> This is true, that commit changed the return value of m_start(),
>> which will return an error pointer on failure, but Al forgot
>> to check the error pointer in m_stop() which will be called
>> when m_start() fails. This patches fixes it.
>
> I did this slightly differently, and put the check in m_stop()
> instead, because I felt that matched the logic of m_start, while
> vma_stop() is more of an internal helper thing.
>

Ok, I am fine with this, will send an updated patch.

> I dunno. I don't think it matters. But one thing I reacted to was that
> when I was walking through the logic, I really wanted to say "seq_file
> is wrong to call m_stop if m_start returned an error code". I really
> felt like "hwy, if ->start fails, we damn well shouldn't have called
> ->stop".


This is a good point and makes prefect sense.

>
> But I guess we're stuck with that particular semantic for seq_files by now.
>

Yup, I guess there are some seq_file users still rely on this behavior,
we can fix them all later.

Thanks.
