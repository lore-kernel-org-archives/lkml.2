Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab2EZLHQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 07:07:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64249 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab2EZLHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 07:07:14 -0400
Message-ID: <4FC0B95C.5060207@gmail.com>
Date: Sat, 26 May 2012 13:07:08 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com
Subject: Re: [PATCH 13/15] sched: add bandwidth management for sched_dl.
References: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>  <1337809375-24295-14-git-send-email-juri.lelli@gmail.com> <1337942292.9783.178.camel@laptop>
In-Reply-To: <1337942292.9783.178.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/25/2012 12:38 PM, Peter Zijlstra wrote:
> On Wed, 2012-05-23 at 23:42 +0200, Juri Lelli wrote:
>> +/*
>> + * Coupling of -dl and -rt bandwidth.
>> + *
>> + * Here we check, while setting the system wide bandwidth available
>> + * for -dl tasks and groups, if the new values are consistent with
>> + * the system settings for the bandwidth available to -rt entities.
>> + *
>> + * IOW, we want to enforce that
>> + *
>> + *   rt_bandwidth + dl_bandwidth<= 100%
>> + *
>> + * is always true.
>> + */
>
> I was thinking we could do it the other way around, have have
> dl_bandwidth included in rt_bandwidth.
>

If I understand correctly, you are proposing to treat -dl tasks as a
special case of "real-time" tasks. Then we could reserve some bw to
"real-time" (rt_bandwidth cap) activities and give a piece of this
bw to -dl tasks (what remains is for -rt tasks). This is in principle
nice and useful, but I'm not quite sure that this is the right point
to achieve this logical behavior.
I mean, -dl and -rt tasks are separately treated, so it is probably
cleaner to manage their knobs separately. They have to coexist rather
than be considered one a sub-case of the other. A better way to go
for a common cap for them is probably the (long-term) hierarchical
scheduling mechanism.

So, I would prefer to keep the interface as is for now, but I can also
completely misunderstood your thoughts :-P.

Thanks and Regards,

- Juri
