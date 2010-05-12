Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab0ELSRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 14:17:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52337 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab0ELSRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 14:17:20 -0400
Message-ID: <4BEAF0FC.1000803@colorfullife.com>
Date: Wed, 12 May 2010 20:18:36 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>,
       Zach Brown <zach.brown@oracle.com>, Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 2/2] ipc/sem.c: move wake_up_process out of the spinlock
 section
References: <1272481588-1941-1-git-send-email-manfred@colorfullife.com> <1272481588-1941-2-git-send-email-manfred@colorfullife.com> <1272481588-1941-3-git-send-email-manfred@colorfullife.com> <20100511142149.83bb3538.akpm@linux-foundation.org> <4BEAE6A7.8070809@colorfullife.com>
In-Reply-To: <4BEAE6A7.8070809@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2010 07:34 PM, Manfred Spraul wrote:
>
> The effect would be that e.g. a semctl(SETALL) operation might change 
> sem_otime.
> semctl(SETALL) must only change sem_ctime (and sem_otime only if it 
> causes a wakeup
> and the woken up thread modifies the array)
>
Just for your information: I'm not sure why semctl(SETALL) changes 
sem_ctime at all.
According to the opengroup, it shouldn't do that.

On FreeBSD, it doesn't.

Any proposals how to fix it?
Should I remove the update to sem_ctime?


 > [manfred@cores linux-2.6]$ touch ipc/sem.o
It should have been "touch ipc/sem.c":

 > [manfred@cores linux-2.6]$ touch ipc/sem.c
 > [manfred@cores linux-2.6]$ make ipc
 >   CHK     include/linux/version.h
 >   CHK     include/generated/utsrelease.h
 >  CALL    scripts/checksyscalls.sh
 >  CC      ipc/sem.o
 >  LD      ipc/built-in.o

--
     Manfred
