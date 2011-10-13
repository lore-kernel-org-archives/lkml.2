Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1JMSoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 14:44:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58262 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1JMSoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 14:44:02 -0400
Message-ID: <4E97332C.8020202@colorfullife.com>
Date: Thu, 13 Oct 2011 20:51:24 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/3] ipc/sem.c: handle spurious wakeups
References: <1316885831-11996-1-git-send-email-manfred@colorfullife.com> <20111011145441.228e4c94.akpm@linux-foundation.org>
In-Reply-To: <20111011145441.228e4c94.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2011 11:54 PM, Andrew Morton wrote:
> On Sat, 24 Sep 2011 19:37:11 +0200
> Manfred Spraul<manfred@colorfullife.com>  wrote:
>
>> semtimedop() does not handle spurious wakeups, it returns -EINTR to user space.
>> Most other schedule() users would just loop and not return to user space.
>> The patch adds such a loop to semtimedop()
> What is a "spurious wakeup" and how can a process receive one?
A spurious wakeup means that someone calls wake_up_process() without a 
proper reason.
The most common case would be a wake_up_process() that was somehow delayed.

Peter's patch made such delayed wakeups very common, this is how we 
found the issue.

The "standard" kernel primitives handle such wakeups, ipc/sem.c doesn't 
handle that.

> I'm wondering about the userspace-visible effects of this change, and
> any compatibility issues?
This change has no userspace visible effects.

--
     Manfred
