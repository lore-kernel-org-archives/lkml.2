Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab2DWXZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 19:25:40 -0400
Received: from ms01.sssup.it ([193.205.80.99]:48395 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754516Ab2DWXZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 19:25:39 -0400
Message-ID: <4F95E4EF.2080802@sssup.it>
Date: Tue, 24 Apr 2012 00:25:35 +0100
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, cfriesen@nortel.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>   <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>  <1335177104.28150.113.camel@twins> <4F9530F7.9010400@gmail.com>  <4F95C8AF.2040606@sssup.it> <1335217531.28150.179.camel@twins>
In-Reply-To: <1335217531.28150.179.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 23/04/2012 22:45, Peter Zijlstra ha scritto:
> On Mon, 2012-04-23 at 22:25 +0100, Tommaso Cucinotta wrote:
>> I cannot get the real difference between rq->clock and rq->task_clock.
> One runs at wall-time (rq->clock) the other excludes time in irq-context
> and steal-time (rq->clock_task).
>
> The idea is that ->clock_task gives the time as observed by schedulable
> tasks and excludes other muck.

so clock_task might be better to compute the consumed budget at task 
deschedule, but for setting deadlines one period ahead in the future 
guess the regular wall-time rq->clock is the one to be used?

Thx,

     T.

-- 
Tommaso Cucinotta, Computer Engineering PhD, Researcher
ReTiS Lab, Scuola Superiore Sant'Anna, Pisa, Italy
Tel +39 050 882 024, Fax +39 050 882 003
http://retis.sssup.it/people/tommaso

