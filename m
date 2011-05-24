Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab1EXByI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:54:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55093 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab1EXByE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:54:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDB0FB2.9050300@jp.fujitsu.com>
Date: Tue, 24 May 2011 10:53:54 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: minchan.kim@gmail.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, rientjes@google.com,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, oleg@redhat.com
Subject: Re: [PATCH 4/5] oom: don't kill random process
References: <4DD61F80.1020505@jp.fujitsu.com>	<4DD6207E.1070300@jp.fujitsu.com> <BANLkTinaHki1oA4O3+FsoPDtFTLfqwRadA@mail.gmail.com>
In-Reply-To: <BANLkTinaHki1oA4O3+FsoPDtFTLfqwRadA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +       /*
>> +        * chosen_point==1 may be a sign that root privilege bonus is too large
>> +        * and we choose wrong task. Let's recalculate oom score without the
>> +        * dubious bonus.
>> +        */
>> +       if (protect_root&&  (chosen_points == 1)) {
>> +               protect_root = 0;
>> +               goto retry;
>> +       }
>
> The idea is good to me.
> But once we meet it, should we give up protecting root privileged processes?
> How about decaying bonus point?

After applying my patch, unprivileged process never get score-1. (note, mapping
anon pages naturally makes to increase nr_ptes)

Then, decaying don't make any accuracy. Am I missing something?


