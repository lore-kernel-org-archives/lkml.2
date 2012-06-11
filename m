Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab2FKSXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 14:23:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53581 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab2FKSXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 14:23:51 -0400
Message-ID: <4FD637B2.3010100@gmail.com>
Date: Mon, 11 Jun 2012 12:23:46 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Tim Chen <tim.c.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, ak@linux.intel.com,
        Stephane Eranian <eranian@google.com>
Subject: Re: Does perf inject preserve call chain data?
References: <1337712585.3796.186.camel@schen9-DESK>  <4FBC0C10.8010801@gmail.com>  <20120608143843.GA9954@infradead.org>  <1339173896.3796.230.camel@schen9-DESK>  <4FD232B7.7080905@gmail.com> <1339175828.3796.232.camel@schen9-DESK>
In-Reply-To: <1339175828.3796.232.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/8/12 11:17 AM, Tim Chen wrote:
> On Fri, 2012-06-08 at 11:13 -0600, David Ahern wrote:
>> On 6/8/12 10:44 AM, Tim Chen wrote:
>>> On Fri, 2012-06-08 at 11:38 -0300, Arnaldo Carvalho de Melo wrote:
>>>> Em Tue, May 22, 2012 at 03:58:40PM -0600, David Ahern escreveu:
>>>>> On 5/22/12 12:49 PM, Tim Chen wrote:
>>>>>> Arnaldo,
>>>>>>
>>>>>> Wonder if perf inject munged the call chain data from perf record?
>>>>>>
>>>>>> When I do
>>>>>> perf record -a -g -o - sleep 5 |perf inject -v -b  | perf report  -g -i -
>>>>>> I get a complain from perf report
>>>>>>
>>>>>> Warning:
>>>>>> Selected -g but no callchain data. Did you call 'perf record' without -g?
>>>>>>
>>>>>
>>>>> I believe the root cause is that the event list is not written to
>>>>> the pipe. Using Arnaldo's git repo as of today (has fixes from
>>>>> Stephane) this hack shows the info is there and can be processed.
>>>>
>>>> How things stand here? Tim, did this fix things for you? If so, David,
>>>> please resend with a proper subject line and a Tested-by: Tim, ok?

Pipeline is broken by this commit in your urgent (but not yet pushed) tree:

commit 47832ad3e101e470a90fab9b4915549aaee03662
Author: Dmitry Antipov <dmitry.antipov@linaro.org>
Date:   Fri Jun 8 16:23:27 2012 +0400

     perf report: Fix event name reporting in cross analysis

     Use trace_find_event to find event name before looking through /sys
     files. This helps 'perf report' to show real event names instead of
     'unknown:unknown' when processing perf.data recorded on another 
machine.


pevent might be NULL and pevent_find_event dereferences it causing a crash.

David
