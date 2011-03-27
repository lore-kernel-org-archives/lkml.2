Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1C0Ltw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 07:49:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab1C0Ltv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 07:49:51 -0400
Message-ID: <4D8F2455.2080205@redhat.com>
Date: Sun, 27 Mar 2011 13:49:41 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39
References: <4D8B4A89.80608@fusionio.com>
In-Reply-To: <4D8B4A89.80608@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 03:43 PM, Jens Axboe wrote:
> Hi Linus,
>
> This is the main pull request for the block IO layer and friends for
> 2.6.39.
>
> There are two major things in this tree:
>
> - The removal of the per-device plugging state for disks. On fast
>    devices, it ended up hammering the queue lock quite hard. The new
>    scheme puts the plugging state on the stack and allows an IO submitter
>    to finish his batch of IO before pushing it to the queue. Once that
>    push starts, we'll insert/merge with the existing queue.
>
>    A pointer to this plugging context is stored in the task structure. If
>    a task ends up blocking before it has submitted it's IO (usual cause
>    would be memory allocation of some sort), the plugged list is
>    auto-submitted before the task goes to sleep.

This is the fourth "do something if preempted" hook (the other three are 
kvm, cmwq, and perf).  Why not use sched notifiers for this?

-- 
error compiling committee.c: too many arguments to function

