Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab1FIUNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:13:08 -0400
Received: from outmail004.snc4.facebook.com ([66.220.144.136]:64596 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753574Ab1FIUNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:13:04 -0400
Message-ID: <4DF12974.7030707@fb.com>
Date: Thu, 09 Jun 2011 13:13:40 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Sam Liao <phyomh@gmail.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [perf] Add inverted call graph report support.
References: <BANLkTi=svHgWzyKiEHjMc-j5Hq4y5R8Mow@mail.gmail.com> <20110609193300.GA16858@dev1756.snc6.facebook.com> <4DF128B1.4010409@gmail.com>
In-Reply-To: <4DF128B1.4010409@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/9/11 1:10 PM, David Ahern wrote:
>
>
> On 06/09/2011 01:33 PM, Arun Sharma wrote:
>> On Thu, Jun 09, 2011 at 02:44:19PM +0800, Sam Liao wrote:
>>> --- a/tools/perf/util/session.c
>>> +++ b/tools/perf/util/session.c
>>> @@ -247,9 +247,14 @@ int perf_session__resolve_callchain(struct
>>> perf_session *self,
>>>   	callchain_cursor_reset(&self->callchain_cursor);
>>>
>>>   	for (i = 0; i<  chain->nr; i++) {
>>> -		u64 ip = chain->ips[i];
>>> +		u64 ip;
>>>   		struct addr_location al;
>>>
>>> +		if (callchain_param.order == ORDER_CALLEE)
>>> +			ip = chain->ips[i];
>>> +		else
>>> +			ip = chain->ips[chain->nr - i - 1];
>>
>> This can dereference a bad pointer if chain->nr == 0.
>
> Should not enter the loop if chain->nr is 0 (See for arg).

Ah right. I had this problem with an earlier version of the patch. This 
version seems to be fine.

  -Arun
