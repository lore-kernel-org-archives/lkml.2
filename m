Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab0ESTba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:31:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46565 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab0ESTb3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:31:29 -0400
MIME-Version: 1.0
In-Reply-To: <201005192113.52535.trenn@suse.de>
References: <1274264877.5605.10541.camel@twins>
	 <1274295539-7798-3-git-send-email-trenn@suse.de>
	 <1274295743.1674.1545.camel@laptop> <201005192113.52535.trenn@suse.de>
Date: Wed, 19 May 2010 12:31:27 -0700
Message-ID: <AANLkTilgcX0fHfGSyNRBsc257SsnZ4T3LNWvXb0VNseo@mail.gmail.com>
Subject: Re: [PATCH 2/2] scheduler: cgroups cpuaccouting: Make cpuusage atomic
From: Mike Chan <mike@android.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, menage@google.com,
       containers@lists.linux-foundation.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 12:13 PM, Thomas Renninger <trenn@suse.de> wrote:
> On Wednesday 19 May 2010 09:02:23 pm Peter Zijlstra wrote:
>> On Wed, 2010-05-19 at 20:58 +0200, Thomas Renninger wrote:
>> > and avoid locking on 32 bit.
>> > This resolves an ugly dependency in cgroups_cpuaccount.c
>> > to per_cpu runqueues lock variable.
>>
>> While I totally agree with the sentiments here, atomic64_t isn't
>> available on all 32bit archs and is _terribly_ expensive on ARCH=i386.
> Speed on i386 shouldn't count that much here.
> Big machines run x86_64 and cgroup cpu accounting doesn't make much
> sense on old i386 single core machines.
>

cpuacct can still be useful for single core machines, at least in
Android it tracks the cpu usage if your apps. On ARM I'm not sure
(maybe someone more knowledgeable can chime in) how much overhead this
will incur relative to scheduler / cpuacct overhead that's already
there.

Since this is a per-cpu value already, is it not sufficient to just
disable interrupts on that cpu while doing a normal u64 add for both
MP and UP systems?

-- Mike

> Would still be great to see the first patch go in then.
> The idea of splitting was to:
>  a) show the real change
>  b) make at least the first go in if the snd does not work out
>
> Thanks,
>
>     Thomas
>
