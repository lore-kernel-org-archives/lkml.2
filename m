Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab1JMUPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 16:15:49 -0400
Received: from mx2.parallels.com ([64.131.90.16]:42175 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab1JMUPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 16:15:48 -0400
Message-ID: <4E9746B0.7030603@parallels.com>
Date: Fri, 14 Oct 2011 00:14:40 +0400
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
References: <1318511382-31051-1-git-send-email-glommer@parallels.com> <20111013.160031.605700447623532119.davem@davemloft.net> <4E9744A6.5010101@parallels.com> <20111013.161221.1969725742975317077.davem@davemloft.net>
In-Reply-To: <20111013.161221.1969725742975317077.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [195.68.147.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 12:12 AM, David Miller wrote:
> From: Glauber Costa<glommer@parallels.com>
> Date: Fri, 14 Oct 2011 00:05:58 +0400
>
>> Also, I kind of dispute the affirmation that !cgroup will encompass
>> the majority of users, since cgroups is being enabled by default by
>> most vendors. All systemd based systems use it extensively, for
>> instance.
>
> I will definitely advise people against this, since the cost of having
> this on by default is absolutely non-trivial.
>
> People keep asking every few releases "where the heck has my performance
> gone" and it's because of creeping features like this.  This socket
> cgroup feature is a prime example of where that kind of stuff comes
> from.
>
> I really get irritated when people go "oh, it's just one indirect
> function call" and "oh, it's just one more pointer in struct sock"
>
> We work really hard to _remove_ elements from structures and make them
> smaller, and to remove expensive operations from the fast paths.
>
> It might take someone weeks if not months to find a way to make a
> patch which compensates for the extra overhead your patches are adding.
>
> And I don't think you fully appreciate that.

Let's focus on this:
Are you happy, or at least willing to accept, an approach that keep 
things as they were with cgroups *compiled out*, or were you referring 
to not in use == compiled in, but with no users?

