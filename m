Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab1IEURW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 16:17:22 -0400
Received: from li271-223.members.linode.com ([178.79.152.223]:55877 "EHLO
	mail.mleia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab1IEURR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 16:17:17 -0400
Message-ID: <4E652E41.1030308@mleia.com>
Date: Mon, 05 Sep 2011 23:17:05 +0300
From: Vladimir Zapolskiy <vz@mleia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Icedove/5.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] sched: share task comm length value to userspace
References: <1315247881-31597-1-git-send-email-vz@mleia.com> <20110905124726.28b24db4@infradead.org>
In-Reply-To: <20110905124726.28b24db4@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.09.2011 22:47, Arjan van de Ven wrote:
> On Mon,  5 Sep 2011 21:38:01 +0300
> Vladimir Zapolskiy<vz@mleia.com>  wrote:
>
>> This change allows to get a defined length of task comm in
>> userspace. For a moment this value is implied at least in two cases:
>> * max length of comm value got from /proc/$pid/stat
>> * max string length argument of prctl(PR_[SG]ET_NAME, ...)
>>
>> For these reasons it becomes desirable to impart task comm max length
>> value to userspace.
>
> I'm sorry but I don't like doing this.
>
> The moment we do this, we never can increase it anymore since userspace
> might be using it for its own uses and we'd break it if we changed
> this value.
Thanks for a comment. Your objections are quite clear, and I don't like 
this solution as well, but eventually having that value in userspace is 
really desirable. However in assumption that this value is preserved 
fixed and won't be changed in reasonable perspective, the presented 
approach becomes the most evident and simple.

>
> If we need to export this, we should export it in /proc or /sys
> somewhere as a dynamic value.....
>
Let's do it in a proper way. What's the common practice to export such 
limit values? I suppose via /proc/sys/kernel, please correct me, if I'm 
wrong.

--
With best wishes,
Vladimir
