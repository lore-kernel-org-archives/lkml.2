Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab1AaNdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:33:43 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:39635 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515Ab1AaNdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:33:42 -0500
Message-ID: <4D46BA25.8080201@free.fr>
Date: Mon, 31 Jan 2011 14:33:25 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: akpm@linux-foundation.org, ebiederm@xmission.com,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        clg@fr.ibm.com
Subject: Re: [PATCH 2/4] pidns: Call pid_ns_prepare_proc from	create_pid_namespace
References: <1296469525-30111-1-git-send-email-daniel.lezcano@free.fr> <1296469525-30111-3-git-send-email-daniel.lezcano@free.fr> <20110131132207.GA26995@redhat.com>
In-Reply-To: <20110131132207.GA26995@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 02:22 PM, Oleg Nesterov wrote:
> On 01/31, Daniel Lezcano wrote:
>> @@ -96,6 +97,9 @@ static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_p
>>   	for (i = 1; i<  PIDMAP_ENTRIES; i++)
>>   		atomic_set(&ns->pidmap[i].nr_free, BITS_PER_PAGE);
>>
>> +	if (pid_ns_prepare_proc(ns))
>> +		goto out_free_map;
>> +
>>   	return ns;
> This is not right, afaics. I already sent the similar patches, but
> they were ignored ;)
>
> Please see http://marc.info/?l=linux-kernel&m=127697484000334
>
> If pid_ns_prepare_proc() fails we shouldn't blindly return ENOMEM
> and, more importantly, we need put_pid_ns(parent_ns).

Oh, ok. Right. Thanks for the pointer.

Are you ok if I replace the patch 2/4 with your patch ?
