Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab2DKGy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 02:54:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38959 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab2DKGy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 02:54:26 -0400
Message-ID: <4F852A9C.7040906@gmail.com>
Date: Wed, 11 Apr 2012 08:54:20 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>  <1333696481-3433-6-git-send-email-juri.lelli@gmail.com> <1334113588.23924.234.camel@gandalf.stny.rr.com>
In-Reply-To: <1334113588.23924.234.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 05:06 AM, Steven Rostedt wrote:
> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>
>> +/*
>> + * Pure Earliest Deadline First (EDF) scheduling does not deal with the
>> + * possibility of a entity lasting more than what it declared, and thus
>> + * exhausting its runtime.
>> + *
>> + * Here we are interested in making runtime overrun possible, but we do
>> + * not want a entity which is misbehaving to affect the scheduling of all
>> + * other entities.
>> + * Therefore, a budgeting strategy called Constant Bandwidth Server (CBS)
>> + * is used, in order to confine each entity within its own bandwidth.
>> + *
>> + * This function deals exactly with that, and ensures that when the runtime
>> + * of a entity is replenished, its deadline is also postponed. That ensures
>> + * the overrunning entity can't interfere with other entity in the system and
>> + * can't make them miss their deadlines. Reasons why this kind of overruns
>> + * could happen are, typically, a entity voluntarily trying to overcume its
>
> s/overcume/overcome/
>
> -- Steve
>
>> + * runtime, or it just underestimated it during sched_setscheduler_ex().
>> + */
>> +static void replenish_dl_entity(struct sched_dl_entity *dl_se)
>> +{
>> +
>

Thanks!

- Juri
