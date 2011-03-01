Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab1CAQLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:11:08 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:13572 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab1CAQLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:11:06 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAGKpbE2rR7Hu/2dsb2JhbACmTHSgRJwxhWEEhRKHDYNA
X-IronPort-AV: E=Sophos;i="4.62,247,1297036800"; 
   d="scan'208";a="337057794"
Message-ID: <4D6D1AA8.4060809@cisco.com>
Date: Tue, 01 Mar 2011 09:11:20 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 4/6] perf script: dump software events too
References: <1298865151-23656-1-git-send-email-daahern@cisco.com>	<1298865151-23656-5-git-send-email-daahern@cisco.com>	<AANLkTikwsuBGVfB6uu7=H0jbL+2YbbvX=ea6rLwNP8w-@mail.gmail.com>	<4D6D004F.5010602@cisco.com> <AANLkTi=jmS80Rs13QiTmdA5iUXvNaSKxQ9Gpp2P2nqRU@mail.gmail.com>
In-Reply-To: <AANLkTi=jmS80Rs13QiTmdA5iUXvNaSKxQ9Gpp2P2nqRU@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/01/2011 08:11 AM, Frederic Weisbecker wrote:
> 
> Why shouldn't it be designed to dump software events? It's called print_event().
> Its current version is rather something I would call "limited". But it
> was not designed
> to be limited.

That's because its origins are trace specific. Per last week's thread,
perf-script was perf-trace until Nov 2010. perf-script deals with
tracepoints.

> 
> Ideally, we should have print_tracepoint_event() in
> trace-event-parse.c, print_software_event()
> where you want, and have print_event() in builtin-script.c that wraps on those.


process_event does not take the event sample, it takes elements of it:

struct scripting_ops {
...
    void (*process_event) (int cpu, void *data, int size,
                   unsigned long long nsecs, char *comm);
...
};


David
