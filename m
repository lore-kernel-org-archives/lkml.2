Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab1I2Wza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:55:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33051 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab1I2Wz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:55:27 -0400
Message-ID: <4E84F75B.3050105@gmail.com>
Date: Thu, 29 Sep 2011 16:55:23 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Jiri Olsa <jolsa@redhat.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
        paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Exit recording if events have non matching
 sample type
References: <1317312068-10411-1-git-send-email-jolsa@redhat.com> <20110929220548.GA17597@ghostprotocols.net>
In-Reply-To: <20110929220548.GA17597@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/29/2011 04:05 PM, Arnaldo Carvalho de Melo wrote:
> Em Thu, Sep 29, 2011 at 06:01:08PM +0200, Jiri Olsa escreveu:
>> The event processing relies on all events having the same sample_type.
>>
>> This is being checked when the session is being opened read only.
>> It also needs to be checked when we do record, since events could be
>> read during processing build IDs at the end of the record command.
>>
>> If we process events with different sample_type the processing might
>> skip some events or hang.
>>
>> Following command hangs on my setup:
>>   ./perf record -o perf.data -e ext4:ext4_mb_new_group_pa \
>>    -e LLC-loads -- date '+%F'
>>
>> because hardware and tracepoint events have different sample type.
>>
>> With the patch applied the record command displays
>> "Non matching sample_type" message and exits.
> 
> That is way too cryptic :-\
> 
> What is that makes the sample type not match in this case? Can we make
> it match instead?
> 
> This is something to be properly fixed by _allowing_ non matching sample
> types, the evsel/evlist abstractions are getting we close but not there
> yet, multiple files in a perf.data/ directory are needed.

>From what I can see sample_type has to be the same for all samples:
https://lkml.org/lkml/2011/8/15/6


