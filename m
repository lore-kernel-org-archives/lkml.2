Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab2LUV7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 16:59:08 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18752 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2LUV7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 16:59:07 -0500
Message-ID: <50D4DB5D.9020309@oracle.com>
Date: Fri, 21 Dec 2012 16:57:49 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: Andrew Morton <akpm@linux-foundation.org>, serge.hallyn@canonical.com,
        ebiederm@xmission.com, linux-kernel@vger.kernel.org,
        xemul@parallels.com, catalin.marinas@arm.com, will.deacon@arm.com,
        jmorris@namei.org, cmetcalf@tilera.com, joe.korty@ccur.com,
        dhowells@redhat.com, dledford@redhat.com, viro@zeniv.linux.org.uk,
        kosaki.motohiro@jp.fujitsu.com, linux-api@vger.kernel.org,
        serue@us.ibm.com, tglx@linutronix.de, paulmck@linux.vnet.ibm.com,
        devel@openvz.org, mtk.manpages@gmail.com,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [RFC PATCH v8 0/5] IPC: checkpoint/restore in userspace enhancements
References: <20121024151555.5642.79086.stgit@localhost.localdomain> <20121218123601.113a29c0.akpm@linux-foundation.org> <50D28EC8.7000708@parallels.com> <20121220124751.d7ccbd8e.akpm@linux-foundation.org> <50D4CA90.60205@parallels.com>
In-Reply-To: <50D4CA90.60205@parallels.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 03:46 PM, Stanislav Kinsbursky wrote:
> 21.12.2012 00:47, Andrew Morton пишет:
>> On Thu, 20 Dec 2012 08:06:32 +0400
>> Stanislav Kinsbursky<skinsbursky@parallels.com>  wrote:
>>
>>> 19.12.2012 00:36, Andrew Morton __________:
>>>> On Wed, 24 Oct 2012 19:34:51 +0400
>>>> Stanislav Kinsbursky<skinsbursky@parallels.com>  wrote:
>>>>
>>>>> This respin of the patch set was significantly reworked. Most part of new API
>>>>> was replaced by sysctls (by one per messages, semaphores and shared memory),
>>>>> allowing to preset desired id for next new IPC object.
>>>>>
>>>>> This patch set is aimed to provide additional functionality for all IPC
>>>>> objects, which is required for migration of these objects by user-space
>>>>> checkpoint/restore utils (CRIU).
>>>>>
>>>>> The main problem here was impossibility to set up object id. This patch set
>>>>> solves the problem by adding new sysctls for preset of desired id for new IPC
>>>>> object.
>>>>>
>>>>> Another problem was to peek messages from queues without deleting them.
>>>>> This was achived by introducing of new MSG_COPY flag for sys_msgrcv(). If
>>>>> MSG_COPY flag is set, then msgtyp is interpreted as message number.
>>>> According to my extensive records, Sasha hit a bug in
>>>> ipc-message-queue-copy-feature-introduced.patch and Fengguang found a
>>>> bug in
>>>> ipc-message-queue-copy-feature-introduced-cleanup-do_msgrcv-aroung-msg_copy-feature.patch
>>>>
>>>> It's not obvious (to me) that these things have been identified and
>>>> fixed.  What's the status, please?
>>> Hello, Andrew.
>>> Fengguang's issue was solved by "ipc: simplify message copying" I sent you.
>>> But I can't find Sasha's issue. As I remember, there was some problem in
>>> early
>>> version of the patch set. But I believe its fixed now.
>> http://lkml.indiana.edu/hypermail/linux/kernel/1210.3/01710.html
>>
>> Subject: "ipc, msgqueue: NULL ptr deref in msgrcv"
> 
> Ah, yes. Thanks.
> Hi found it in initial version of code, which was significantly changed (or cleaned and simplified) by further patch series.
> And I cant find out, how this can happen, because this patch he bisect to do not modify the queue itself, while he found the
> problem in testmsg.

I actually can't reproduce it on the latest -next.

I was reverting the IPC changes in the past couple of weeks so that I could test the
rest of the IPC code with the fuzzer, and when I added them back in again I can't
reproduce the issue I've reported earlier.

We can probably figure out where it got fixed by bisecting between -next trees if anyone
is interested in that.


Thanks,
Sasha

