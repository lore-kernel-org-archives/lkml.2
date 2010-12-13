Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab0LMSVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:21:00 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:49112 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757654Ab0LMSU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 13:20:59 -0500
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAGTyBU2rR7Ht/2dsb2JhbACDXKAreKd4ikmQXYEhgzV0BIRkhhWDFA
X-IronPort-AV: E=Sophos;i="4.59,336,1288569600"; 
   d="scan'208";a="390593701"
Message-ID: <4D066407.3040707@cisco.com>
Date: Mon, 13 Dec 2010 11:20:55 -0700
From: "David S. Ahern" <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf tools: Add reference timestamp to perf header
References: <1291773285-16254-1-git-send-email-daahern@cisco.com>	 <1291773285-16254-2-git-send-email-daahern@cisco.com>	 <20101212201613.GA1784@nowhere> <4D06301C.2090309@cisco.com>	 <20101213155451.GA1691@nowhere> <20101213164854.GL5407@ghostprotocols.net>	 <20101213170923.GB1691@nowhere> <1292260289.6803.297.camel@twins>	 <20101213171537.GC1691@nowhere> <1292260699.6803.305.camel@twins>	 <20101213172216.GB7417@ghostprotocols.net>	 <1292261716.6803.332.camel@twins> <1292262433.6803.351.camel@twins>	 <4D065CB2.7050104@cisco.com> <1292263024.6803.370.camel@twins>	 <4D065F69.7080707@cisco.com> <1292263573.6803.381.camel@twins>
In-Reply-To: <1292263573.6803.381.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/13/10 11:06, Peter Zijlstra wrote:
> On Mon, 2010-12-13 at 11:01 -0700, David S. Ahern wrote:
>>> Another problem with this approach is things like flight-recorder mode
>>> where you constantly over-write your old data, you'd have to build some
>>> trigger to always output a new record before you over-write the old one,
>>> so there's always one consistent record around. Drift is an even more
>>> serious problem here since flight-record more could be running for days
>>> before (if ever) you dump it.
>>
>> Ok. I was not aware flight-recorder mode was an option today.
> 
> You get it when you mmap the fd RO -- the only thing is you don't get a
> consistent tail pointer so you have to fudge a bit.

Awesome. Flight recorder mode is on our wish list. I'll try it out when
I get some time.

David

> 
> But even if we didn't have it, we'd need a solution that would work once
> we did grow it ;-)
