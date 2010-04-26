Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0DZVbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:31:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755335Ab0DZVbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:31:00 -0400
Message-ID: <4BD605F7.2020303@redhat.com>
Date: Mon, 26 Apr 2010 17:30:31 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with ondemand
 during disk IO
References: <20100418115949.7b743898@infradead.org> <20100418120346.1b478410@infradead.org>
In-Reply-To: <20100418120346.1b478410@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2010 03:03 PM, Arjan van de Ven wrote:
>  From 27966bedabea83c4f3ae77507eceb746b1f6ebae Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven<arjan@linux.intel.com>
> Date: Sun, 18 Apr 2010 11:15:56 -0700
> Subject: [PATCH 7/7] ondemand: Solve the big performance issue with ondemand during disk IO
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
>
> Signed-off-by: Arjan van de Ven<arjan@linux.intel.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
