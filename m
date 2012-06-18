Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab2FRNML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 09:12:11 -0400
Received: from mx2.parallels.com ([64.131.90.16]:47748 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab2FRNMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 09:12:09 -0400
Message-ID: <4FDF2890.3020004@parallels.com>
Date: Mon, 18 Jun 2012 17:09:36 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Wanpeng Li <liwp.linux@gmail.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm/memcg: add unlikely to mercg->move_charge_at_immigrate
References: <1340025022-7272-1-git-send-email-liwp.linux@gmail.com>
In-Reply-To: <1340025022-7272-1-git-send-email-liwp.linux@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 05:10 PM, Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>
> move_charge_at_immigrate feature is disabled by default. Charges
> are moved only when you move mm->owner and it also add additional
> overhead.

How big is this overhead?

That's hardly a fast path. And if it happens to matter, it will be just 
bigger when you enable it, and the compiler start giving the wrong hints 
to the code.
