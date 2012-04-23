Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab2DWKhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:37:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37085 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab2DWKhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:37:48 -0400
Message-ID: <4F9530F7.9010400@gmail.com>
Date: Mon, 23 Apr 2012 12:37:43 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>  <1333696481-3433-6-git-send-email-juri.lelli@gmail.com> <1335177104.28150.113.camel@twins>
In-Reply-To: <1335177104.28150.113.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 12:31 PM, Peter Zijlstra wrote:
> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>> +       dl_se->deadline = rq->clock + dl_se->dl_deadline;
>
> You might want to use rq->clock_task, this clock excludes times spend in
> hardirq context and steal-time (when paravirt).
>
> Then again, it might not want to use that.. but its something you might
> want to consider and make explicit by means of a comment.

Yes, I planned a consistency check for the use of clock/clock_task
throughout the code, but it seems I then forgot it.
Planned for the next iteration :-).

Thanks,

- Juri
