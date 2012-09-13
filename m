Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab2IMEdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 00:33:43 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42605 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab2IMEdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 00:33:41 -0400
Message-ID: <50516220.7060507@gmail.com>
Date: Wed, 12 Sep 2012 22:33:36 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        peterz@infradead.org, Ingo Molnar <mingo@kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 2/3] perf: require exclude_guest to use PEBS - kernel
 side enforcement
References: <1347462990-29481-1-git-send-email-dsahern@gmail.com> <1347462990-29481-3-git-send-email-dsahern@gmail.com> <87392mabqn.fsf@sejong.aot.lge.com>
In-Reply-To: <87392mabqn.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/12 8:38 PM, Namhyung Kim wrote:
> Hi David,
>
> On Wed, 12 Sep 2012 09:16:29 -0600, David Ahern wrote:
>> From: Peter Zijlstra <peterz@infradead.org>
>>
>> Per Peter:
>>    "Intel PEBS in VT-x context uses the DS address as a guest linear address,
>>    even though its programmed by the host as a host linear address. This
>>    either results in guest memory corruption and or the hardware faulting and
>>    'crashing' the virtual machine.  Therefore we have to disable PEBS on VT-x
>>    enter and re-enable on VT-x exit, enforcing a strict exclude_guest.
>>
>> This patch enforces exclude_guest kernel side.
>>
> [snip]
>> @@ -380,6 +383,9 @@ int x86_pmu_hw_config(struct perf_event *event)
>>   	if (event->attr.precise_ip) {
>>   		int precise = 0;
>>
>> +		if (!event->attr.exclude_guest)
>> +				return -EOPNOTSUPP;
>
> I see a whitespace problem here. :)

grr.... an extra freaking tab.

