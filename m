Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab2E3Pek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:34:40 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42342 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab2E3Pei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:34:38 -0400
Message-ID: <4FC63E09.6030501@gmail.com>
Date: Wed, 30 May 2012 17:34:33 +0200
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
References: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>    <1337809375-24295-14-git-send-email-juri.lelli@gmail.com>   <1337942292.9783.178.camel@laptop> <4FC0B95C.5060207@gmail.com>  <1338285486.26856.16.camel@twins> <4FC4BE9F.9060102@gmail.com> <1338294716.26856.55.camel@twins>
In-Reply-To: <1338294716.26856.55.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 02:31 PM, Peter Zijlstra wrote:
> On Tue, 2012-05-29 at 14:18 +0200, Juri Lelli wrote:
>>> The thing is, keeping it separate makes for an impossible configuration
>>> scenario. Esp. once we enable !root usage. The proposed 5% is very
>>> limiting and regular users won't have sufficient privilege to change it.
>>>
>>
>> Ok, now I understand your point better, and I agree that 5% is hardly
>> usable for !root users. However, I also think this is probably more a
>> system admin problem. I mean, a sys admin that wants his users to play
>> with -deadline scheduling should have thought how to properly set up his
>> system, and the fact that something must be configured by hand to give
>> users a usable system is generally not a so bad idea.
>
> Yes, but lets not make the life of the unsuspecting admin harder than we
> absolutely have to.
>
> Furthermore we should strive to make DL as useful as possible
> out-of-the-box.
>

Ok, I agree on this.

> One way to do this is to have rt and dl bandwidth constraints
> independent and put a 3rd combined limit in place. But what is the
> benefit of that over a single combined limit?

In the end, a single limit is probably better. So, I'll leave rt_bandwidth
at its default value and make dl_bandwidth a sort of sub-quota of it.
To give the user an out-of-the-box usable system, I could raise dl_bandwith
to, let's say, 40% (of 95%). Thus, in the default scenario, the user will
be allowed to create _rt tasks up to 57% and _dl tasks up to 38% of the
system capacity, sounds reasonable?

Thanks and regards,

- Juri
