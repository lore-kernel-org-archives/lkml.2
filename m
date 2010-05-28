Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab0E1F7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 01:59:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37425 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0E1F7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 01:59:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
In-Reply-To: <AANLkTikB-8Qu03VrA5Z0LMXM_alSV7SLqzl-MmiLmFGv@mail.gmail.com>
References: <20100528143605.7E2A.A69D9226@jp.fujitsu.com> <AANLkTikB-8Qu03VrA5Z0LMXM_alSV7SLqzl-MmiLmFGv@mail.gmail.com>
Message-Id: <20100528145329.7E2D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 28 May 2010 14:59:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> RT Task
> 
> void non-RT-function()
> {
>    system call();
>    buffer = malloc();
>    memset(buffer);
> }
> /*
>  * We make sure this function must be executed in some millisecond
>  */
> void RT-function()
> {
>    some calculation(); <- This doesn't have no dynamic characteristic
> }
> int main()
> {
>    non-RT-function();
>    /* This function make sure RT-function cannot preempt by others */
>    set_RT_max_high_priority();
>    RT-function A();
>    set_normal_priority();
>    non-RT-function();
> }
> 
> We don't want realtime in whole function of the task. What we want is
> just RT-function A.
> Of course, current Linux cannot make perfectly sure RT-functionA can
> not preempt by others.
> That's because some interrupt or exception happen. But RT-function A
> doesn't related to any dynamic characteristic. What can justify to
> preempt RT-function A by other processes?

As far as my observation, RT-function always have some syscall. because pure
calculation doesn't need deterministic guarantee. But _if_ you are really
using such priority design. I'm ok maximum NonRT priority instead maximum
RT priority too.

Luis, NonRT high priority break your use case? and if yes, can you please
explain the reason?



