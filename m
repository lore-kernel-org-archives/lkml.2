Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab1ISSlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:41:12 -0400
Received: from mx2.parallels.com ([64.131.90.16]:35938 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932338Ab1ISSlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:41:11 -0400
Message-ID: <4E778C94.2060007@parallels.com>
Date: Mon, 19 Sep 2011 15:40:20 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <xemul@parallels.com>,
        <paul@paulmenage.org>, <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <mingo@elte.hu>, <jbottomley@parallels.com>
Subject: Re: [PATCH 4/9] Include irq and softirq fields in cpuacct
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>  <1316030695-19826-5-git-send-email-glommer@parallels.com> <1316457505.6091.14.camel@twins>
In-Reply-To: <1316457505.6091.14.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.106.51.14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2011 03:38 PM, Peter Zijlstra wrote:
> On Wed, 2011-09-14 at 17:04 -0300, Glauber Costa wrote:
>> +       CPUACCT_STAT_IRQ,       /* ... irq ticks */
>> +       CPUACCT_STAT_SOFTIRQ,   /* ... softirq ticks */
>
> Would it make sense to make the cpustat thing an array as well? That way
> the if forest will compute an array index and the cgroup and cpustat
> parts can then use the 'same' code.
>
> That avoids having to pass a cputime64_t* and int around for pretty much
> the same thing.
I think so, and I go further: I think that when cgroups are compiled in 
- by far the common case this days - cpustat should be just cpuacct for 
the root cgroup. With the right macro trickery, I can even be quite 
transparent...
