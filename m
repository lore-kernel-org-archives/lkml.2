Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab1EXIto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 04:49:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41044 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab1EXItn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 04:49:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDB711B.8010408@jp.fujitsu.com>
Date: Tue, 24 May 2011 17:49:31 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: minchan.kim@gmail.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, rientjes@google.com,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, oleg@redhat.com
Subject: Re: [PATCH 4/5] oom: don't kill random process
References: <4DD61F80.1020505@jp.fujitsu.com>	<4DD6207E.1070300@jp.fujitsu.com>	<BANLkTinaHki1oA4O3+FsoPDtFTLfqwRadA@mail.gmail.com>	<4DDB0FB2.9050300@jp.fujitsu.com> <BANLkTinKm=m8zdPGN0Trpy4HtEFyxMYzPA@mail.gmail.com>
In-Reply-To: <BANLkTinKm=m8zdPGN0Trpy4HtEFyxMYzPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/24 17:46), Minchan Kim wrote:
> On Tue, May 24, 2011 at 10:53 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
>>>> +       /*
>>>> +        * chosen_point==1 may be a sign that root privilege bonus is too
>>>> large
>>>> +        * and we choose wrong task. Let's recalculate oom score without
>>>> the
>>>> +        * dubious bonus.
>>>> +        */
>>>> +       if (protect_root&&  (chosen_points == 1)) {
>>>> +               protect_root = 0;
>>>> +               goto retry;
>>>> +       }
>>>
>>> The idea is good to me.
>>> But once we meet it, should we give up protecting root privileged
>>> processes?
>>> How about decaying bonus point?
>>
>> After applying my patch, unprivileged process never get score-1. (note,
>> mapping
>> anon pages naturally makes to increase nr_ptes)
> 
> Hmm, If I understand your code correctly, unprivileged process can get
> a score 1 by 3% bonus.

3% bonus is for privileged process. :)


> So after all, we can get a chosen_point with 1.
> Why I get a chosen_point with 1 is as bonus is rather big, I think.
> So I would like to use small bonus than first iteration(ie, decay bonus).
> 
>>
>> Then, decaying don't make any accuracy. Am I missing something?
> 
> Maybe I miss something.  :(
> 
> 
> 
> 


