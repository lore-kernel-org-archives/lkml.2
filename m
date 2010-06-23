Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab0FWWCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 18:02:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39321 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab0FWWCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 18:02:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=XZrO6Bb4MSeIVjy1/zzXTzk6YUrohJYq8ZKoPIooxHvxz4sG14XgxpRWG7XsLof2qo
         WfaRdz6W9f0hEJevkVr2F4erZcRhwwXeyMCds30HalOONDKVRMowBZ25VVv5H65bpVFt
         kcRsF5RN8GpzWB/VEbkXBMfVup4i/GaiYHnfU=
Message-ID: <4C22847F.80109@gmail.com>
Date: Thu, 24 Jun 2010 00:02:39 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1rc2-2.2 Thunderbird/3.1
MIME-Version: 1.0
To: Hari LKML <hari.lkml@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Help in understanding the tasklets
References: <AANLkTil7YgW3eQZ-WQ3R8k2OowZt491boAuxjPe18oFy@mail.gmail.com>
In-Reply-To: <AANLkTil7YgW3eQZ-WQ3R8k2OowZt491boAuxjPe18oFy@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2010 08:36 PM, Hari LKML wrote:
> After reading some of the books and the codes here is my understanding
> about the tasklet_action function
> 
> the function statrs some thing like this
> 
> 1. If the tasklet is not running in another processor set the Bit
> TASKLET_STATE_RUN;     <<if (tasklet_trylock(t))>>
> 2. clear the TASKLET_STATE_SCHED bit;       <<if (!test_and_clear_bit(TASKLET_
> STATE_SCHED, &t->state))>>
> 3. start the tasklet     <<(    t->func(t->data))>>
> 
> 
> Now when the tasklets function is running and the same interrupt is
> raised again but now handled by a different processor (in a SMP
> system) the tasklet is now scheduled in a different processor (because
> the TASKLET_STATE_SCHED is already cleared in step 2)
> and there are every chance of the same type of  taklet running
> concurently in different processors thus braking the promise that same
> types of tasklets do not ever run simultaniously.
> 
> I think i have misunderstood one or the other concept so please
> correct me and help me in understanding the Linux Kernel code more
> clearly.

But tasklet_trylock will return 0 when t->func is running on another
processor already because of step 1. Thus the tasklet gets to the end of
the tasklet list and is tried again later.

-- 
js
