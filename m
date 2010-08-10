Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015Ab0HJWSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:18:50 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:65016 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932759Ab0HJWSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:18:48 -0400
X-IronPort-AV: E=Sophos;i="4.55,350,1278280800"; 
   d="scan'208";a="56946005"
Message-ID: <4C61D044.2060703@inria.fr>
Date: Wed, 11 Aug 2010 00:18:44 +0200
From: Tomasz Buchert <Tomasz.Buchert@inria.fr>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup_freezer: Freezing and task move race fix
References: <1281470001-14320-1-git-send-email-tomasz.buchert@inria.fr> <20100810215741.GC2927@count0.beaverton.ibm.com>
In-Reply-To: <20100810215741.GC2927@count0.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Helsley a écrit :
> On Tue, Aug 10, 2010 at 09:53:21PM +0200, Tomasz Buchert wrote:
>> Writing 'FROZEN' to freezer.state file does not
>> forbid the task to be moved away from its cgroup
>> (for a very short time). Nevertheless the moved task
>> can become frozen OUTSIDE its cgroup which puts
>> discussed task in a permanent 'D' state.
>>
>> This patch forbids migration of either FROZEN
>> or FREEZING tasks.
>>
>> This behavior was observed and easily reproduced on
>> a single core laptop. Program and instructions how
>> to reproduce the bug can be fetched from:
>> http://pentium.hopto.org/~thinred/repos/linux-misc/freezer_bug.c
> 
> Thanks for the report and the test code.
> 
> I'm will try to reproduce this race in the next few hours and analyze
> it since I'm not sure the patch really fixes the race -- it may only
> make the race trigger less frequently.
> 
> At the very least the patch won't break the current code since it's
> essentially a more-strict version of is_task_frozen_enough() -- it lets
> fewer tasks attach/detach to/from frozen cgroups.
> 
> Cheers,
> 	-Matt Helsley

Hi Matt!
I am a novice if it comes to the kernel and I find the cgroup_freezer
code especially complicated, so definetely this may be not enough to fix that.
Notice also that if you uncomment the line 55 in my testcase this will also
trigger the race! This, however, makes sense since process may not be in the cgroup anymore
and consequently won't be thawed.
I think that this patch fixes these problems because it does the flag checking in a right order:
first freezing() is used and then frozen() which assures (see frozen_process()) that
the race will not happen. Right? :)

Tomasz

