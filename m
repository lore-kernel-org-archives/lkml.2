Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab0H0XS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 19:18:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751181Ab0H0XS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 19:18:56 -0400
Date: Fri, 27 Aug 2010 16:18:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-08-27-15-43 uploaded
Message-Id: <20100827161855.2d11ec9f.akpm@linux-foundation.org>
In-Reply-To: <201008272313.o7RNDuGu021936@imap1.linux-foundation.org>
References: <201008272313.o7RNDuGu021936@imap1.linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010 15:43:34 -0700
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2010-08-27-15-43 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

This kernel generates a lockdep splat 

[   90.709824] [ INFO: possible irq lock inversion dependency detected ]
[   90.709824] 2.6.36-rc2-mm1 #9
[   90.709824] ---------------------------------------------------------
[   90.709824] kworker/0:1/0 just changed the state of lock:
[   90.709824]  (&(&sighand->siglock)->rlock){-.....}, at: [<ffffffff81042deb>] lock_task_sighand+0x9a/0xda
[   90.709824] but this lock took another, HARDIRQ-unsafe lock in the past:
[   90.709824]  (&(&p->alloc_lock)->rlock){+.+...}

due to oom-add-per-mm-oom-disable-count.patch.

Otherwise, it's perfect.
