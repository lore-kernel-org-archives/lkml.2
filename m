Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1IFJZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 05:25:50 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:35827 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab1IFJZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 05:25:42 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1109012112100.2723@ionos>
References: <1314360393-13605-1-git-send-email-jkacur@redhat.com>
	<alpine.LFD.2.02.1109012112100.2723@ionos>
Date: Tue, 6 Sep 2011 11:25:41 +0200
X-Google-Sender-Auth: ZatKpfeQr0Tjd1vcWeGdS5_A6tE
Message-ID: <CAONaPpFpJJaKN=XKavQf0ZSG2Vht7pu3NH0a5YDZrxCmx7fMew@mail.gmail.com>
Subject: Re: [PATCH] PREEMPT_RT_FULL Build error fix
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 1, 2011 at 9:14 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 26 Aug 2011, John Kacur wrote:
>
>> Problem:
>> make O=/bld/3.0.3-rt11/ kernel/fork.o
>> /home/jkacur/jk-2.6/kernel/fork.c:91: error: section of ‘name’ conflicts with previous declaration
>>
>> __cacheline_aligned is already part of the definition of DEFINE_RWLOCK
>> for -rt
>>
>> However it is not always used for the tasklist_lock in non-rt, so it can't
>> simply be added to the definition of DEFINE_RWLOCK in non-rt, so I modified
>> the definition in fork.c
>
> -ENOPARSE
>
> The real question is whether RWLOCKS should be cacheline aligned in
> general or the RT addon is just overkill. Slapping an ifdef around
> does not answer that.
>

Right, this was just a "put out a build-break fire" for now patch and
not a good long term patch. I noticed that of all the mainline
DEFINE_RWLOCKs that only the tasklist_lock is cache aligned. I'm
wondering if there is a reason for that, or just more of a historical
accident.

Regarding cache aligning the rwlocks in -rt, I also can't find the
historical reason for it, do you remember if it was for latency
performance, or did we have a atomicity issue on some architectures
when we didn't cache align it?

Thanks
