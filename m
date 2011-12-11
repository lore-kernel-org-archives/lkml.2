Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab1LKUpf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 15:45:35 -0500
Received: from mx2.parallels.com ([64.131.90.16]:50115 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab1LKUpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 15:45:32 -0500
Message-ID: <4EE51646.3030900@parallels.com>
Date: Sun, 11 Dec 2011 21:44:54 +0100
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <jbottomley@parallels.com>,
        <cgroups@vger.kernel.org>, <bsingharora@gmail.com>, <devel@openvz.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <tj@kernel.org>
Subject: Re: [PATCH 1/3] nitpick: make simple functions inline
References: <1323614738-7405-1-git-send-email-glommer@parallels.com> <1323614738-7405-3-git-send-email-glommer@parallels.com> <4EE4FCBB.9050600@gmail.com>
In-Reply-To: <4EE4FCBB.9050600@gmail.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [83.149.9.224]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2011 07:55 PM, KOSAKI Motohiro wrote:
>> -static int notify_on_release(const struct cgroup *cgrp)
>> +static inline int notify_on_release(const struct cgroup *cgrp)
>>    {
>>    	return test_bit(CGRP_NOTIFY_ON_RELEASE,&cgrp->flags);
>>    }
>>
>> -static int clone_children(const struct cgroup *cgrp)
>> +static inline int clone_children(const struct cgroup *cgrp)
>>    {
>>    	return test_bit(CGRP_CLONE_CHILDREN,&cgrp->flags);
>>    }
> 
> Can you please tell us which compiler failed automatic inlining?
> I suspect gcc is enough sane and we don't need this patch.

Of course we don't need, that's the very definition of a "nitpick".
This patch is directed towards the reader, not the compiler. Maintainers
are free to take it or not, although I believe being explicit is better.

