Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab2FSAFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 20:05:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40128 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab2FSAFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 20:05:24 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FDFC179.3050203@jp.fujitsu.com>
Date: Tue, 19 Jun 2012 09:02:01 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwp.linux@gmail.com>
CC: Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm/memcg: add unlikely to mercg->move_charge_at_immigrate
References: <1340025022-7272-1-git-send-email-liwp.linux@gmail.com> <4FDF2890.3020004@parallels.com> <20120618131918.GA2600@kernel>
In-Reply-To: <20120618131918.GA2600@kernel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/18 22:19), Wanpeng Li wrote:
> On Mon, Jun 18, 2012 at 05:09:36PM +0400, Glauber Costa wrote:
>> On 06/18/2012 05:10 PM, Wanpeng Li wrote:
>>> From: Wanpeng Li<liwp@linux.vnet.ibm.com>
>>>
>>> move_charge_at_immigrate feature is disabled by default. Charges
>>> are moved only when you move mm->owner and it also add additional
>>> overhead.
>>
>> How big is this overhead?
>>
>> That's hardly a fast path. And if it happens to matter, it will be
>> just bigger when you enable it, and the compiler start giving the
>> wrong hints to the code.
>
> Thank you for your quick response.
>
> Oh, Maybe I should just write comments "move_charge_at_immigrate feature
> is disabled by default. So add "unlikely", in order to compiler can optimize."
>

This doesn't affect the performance. likely/unlikely which doesn't affect
performance is never welcomed.

Thanks,
-Kame

