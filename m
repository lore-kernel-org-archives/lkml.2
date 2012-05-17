Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab2EQQIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:08:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52986 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab2EQQIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:08:21 -0400
Message-ID: <4FB52270.2060505@gmail.com>
Date: Thu, 17 May 2012 10:08:16 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Feng Tang <feng.tang@intel.com>, mingo@elte.hu, a.p.zijlstra@chello.nl,
        robert.richter@amd.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] perf script: Replace "struct thread" with "struct
 addr_location" as a parameter for "process_event()"
References: <1337173155-25780-1-git-send-email-feng.tang@intel.com> <1337173155-25780-2-git-send-email-feng.tang@intel.com> <20120517154521.GB2636@infradead.org>
In-Reply-To: <20120517154521.GB2636@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/17/12 9:45 AM, Arnaldo Carvalho de Melo wrote:
> Em Wed, May 16, 2012 at 08:59:14PM +0800, Feng Tang escreveu:
>> Both perl and python script start processing events other than trace
>> points, and it's useful to pass the resolved symbol and the dso info
>> to the event handler in script for better analysis and statistics.
>>
>> Struct thread is already a member of struct addr_location, using
>> addr_location will keep the thread info, while providing additional
>> symbol and dso info if exist, so that the script itself doesn't need
>> to bother to do the symbol resolving and dso searching work.
>
> This seems ok.
>
> David, any objections or suggestions?

perf_event__preprocess_sample calls thread__find_addr_map which sets 
al->thread and the preprocess_sample is invoked prior to process_event, 
so it should be fine.

That said, I would like to test it. Unfortunately I am knee deep 
debugging some local perf breakage. Give me a couple of days to get back 
to this.

David
