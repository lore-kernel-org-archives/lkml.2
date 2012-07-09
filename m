Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab2GIByJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 21:54:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62689 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2GIByH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 21:54:07 -0400
Message-ID: <4FFA39B6.4010903@gmail.com>
Date: Sun, 08 Jul 2012 19:53:58 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf lock record fails
References: <4FF7200B.5060008@gmail.com> <874npkidlb.fsf@sejong.aot.lge.com>
In-Reply-To: <874npkidlb.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/6/12 7:06 PM, Namhyung Kim wrote:
> Hi, David
>
> On Fri, 06 Jul 2012 11:27:39 -0600, David Ahern wrote:
>> What config options need to be enabled for 'perf lock record' to work?
>> I tried a number of custom builds and stock Fedora kernels. I always
>> get:
>>
>> $ perf lock record -- sleep 1
>> invalid or unsupported event: 'lock:lock_acquire'
>>
>> Though trace_lock_acquire exists, CONFIG_LOCKDEP is set, and ftrace is
>> enabled.
>>
>> What am I missing?
>>
>
> Weird. AFAICS lock_acquire and lock_release depend on CONFIG_LOCKDEP,
> and lock_acquired and lock_contented depend on CONFIG_LOCK_STAT (I guess
> it should be warned/commented somewhere?). Maybe CONFIG_EVENT_TRACING?

CONFIG_EVENT_TRACING is set.

I started a comparison with other tracepoints to see if I can decipher 
why they show up but none of the trace functions for the lock system do 
(e.g., lock_acquire), but haven't had much time to spend on it. I was 
hoping Steve or Frederic could explain it quicker. ;-)

David

