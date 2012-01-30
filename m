Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab2A3IGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 03:06:32 -0500
Received: from plane.gmane.org ([80.91.229.3]:53061 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab2A3IGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 03:06:31 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?UTF-8?B?SsO2cmctVm9sa2VyIFBlZXR6?= <jvpeetz@web.de>
Subject: Re: [PATCH v2] proc:  speedup /proc/stat handling
Date: Mon, 30 Jan 2012 09:06:13 +0100
Message-ID: <4F264F75.7040601@web.de>
References: <1327075164.12389.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <1327449683.14373.12.camel@edumazet-laptop>  <20120125091818.45e00b3c.kamezawa.hiroyu@jp.fujitsu.com> <1327451195.14373.28.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
X-Gmane-NNTP-Posting-Host: p5b3718ae.dip.t-dialin.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20120104 Icedove/8.0
In-Reply-To: <1327451195.14373.28.camel@edumazet-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote, on 01/25/12 01:26:
> Le mercredi 25 janvier 2012 à 09:18 +0900, KAMEZAWA Hiroyuki a écrit :
> 
>> BTW, what is the reason of this change ?
>>
>>> -	unsigned size = 4096 * (1 + num_possible_cpus() / 32);
>>> +	unsigned size = 1024 + 128 * num_possible_cpus();
>>
>> I think size of buffer is affected by the number of online cpus.
>> (Maybe 128 is enough but please add comment why 128 ?)
>>
> 
> There is no change, as 4096/32 is 128 bytes per cpu.
> 

Wrong math, only num_possible_cpus() is divided by 32. Thus,

-	unsigned size = 4096 * (1 + num_possible_cpus() / 32);
+	unsigned size = 4096 + 128 * num_possible_cpus();

<snip>
-- 
Best regards,
Jörg-Volker.

