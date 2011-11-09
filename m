Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab1KISDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 13:03:33 -0500
Received: from mx2.parallels.com ([64.131.90.16]:39656 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab1KISDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 13:03:31 -0500
Message-ID: <4EBAC04F.1010901@parallels.com>
Date: Wed, 9 Nov 2011 16:02:55 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <paul@paulmenage.org>, <lizf@cn.fujitsu.com>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <ebiederm@xmission.com>,
        <davem@davemloft.net>, <gthelen@google.com>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, <kirill@shutemov.name>, <avagin@parallels.com>,
        <devel@openvz.org>, <eric.dumazet@gmail.com>
Subject: Re: [PATCH v5 00/10] per-cgroup tcp memory pressure
References: <1320679595-21074-1-git-send-email-glommer@parallels.com>
In-Reply-To: <1320679595-21074-1-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 01:26 PM, Glauber Costa wrote:
> Hi all,
>
> This is my new attempt at implementing per-cgroup tcp memory pressure.
> I am particularly interested in what the network folks have to comment on
> it: my main goal is to achieve the least impact possible in the network code.
>
> Here's a brief description of my approach:
>
> When only the root cgroup is present, the code should behave the same way as
> before - with the exception of the inclusion of an extra field in struct sock,
> and one in struct proto. All tests are patched out with static branch, and we
> still access addresses directly - the same as we did before.
>
> When a cgroup other than root is created, we patch in the branches, and account
> resources for that cgroup. The variables in the root cgroup are still updated.
> If we were to try to be 100 % coherent with the memcg code, that should depend
> on use_hierarchy. However, I feel that this is a good compromise in terms of
> leaving the network code untouched, and still having a global vision of its
> resources. I also do not compute max_usage for the root cgroup, for a similar
> reason.
>
> Please let me know what you think of it.

Dave, Eric,

Can you let me know what you think of the general approach I've followed 
in this series? The impact on the common case should be minimal, or at 
least as expensive as a static branch (0 in most arches, I believe).

I am mostly interested in knowing if this a valid pursue path. I'll be 
happy to address any specific concerns you have once you're ok with the 
general approach.

Thanks!
