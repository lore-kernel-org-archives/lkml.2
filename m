Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab1JMUGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 16:06:37 -0400
Received: from mx2.parallels.com ([64.131.90.16]:53700 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab1JMUGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 16:06:34 -0400
Message-ID: <4E9744A6.5010101@parallels.com>
Date: Fri, 14 Oct 2011 00:05:58 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <lizf@cn.fujitsu.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <ebiederm@xmission.com>, <paul@paulmenage.org>, <gthelen@google.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>, <kirill@shutemov.name>,
        <avagin@parallels.com>, <devel@openvz.org>
Subject: Re: [PATCH v7 0/8] Request for inclusion: tcp memory buffers
References: <1318511382-31051-1-git-send-email-glommer@parallels.com> <20111013.160031.605700447623532119.davem@davemloft.net>
In-Reply-To: <20111013.160031.605700447623532119.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [195.68.147.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 12:00 AM, David Miller wrote:
> From: Glauber Costa<glommer@parallels.com>
> Date: Thu, 13 Oct 2011 17:09:34 +0400
>
>> This series was extensively reviewed over the past month, and after
>> all major comments were merged, I feel it is ready for inclusion when
>> the next merge window opens. Minor fixes will be provided if they
>> prove to be necessary.
>
> I'm not applying this.

Thank you for letting me now about your view of this that early.

> You're turning inline increments and decrements of the existing memory
> limits into indirect function calls.

Yes, indeed.

> That imposes a new non-trivial cost, in fast paths, even when people
> do not use your feature.
Well, there is a cost, but all past submissions included round trip 
benchmarks.
In none of them I could see any significant slowdown.

> Make this evaluate into exactly the same exact code stream we have
> now when the memory cgroup feature is not in use, which will be the
> majority of users.

What exactly do you mean by "not in use" ? Not compiled in or not 
actively being exercised ? If you mean the later, I appreciate tips on 
how to achieve it.

Also, I kind of dispute the affirmation that !cgroup will encompass
the majority of users, since cgroups is being enabled by default by
most vendors. All systemd based systems use it extensively, for instance.


