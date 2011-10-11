Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab1JKVyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 17:54:47 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63077 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1JKVyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 17:54:45 -0400
Date: Tue, 11 Oct 2011 14:54:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/3] ipc/sem.c: handle spurious wakeups
Message-Id: <20111011145441.228e4c94.akpm@linux-foundation.org>
In-Reply-To: <1316885831-11996-1-git-send-email-manfred@colorfullife.com>
References: <1316885831-11996-1-git-send-email-manfred@colorfullife.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Sep 2011 19:37:11 +0200
Manfred Spraul <manfred@colorfullife.com> wrote:

> semtimedop() does not handle spurious wakeups, it returns -EINTR to user space.
> Most other schedule() users would just loop and not return to user space.
> The patch adds such a loop to semtimedop()

What is a "spurious wakeup" and how can a process receive one?

I'm wondering about the userspace-visible effects of this change, and
any compatibility issues?


