Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab2ILO7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:59:18 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52647 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab2ILO7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:59:14 -0400
Message-ID: <5050A33E.4040203@gmail.com>
Date: Wed, 12 Sep 2012 08:59:10 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        peterz@infradead.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 3/3] perf tool: give user better message if precise is
 not supported
References: <1347295216-1202-1-git-send-email-dsahern@gmail.com> <1347295216-1202-4-git-send-email-dsahern@gmail.com> <20120911092026.GU8285@erda.amd.com> <504F3B18.90403@gmail.com> <20120911140148.GV8285@erda.amd.com> <504F4B97.3040701@gmail.com> <20120911151152.GW8285@erda.amd.com>
In-Reply-To: <20120911151152.GW8285@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/11/12 9:11 AM, Robert Richter wrote:
> On 11.09.12 08:32:55, David Ahern wrote:
>> My guess would be /usr/include/bits/errno.h:
>>
>> /* Linux has no ENOTSUP error code.  */
>> # define ENOTSUP EOPNOTSUPP
>
> Ok, so ENOTSUP is actually the same as EOPNOTSUPP. Since the syscall
> returns a EOPNOTSUPP, I prefer this when checking perf_event_open()
> return codes. ENOTSUP is not used in the kernel. Was there a reason
> for choosing ENOTSUP?

poor memory? laziness? a habit I was not aware I had acquired with using 
ENOTSUP? I mentioned in a prior response I would change it to EOPNOTSUPP 
to be consistent with the 2nd patch -- what the kernel is returning.

>
>>> If you run this bare-metal on older machines which do not support pebs
>>> or ibs, the syscall returns EOPNOTSUPP. You can trigger the same
>>> behaviour on newer systems with:
>>>
>>>    # perf record -e cycles:ppp -c 2097120 -R -a sleep 1
>>>
>>>      Error: sys_perf_event_open() syscall returned with 95 (Operation not supported).  /bin/dmesg may provide additional information.
>>>    ...
>>>
>>> It should work in this case too.
>>
>> The commit message was a copy and paste from the failure of both :p in a
>> VM (PEBS is not supported in a VM). I also ran the bare metal case with
>> :pG which per the second patch in this series generates the not
>> supported message.
>
> Since the error codes are the same, your code should work also on
> bare-metal. Can you test on a host using :ppp? This should trigger the
> same error message as in a vm.

As expected:
$ perf record -e cycles:ppp -a
Error:
'precise' request not supported. Try removing 'p' modifier

Resending patchset in a few minutes.

David
