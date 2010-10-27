Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab0J0OoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:44:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:52940 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab0J0OoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:44:22 -0400
Message-ID: <4CC83A85.3070608@kernel.org>
Date: Wed, 27 Oct 2010 16:43:17 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>	 <1288158182-1753-1-git-send-email-brgerst@gmail.com>	 <1288159670.2652.181.camel@edumazet-laptop>	 <1288173442.15336.1490.camel@twins>	 <1288186405.2709.117.camel@edumazet-laptop>  <4CC82C2F.1020707@kernel.org>	 <1288187870.2709.128.camel@edumazet-laptop>  <4CC83067.5000009@kernel.org>	 <1288189461.2709.144.camel@edumazet-laptop> <1288190387.2709.147.camel@edumazet-laptop>
In-Reply-To: <1288190387.2709.147.camel@edumazet-laptop>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Oct 2010 14:43:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 04:39 PM, Eric Dumazet wrote:
> Le mercredi 27 octobre 2010 à 16:24 +0200, Eric Dumazet a écrit :
>> Le mercredi 27 octobre 2010 à 16:00 +0200, Tejun Heo a écrit :
>>
>>> Heh, interesting table.  What does the same code say on 64bit?  Is it
>>> the same?
>>>
>>
>> Yes this is the same
> 
> Oops sorry :!)
> 
> On 64bit kernel, the 16 'possible but not online' cpus are not on node
> 0, but balanced between two nodes.

Ah, okay, that explains it.  So, your NUMA table is screwed up.  It
would be interesting to dig down where the difference between 32 and
64bit comes from.  Maybe it's coming from differences in our init code
rather than from BIOS?

-- 
tejun
