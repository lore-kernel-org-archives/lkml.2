Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab2ENOVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 10:21:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54515 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab2ENOVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 10:21:06 -0400
Message-ID: <4FB114CE.10904@gmail.com>
Date: Mon, 14 May 2012 08:21:02 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung.kim@lge.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf-record: Create events initially disabled -- again
References: <1336968088-11531-1-git-send-email-dsahern@gmail.com> <87sjf31a8c.fsf@sejong.aot.lge.com> <4FB1041C.1050903@gmail.com>
In-Reply-To: <4FB1041C.1050903@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/12 7:09 AM, David Ahern wrote:
>> A problem I see is that it'll break group handling again:
>>
>> $ ./perf stat -g sleep 1
>>
>> Performance counter stats for 'sleep 1':
>>
>> <not counted> task-clock
>> <not counted> context-switches
>> <not counted> CPU-migrations
>> <not counted> page-faults
>> <not counted> cycles
>> <not counted> stalled-cycles-frontend
>> <not counted> stalled-cycles-backend
>> <not counted> instructions
>> <not counted> branches
>> <not counted> branch-misses
>>
>> 1.000868932 seconds time elapsed
>>
>> So I suggest changing perf_target__none() check to a proper one
>> (perf_target__no_cpu? - the name might be changed soon) for your
>> purpose.
>>
>> Thanks,
>> Namhyung
>
> Something else is wrong then. I tested that command (saw your patch in
> the history) and it worked for me. Also, this code path does not affect
> perf-stat -- it touches perf-record and perf-test only.

I think it is something else. I am running latest git tree (3.4.0-rc7). 
perf from Linus' tree and acme/core both show:

perf stat -g  -- find /usr >/dev/null

  Performance counter stats for 'find /usr':

      <not counted> task-clock
      <not counted> context-switches
      <not counted> CPU-migrations
      <not counted> page-faults
      <not counted> cycles
      <not counted> stalled-cycles-frontend
      <not counted> stalled-cycles-backend
      <not counted> instructions
      <not counted> branches
      <not counted> branch-misses

        0.111976940 seconds time elapsed


(Using find to make sure some work is done as opposed to sleep; openssl 
speed also shows the above.)

David
