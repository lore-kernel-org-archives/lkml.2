Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab1EXJJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 05:09:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47986 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab1EXJJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 05:09:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDB75D8.1000804@jp.fujitsu.com>
Date: Tue, 24 May 2011 18:09:44 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: minchan.kim@gmail.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, rientjes@google.com,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, oleg@redhat.com
Subject: Re: [PATCH 4/5] oom: don't kill random process
References: <4DD61F80.1020505@jp.fujitsu.com>	<4DD6207E.1070300@jp.fujitsu.com>	<BANLkTinaHki1oA4O3+FsoPDtFTLfqwRadA@mail.gmail.com>	<4DDB0FB2.9050300@jp.fujitsu.com>	<BANLkTinKm=m8zdPGN0Trpy4HtEFyxMYzPA@mail.gmail.com>	<4DDB711B.8010408@jp.fujitsu.com> <BANLkTik5tXv+k9tk2egXgmBRzcBD5Avjkw@mail.gmail.com>
In-Reply-To: <BANLkTik5tXv+k9tk2egXgmBRzcBD5Avjkw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Hmm, If I understand your code correctly, unprivileged process can get
>>> a score 1 by 3% bonus.
>>
>> 3% bonus is for privileged process. :)
> 
> OMG. Typo.
> Anyway, my point is following as.
> If chose_point is 1, it means root bonus is rather big. Right?
> If is is, your patch does second loop with completely ignore of bonus
> for root privileged process.
> My point is that let's not ignore bonus completely. Instead of it,
> let's recalculate 1.5% for example.

1) unpriviledged process can't get score 1 (because at least a process need one
   anon, one file and two or more ptes).
2) then, score=1 mean all processes in the system are privileged. thus decay won't help.

IOW, never happen privileged and unprivileged score in this case.


> 
> But I don't insist on my idea.
> Thanks.


