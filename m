Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2IKOdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:33:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41463 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2IKOc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:32:59 -0400
Message-ID: <504F4B97.3040701@gmail.com>
Date: Tue, 11 Sep 2012 08:32:55 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        peterz@infradead.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 3/3] perf tool: give user better message if precise is
 not supported
References: <1347295216-1202-1-git-send-email-dsahern@gmail.com> <1347295216-1202-4-git-send-email-dsahern@gmail.com> <20120911092026.GU8285@erda.amd.com> <504F3B18.90403@gmail.com> <20120911140148.GV8285@erda.amd.com>
In-Reply-To: <20120911140148.GV8285@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/11/12 8:01 AM, Robert Richter wrote:
>
> Ok, wrong question. Better would have been: Did you run it on a
> non-pebs Intel machine of an non-ibs AMD machine?

Intel: yes. VM for example. All the servers I have now are Nehalem or 
better - ie., with a PEBS.

AMD: no. I do not have any AMD-based servers.

>
>> I do not post patches without testing them. This particular patch was
>> verified in a Virtual Machine (no PEBS) and using :pG modifier.
>>
>> 'egrep -r ENOTSUP tools/perf' shows hits in 3 other files, so I am not
>> the only one using the shortcut. I'll change it in the follow up with
>> better commit messages to make it consistent with patch 2.
>
> For VM this might be valid. Don't know where ENOTSUP comes from. It is
> neither in kernel/events/ nor arch/x86/kernel/cpu/perf.

My guess would be /usr/include/bits/errno.h:

/* Linux has no ENOTSUP error code.  */
# define ENOTSUP EOPNOTSUPP


>
> If you run this bare-metal on older machines which do not support pebs
> or ibs, the syscall returns EOPNOTSUPP. You can trigger the same
> behaviour on newer systems with:
>
>   # perf record -e cycles:ppp -c 2097120 -R -a sleep 1
>
>     Error: sys_perf_event_open() syscall returned with 95 (Operation not supported).  /bin/dmesg may provide additional information.
>   ...
>
> It should work in this case too.

The commit message was a copy and paste from the failure of both :p in a 
VM (PEBS is not supported in a VM). I also ran the bare metal case with 
:pG which per the second patch in this series generates the not 
supported message.

David
