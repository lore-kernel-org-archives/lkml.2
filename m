Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab1KPJkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 04:40:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab1KPJki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 04:40:38 -0500
Message-ID: <4EC38511.3020006@redhat.com>
Date: Wed, 16 Nov 2011 10:40:33 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: bsingharora@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH V2] Enforce RSS+Swap rlimit
References: <4EB3FA89.6090601@redhat.com> <4EC264AA.30306@redhat.com> <4EC2FDA9.6050401@jp.fujitsu.com>
In-Reply-To: <4EC2FDA9.6050401@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 01:02 AM, KOSAKI Motohiro wrote:
> On 11/15/2011 8:10 AM, Jerome Marchand wrote:
>>
>> Change since V1: rebase on 3.2-rc1
>>
>> Currently RSS rlimit is not enforced. We can not forbid a process to exceeds
>> its RSS limit and allow it swap out. That would hurts the performance of all
>> system, even when memory resources are plentiful.
>>
>> Therefore, instead of enforcing a limit on rss usage alone, this patch enforces
>> a limit on rss+swap value. This is similar to memsw limits of cgroup.
>> If a process rss+swap usage exceeds RLIMIT_RSS max limit, he received a SIGBUS
>> signal. 
> 
> No good idea.
>  - RLIMIT_RSS has clear definition and this patch break it. you should makes
>    another rlimit at least.

I couldn't decide if we needed a new rlimit or not. I shall admit that I chose
the lazy option. If that's a problem, I can add a new rlimit, RLIMIT_MEMSW for
instance.

>  - SIGBUS can be ignored. rlimit shouldn't ignorable.

The SIGBUS can be ignored, not the rlimit: if RLIMIT_RSS is exceeded, the process
does not the memory it requested. The SIGBUS is here to notify the process that
something wrong has happened.

Thanks,
Jerome
