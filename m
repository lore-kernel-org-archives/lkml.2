Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab1GTSIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 14:08:10 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:40553 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab1GTSIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 14:08:09 -0400
Message-ID: <4E271A66.40307@colorfullife.com>
Date: Wed, 20 Jul 2011 20:11:50 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Harald Laabs <kernelml@dasr.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] null-pointer in task_rq_lock (2.6.35 to 3.0-rc7)
References: <4E25E2F5.7090807@dasr.de> <1311110082.3113.27.camel@edumazet-laptop>
In-Reply-To: <1311110082.3113.27.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2011 11:14 PM, Eric Dumazet wrote:
> Le mardi 19 juillet 2011 à 22:03 +0200, Harald Laabs a écrit :Hi,
>>
>> I'm not able to fix or understand this bug myself, its already in
>> bugzilla with the call trace:
>> https://bugzilla.kernel.org/show_bug.cgi?id=27142
>>
>> Is there any more useful information I can provide? Anything to test?
Could you build a kernel with CONFIG_DEBUG_LIST enabled?
Does it report anything?
>> Does anyone know of changes from 2.6.34 to 2.6.35 that might have
>> broken this? (The diff and the changelog do not enlighten me, too
>> much changed and I understand little of it.)
> I feel commit 0a2b9d4c79671b059568 might be the bug origin
> (ipc/sem.c: move wake_up_process out of the spinlock section)
>
I'll try to reproduce the bug tomorrow.
Perhaps a race with multiple processes sleeping, some/all woken up by a 
signal an a concurrent IPC_RM.

But I don't see the bug yet.

--
     Manfred

