Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab0DSI3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 04:29:53 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:33746 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab0DSI3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 04:29:51 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4BCC147B.10708@tremplin-utc.net>
Date: Mon, 19 Apr 2010 10:29:47 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100331 Mandriva/3.0.4-1mdv2010.1 (2010.1) Thunderbird/3.0.4
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with ondemand
 during disk IO
References: <20100418115949.7b743898@infradead.org> <20100418120346.1b478410@infradead.org>
In-Reply-To: <20100418120346.1b478410@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/04/10 21:03, Arjan van de Ven wrote:
> From 27966bedabea83c4f3ae77507eceb746b1f6ebae Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sun, 18 Apr 2010 11:15:56 -0700
> Subject: [PATCH 7/7] ondemand: Solve the big performance issue with
> ondemand during disk IO
> 
> The ondemand cpufreq governor uses CPU busy time (e.g. not-idle time) as
> a measure for scaling the CPU frequency up or down.
> If the CPU is busy, the CPU frequency scales up, if it's idle, the CPU
> frequency scales down. Effectively, it uses the CPU busy time as proxy
> variable for the more nebulous "how critical is performance right now"
> question.
> 
> This algorithm falls flat on its face in the light of workloads where
> you're alternatingly disk and CPU bound, such as the ever popular
> "git grep", but also things like startup of programs and maildir using
> email clients... much to the chagarin of Andrew Morton.
> 
> This patch changes the ondemand algorithm to count iowait time as busy,
> not idle, time. As shown in the breakdown cases above, iowait is performance
> critical often, and by counting iowait, the proxy variable becomes a more
> accurate representation of the "how critical is performance" question.
> 
> The problem and fix are both verified with the "perf timechar" tool.
Hi,
I don't doubt that keeping the cpu full frequency during IO can improve
some specific workloads, however in your log message you don't explain
how much we are loosing.

How much more energy is consumed when doing a "updatedb" or "find /" ?

I'm not saying your patch is wrong, but I'm saying that if you tweak the
ondemand governor just by looking at performance and not at energy
consumption, as it seems in your log message, it will soon look very
similar to the performance governor! So it would be good to check the
whole spectrum of what needs to be optimised :-)

Cheers,
Eric
