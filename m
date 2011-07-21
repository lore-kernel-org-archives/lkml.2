Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1GUIMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 04:12:24 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:53046 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab1GUIMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 04:12:19 -0400
Subject: Re: [PATCH] [ipc/sem.c] fix race with concurrent semtimedop()
 timeouts and IPC_RMID
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>,
        LKML <linux-kernel@vger.kernel.org>, Yuriy Yevtukhov <yuriy@ucoz.com>,
        Harald Laabs <kernelml@dasr.de>
In-Reply-To: <20110720235836.c40ec351.akpm@linux-foundation.org>
References: <1311230573-6244-1-git-send-email-manfred@colorfullife.com>
	 <20110720235836.c40ec351.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jul 2011 10:12:11 +0200
Message-ID: <1311235931.2422.5.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 20 juillet 2011 à 23:58 -0700, Andrew Morton a écrit :
> On Thu, 21 Jul 2011 08:42:53 +0200 Manfred Spraul <manfred@colorfullife.com> wrote:
> 
> > If a semaphore array is removed and in parallel a sleeping task is woken up
> > (signal or timeout, does not matter), then the woken up task does not wait
> > until wake_up_sem_queue_do() is completed. This will cause crashes, because
> > wake_up_sem_queue_do() will read from a stale pointer.
> > 
> > The fix is simple: Regardless of anything, always call get_queue_result().
> > This function waits until wake_up_sem_queue_do() has finished it's task.
> > 
> > Andrew, could you please take care of merging the patch?
> 
> yup, thanks for this.  It's good to hear from you, and that you've
> still got what it takes :)
> 
> Do you know how long this bug has been around for?  Somewhere between
> 2.6.32 and 2.6.36, but that a large interval!

As I said, bug was introduced in commit
0a2b9d4c79671b05956806ede5d054e03ae56280
(ipc/sem.c: move wake_up_process out of the spinlock section)

(so first faulty kernel version is 2.6.35)

Please also add this bugzilla reference :

 https://bugzilla.kernel.org/show_bug.cgi?id=27142

Reported-by: Harald Laabs <kernelml@dasr.de>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>



