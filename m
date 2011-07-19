Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab1GSVOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 17:14:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46996 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab1GSVOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 17:14:47 -0400
Subject: Re: [BUG] null-pointer in task_rq_lock (2.6.35 to 3.0-rc7)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Harald Laabs <kernelml@dasr.de>
Cc: linux-kernel@vger.kernel.org, Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4E25E2F5.7090807@dasr.de>
References: <4E25E2F5.7090807@dasr.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 23:14:42 +0200
Message-ID: <1311110082.3113.27.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 19 juillet 2011 à 22:03 +0200, Harald Laabs a écrit :
> Hi,
> reloading an apache httpd can crash the kernel since 2.6.35.
> It seems that tasks are removed between creating the task-list and
> calling wake_up_sem_queue_do in freeary. The pointers to the
> task_struct elements end up in try_to_wake_up and sometimes contain
> 0x0 there.
> The problem did not exist in 2.6.34. It does not show up on single
> processor systems. Depending on the apache httpd settings it only
> takes a few tries to kill the system on our 8-core servers. Dualcore
> did not want to crash, maybe it really needs more than one real CPU.
> Various gcc versions (4.1 to 4.6) were used.
> 
> If anyone wants to crash a system using an prefork apache httpd:
> <IfModule mpm_prefork_module>
>         ServerLimit             512
>         StartServers             50
>         MinSpareServers          50
>         MaxSpareServers         100
>         MaxClients              200
>         MaxRequestsPerChild     500
> </IfModule>
> (Details do not seem to matter but some settings did not die fast.)
> 
> I'm not able to fix or understand this bug myself, its already in
> bugzilla with the call trace:
> https://bugzilla.kernel.org/show_bug.cgi?id=27142
> 
> Is there any more useful information I can provide? Anything to test?
> Does anyone know of changes from 2.6.34 to 2.6.35 that might have
> broken this? (The diff and the changelog do not enlighten me, too
> much changed and I understand little of it.)

I feel commit 0a2b9d4c79671b059568 might be the bug origin
(ipc/sem.c: move wake_up_process out of the spinlock section)

CC Manfred & Andrew



