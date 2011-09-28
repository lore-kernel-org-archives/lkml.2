Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab1I1PkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:40:04 -0400
Received: from mx2.parallels.com ([64.131.90.16]:47004 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983Ab1I1PkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:40:03 -0400
Message-ID: <4E833F96.1050106@parallels.com>
Date: Wed, 28 Sep 2011 12:39:02 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <jbottomley@parallels.com>, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFD 4/9] Make total_forks per-cgroup
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>    <1316816432-9237-5-git-send-email-glommer@parallels.com>    <1317160837.21836.21.camel@twins> <20110928101357.5a90c2ab@de.ibm.com>    <1317206124.20318.6.camel@twins> <20110928144218.6a4882e5@de.ibm.com>   <1317214418.24040.13.camel@twins> <4E833D6D.1030407@parallels.com>  <1317224038.24040.52.camel@twins> <4E833ED4.4020205@parallels.com> <1317224258.24040.53.camel@twins>
In-Reply-To: <1317224258.24040.53.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.46.219.221]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2011 12:37 PM, Peter Zijlstra wrote:
> On Wed, 2011-09-28 at 12:35 -0300, Glauber Costa wrote:
>>
>> So let me get this straight: The proposal here is really to get rid of
>> all cputime_t , not only cputime64_t ?
>
> For now cputime64_t would be sufficient, just wanted to extend the
> argument with Martin to see if we really need the cputime*() trickery at
> all.
>
>
Well, at least the 64-bit part I can do myself in this series, since I 
am already touching it. I'd keep a transition point in which we convert 
ticks to u64 whenever needed, and we can get rid of it later if you 
really ditch cputime_t
