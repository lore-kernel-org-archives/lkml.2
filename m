Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab1CTTtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 15:49:23 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:39869 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab1CTTtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 15:49:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABX3hU2tJV2d/2dsb2JhbAClbXeITZsxmw+CfoJlBIUzhzSDUQ
X-IronPort-AV: E=Sophos;i="4.63,216,1299456000"; 
   d="scan'208";a="349378082"
Message-ID: <4D865A3E.9040605@cisco.com>
Date: Sun, 20 Mar 2011 13:49:18 -0600
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org
Subject: Re: [PATCH 1/5] perf events: add support for realtime clock attribute
References: <1300647277-8431-1-git-send-email-daahern@cisco.com> <1300647277-8431-2-git-send-email-daahern@cisco.com> <alpine.LFD.2.00.1103202000500.2787@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103202000500.2787@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/20/11 13:08, Thomas Gleixner wrote:
> On Sun, 20 Mar 2011, David Ahern wrote:
>> +
>> +	if (sample_type & PERF_SAMPLE_REALTIME)
>> +		data->realtime = ktime_to_ns(ktime_get_real());
> 
> That's going to live lock on any sample which happens to hit in a
> xtime_lock write locked section. I knew why I suggested adding
> tracepoints to the timekeeping code :)

Hmmm.... Can you give an example of when perf samples could be generated
with xtime write locked? What are the rules for when ktime_get_real can
be invoked?

David

> 
> Thanks,
> 
> 	tglx
