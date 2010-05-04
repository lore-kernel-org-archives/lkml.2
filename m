Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107Ab0EDSE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:04:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39105 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760087Ab0EDSEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:04:54 -0400
To: Arve =?iso-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
References: <1272667021-21312-1-git-send-email-arve@android.com>
	<87wrvl5479.fsf@deeprootsystems.com>
	<20100503180741.GB2098@rakim.wolfsonmicro.main>
	<201005032318.35383.rjw@sisk.pl> <87sk68r1zh.fsf@deeprootsystems.com>
	<s2qd6200be21005031709r28420f0ezf3cf286517ee9114@mail.gmail.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Tue, 04 May 2010 11:04:49 -0700
In-Reply-To: <s2qd6200be21005031709r28420f0ezf3cf286517ee9114@mail.gmail.com> ("Arve
 =?iso-8859-1?Q?Hj=F8nnev=E5g=22's?= message of "Mon\, 3 May 2010 17\:09\:22
 -0700")
Message-ID: <87wrvjh7b2.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arve Hjønnevåg <arve@android.com> writes:

> On Mon, May 3, 2010 at 4:37 PM, Kevin Hilman
> <khilman@deeprootsystems.com> wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>>

[...]

>>> However, the real question is whether or not the opportunistic suspend feature
>>> is worth adding to the kernel as such and I think it is.
>>>
>>> To me, it doesn't duplicate the runtime PM framework which is aimed at the power
>>> management of individual devices rather than the system as a whole.
>>
>> From the use cases presented, the *usage* of suspend blockers is aimed
>> at power management of individual devices or subsystems, just like
>> usage of runtime PM.
>>
> No, suspend blockers are mostly used to ensure wakeup events are not
> ignored, and to ensure tasks triggered by these wakeup events
> complete.

OK, but my point was that their *usage* is at the level of inidividual
devices and subsystems, just like runtime PM.  Hence, duplicate work.

>> So I still see a large duplication in the usage and the goals of both
>> frameworks.  The goal of both is to always enter lowest-power state
>> except
>>
>>  - if there's activity (runtime PM for devices, CPUidle for CPU)
>>  - if there's a suspend blocker (opportunitic suspend)
>>
>> In addition, it will likely cause duplicate work to be done in
>> drivers.  Presumably, PM aware drivers will want to know if the system
>> is in opportunistic mode.  For example, for many drivers, doing
>> runtime PM may not be worth the effort if the system is in
>> opportunistic mode.
>
> Why? If a device is not in use it should be off regardless of what
> state the rest of the system is in.

Not necessarily.

If a device is not in use, what power state it goes into depends on
many device/subsystem specific things.  For example, recent activity
(timeouts), whether it will be busy soon (pending transfers),
latency/throughput constraints, dependency on other devices, or any
other device/subsystem specific reason.

All of these can be handled with runtime PM.  None of which are taken
into consideration with opportunistic suspend.

Kevin

