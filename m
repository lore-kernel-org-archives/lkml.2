Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab1LLWQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:16:03 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51263 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754185Ab1LLWQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:16:00 -0500
Message-ID: <4EE67CB5.7000404@fb.com>
Date: Mon, 12 Dec 2011 14:14:13 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>, Andy Lutomirski <luto@MIT.EDU>
Subject: Re: [PATCH 2/2] Add a thread cpu time implementation to vDSO
References: <1323718578-1157-1-git-send-email-asharma@fb.com>   <1323718578-1157-3-git-send-email-asharma@fb.com>  <1323720791.2583.23.camel@edumazet-laptop> <4EE66FE9.1050202@fb.com> <1323725243.2583.27.camel@edumazet-laptop>
In-Reply-To: <1323725243.2583.27.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-12_10:2011-12-12,2011-12-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/11 1:27 PM, Eric Dumazet wrote:

> This only works if CONFIG_X86_L1_CACHE_SHIFT=6
>
> Some configurations have 128 bytes cache lines
>

I could still handle this case based on compile time math.

> But really most modern distros have NR_CPUS>  64

Is 256 the new 64? :)

That'll require 3 more VVAR pages, most of which would be unused on the 
vast majority of the systems (assuming 32 CPUs or less).

Having the number of VVAR pages configurable at boot time would solve 
this problem nicely. I think that should be a separate patch.

  -Arun
