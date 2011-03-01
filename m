Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab1CAQJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:09:34 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:8544 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab1CAQJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:09:33 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAOqobE2rR7Ht/2dsb2JhbACEKKIkdKBEiwWRLIEng0R2BIUShw2DQA
X-IronPort-AV: E=Sophos;i="4.62,247,1297036800"; 
   d="scan'208";a="267252994"
Message-ID: <4D6D1A4C.1090009@cisco.com>
Date: Tue, 01 Mar 2011 09:09:48 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 3/6] perf record: add time-of-day option
References: <1298865151-23656-1-git-send-email-daahern@cisco.com>	 <1298865151-23656-4-git-send-email-daahern@cisco.com>	 <1298989751.5226.863.camel@laptop>  <4D6D0438.2090901@cisco.com>	 <1298993714.5226.871.camel@laptop>  <4D6D13C6.5020807@cisco.com> <1298995250.5226.882.camel@laptop>
In-Reply-To: <1298995250.5226.882.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/01/2011 09:00 AM, Peter Zijlstra wrote:
> On Tue, 2011-03-01 at 08:41 -0700, David Ahern wrote:
> 
>> realtime-clock counter is created with a period N. How do you correlate
>> perf_clock to time-of-day until now + N? 
> 
> You scan fwd? Since its at most N time ahead you're scanning fwd its
> still constant time.

So I potentially scan a multi-gigabyte file looking for a single event
-- that may not even exist. From a usability perspective the time string
should appear if the clock event exists and not if it does not exist.
This should happen automatically.

> 
> Thing is, I'm really not convinced this is a very useful ioctl() in
> generic, and ioctl()s really need a good justification to add.
> 

I did not code it create samples of a realtime-clock event; I coded it
to add an event to the stream on demand -- whatever event the fd is tied to.

David
