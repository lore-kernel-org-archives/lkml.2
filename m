Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab0HRIxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 04:53:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab0HRIxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 04:53:16 -0400
Message-ID: <4C6BA077.2080306@redhat.com>
Date: Wed, 18 Aug 2010 16:57:27 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Brice Goglin <Brice.Goglin@inria.fr>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 2/2] Makefile: "make kernelrelease" should show the correct
 full kernel version
References: <20100628030507.5187.95903.sendpatchset@localhost.localdomain> <20100628030516.5187.49089.sendpatchset@localhost.localdomain> <4C6B88A5.4050305@inria.fr> <4C6B957C.1090308@redhat.com> <4C6B9BFE.1030308@inria.fr>
In-Reply-To: <4C6B9BFE.1030308@inria.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/10 16:38, Brice Goglin wrote:
> Le 18/08/2010 10:10, Cong Wang a écrit :
>> On 08/18/10 15:15, Brice Goglin wrote:
>>> This patch (actually 01ab17887 in 2.6.36-rc1) reveals what looks like a
>>> problem to me: make kernelrelease always regenerates
>>> include/config/kernel.release even if it's already more recent than
>>> include/config/auto.conf. Is this the expected behavior? Do we really
>>> need include/config/kernel.release to depend on FORCE?
>>>
>>
>> I think so, because "LOCALVERSION=" can be given from command line,
>> so we need to regenerate it.
>>
>> Or am I missing your point here?
>>
>
> Interesting. I assumed "make kernelrelease" was mainly here to display
> the release string (which means you would not need write access to the
> kernel build dir). And indeed make help says:
>    kernelrelease      - Output the release version string
> Right now, it looks like "update the version string and by the way
> display it too" (and you need write access).
>

I believe you will also need write access even without this patch,
if you compile a fresh kernel. So your assumption is not correct.

-- 
The opposite of love is not hate, it's indifference.
  - Elie Wiesel
