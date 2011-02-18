Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab1BRTC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 14:02:58 -0500
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:50822 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750Ab1BRTCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 14:02:55 -0500
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Feb 2011 14:02:54 EST
Authentication-Results: rtp-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANxOXk2tJXHB/2dsb2JhbACmJXOfbJs3hV4EhQuHBoM6
X-IronPort-AV: E=Sophos;i="4.62,188,1297036800"; 
   d="scan'208";a="217276556"
Message-ID: <4D5EC01C.1030108@cisco.com>
Date: Fri, 18 Feb 2011 11:53:16 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, paulus@samba.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] perf events: add timehist option to record and report
References: <1298008433-22911-1-git-send-email-daahern@cisco.com> <1298008433-22911-4-git-send-email-daahern@cisco.com> <20110218070657.GA11404@elte.hu> <4D5E8204.2090501@cisco.com> <20110218175926.GA3445@nowhere> <20110218184119.GC302@ghostprotocols.net>
In-Reply-To: <20110218184119.GC302@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/18/11 11:41, Arnaldo Carvalho de Melo wrote:
> 
> Think about tcpdump + networking tracepoints or 'perf probe' dynamic
> events in the network stack, he wants to merge those logs and correlate
> the tcpdump packet exchange with the tracepoints events in the network
> stack, etc.

I'm zoned in on ap logs, but tcpdump and network analysis is another
very good example. packets are tagged with realtime:

static inline void __net_timestamp(struct sk_buff *skb)
{
    skb->tstamp = ktime_get_real();
}


David
