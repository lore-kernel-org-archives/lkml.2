Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab1LGLHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 06:07:12 -0500
Received: from mx2.parallels.com ([64.131.90.16]:34359 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924Ab1LGLHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 06:07:10 -0500
Message-ID: <4EDF48A9.6090306@parallels.com>
Date: Wed, 7 Dec 2011 09:06:17 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <lizf@cn.fujitsu.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <ebiederm@xmission.com>, <davem@davemloft.net>, <gthelen@google.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>, <kirill@shutemov.name>,
        <avagin@parallels.com>, <devel@openvz.org>, <eric.dumazet@gmail.com>,
        <cgroups@vger.kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>
Subject: Re: [PATCH v8 0/9] per-cgroup tcp memory pressure controls
References: <1323120903-2831-1-git-send-email-glommer@parallels.com>
In-Reply-To: <1323120903-2831-1-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 07:34 PM, Glauber Costa wrote:
> Hi,
>
> This is my new attempt to fix all the concerns that were raised during
> the last iteration.
>
> I should highlight:
> 1) proc information is kept intact. (although I kept the wrapper functions)
>     it will be submitted as a follow up patch so it can get the attention it
>     deserves
> 2) sockets now hold a reference to memcg. sockets can be alive even after the
>     task is gone, so we don't bother with between cgroups movements.
>     To be able to release resources more easily in this cenario, the parent
>     pointer in struct cg_proto was replaced by a memcg object. We then iterate
>     through its pointer (which is cleaner anyway)
>
> The rest should be mostly the same except for small fixes and style changes.
>

Kame,

Does this one address your previous concerns?

Thanks
