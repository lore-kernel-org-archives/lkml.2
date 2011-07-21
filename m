Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab1GUG6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 02:58:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003Ab1GUG6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 02:58:42 -0400
Date: Wed, 20 Jul 2011 23:58:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Yuriy Yevtukhov <yuriy@ucoz.com>
Subject: Re: [PATCH] [ipc/sem.c] fix race with concurrent semtimedop()
 timeouts and IPC_RMID
Message-Id: <20110720235836.c40ec351.akpm@linux-foundation.org>
In-Reply-To: <1311230573-6244-1-git-send-email-manfred@colorfullife.com>
References: <1311230573-6244-1-git-send-email-manfred@colorfullife.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011 08:42:53 +0200 Manfred Spraul <manfred@colorfullife.com> wrote:

> If a semaphore array is removed and in parallel a sleeping task is woken up
> (signal or timeout, does not matter), then the woken up task does not wait
> until wake_up_sem_queue_do() is completed. This will cause crashes, because
> wake_up_sem_queue_do() will read from a stale pointer.
> 
> The fix is simple: Regardless of anything, always call get_queue_result().
> This function waits until wake_up_sem_queue_do() has finished it's task.
> 
> Andrew, could you please take care of merging the patch?

yup, thanks for this.  It's good to hear from you, and that you've
still got what it takes :)

Do you know how long this bug has been around for?  Somewhere between
2.6.32 and 2.6.36, but that a large interval!
