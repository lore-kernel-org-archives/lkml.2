Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab0HRI4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 04:56:47 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:52719 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751643Ab0HRI4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 04:56:45 -0400
X-IronPort-AV: E=Sophos;i="4.56,226,1280700000"; 
   d="scan'208";a="57487861"
Message-ID: <4C6B9F53.6040100@inria.fr>
Date: Wed, 18 Aug 2010 10:52:35 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 2/2] Makefile: "make kernelrelease" should show the correct
 full kernel version
References: <20100628030507.5187.95903.sendpatchset@localhost.localdomain> <20100628030516.5187.49089.sendpatchset@localhost.localdomain> <4C6B88A5.4050305@inria.fr> <4C6B957C.1090308@redhat.com> <4C6B9BFE.1030308@inria.fr> <4C6BA077.2080306@redhat.com>
In-Reply-To: <4C6BA077.2080306@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 18/08/2010 10:57, Cong Wang a écrit :
> On 08/18/10 16:38, Brice Goglin wrote:
>> Le 18/08/2010 10:10, Cong Wang a écrit :
>>> On 08/18/10 15:15, Brice Goglin wrote:
>>>> This patch (actually 01ab17887 in 2.6.36-rc1) reveals what looks
>>>> like a
>>>> problem to me: make kernelrelease always regenerates
>>>> include/config/kernel.release even if it's already more recent than
>>>> include/config/auto.conf. Is this the expected behavior? Do we really
>>>> need include/config/kernel.release to depend on FORCE?
>>>>
>>>
>>> I think so, because "LOCALVERSION=" can be given from command line,
>>> so we need to regenerate it.
>>>
>>> Or am I missing your point here?
>>>
>>
>> Interesting. I assumed "make kernelrelease" was mainly here to display
>> the release string (which means you would not need write access to the
>> kernel build dir). And indeed make help says:
>>    kernelrelease      - Output the release version string
>> Right now, it looks like "update the version string and by the way
>> display it too" (and you need write access).
>>
>
> I believe you will also need write access even without this patch,
> if you compile a fresh kernel. So your assumption is not correct.
>

If I revert 01ab17887f4, I don't need write access. Things always worked
fine before 2.6.36 as far I remember.

Brice

