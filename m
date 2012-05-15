Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab2EOBIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 21:08:43 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43813 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab2EOBIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 21:08:42 -0400
X-AuditID: 9c93016f-b7cecae000000e00-13-4fb1ac988d54
From: Namhyung Kim <namhyung.kim@lge.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf-record: Create events initially disabled -- again
References: <1336968088-11531-1-git-send-email-dsahern@gmail.com>
	<87sjf31a8c.fsf@sejong.aot.lge.com> <4FB1041C.1050903@gmail.com>
Date: Tue, 15 May 2012 10:07:03 +0900
In-Reply-To: <4FB1041C.1050903@gmail.com> (David Ahern's message of "Mon, 14
	May 2012 07:09:48 -0600")
Message-ID: <87k40e1cco.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 14 May 2012 07:09:48 -0600, David Ahern wrote:
> On 5/14/12 1:40 AM, Namhyung Kim wrote:
>> A problem I see is that it'll break group handling again:
>>
>> $ ./perf stat -g sleep 1
>>
>>   Performance counter stats for 'sleep 1':
>>
>>       <not counted>  task-clock
>>       <not counted>  context-switches
>>       <not counted>  CPU-migrations
>>       <not counted>  page-faults
>>       <not counted>  cycles
>>       <not counted>  stalled-cycles-frontend
>>       <not counted>  stalled-cycles-backend
>>       <not counted>  instructions
>>       <not counted>  branches
>>       <not counted>  branch-misses
>>
>>         1.000868932 seconds time elapsed
>>
>> So I suggest changing perf_target__none() check to a proper one
>> (perf_target__no_cpu? - the name might be changed soon) for your
>> purpose.
>>
> Something else is wrong then. I tested that command (saw your patch in
> the history) and it worked for me. Also, this code path does not
> affect perf-stat -- it touches perf-record and perf-test only.
>

Ah, right. But still wouldn't it be better changing the conditional
rather than disabling it unconditionally?

Thanks,
Namhyung
