Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab2K3Ksw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:48:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757369Ab2K3Ksu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:48:50 -0500
Date: Fri, 30 Nov 2012 02:48:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, axboe@kernel.dk,
        jmoyer@redhat.com, Neil Brown <neilb@suse.de>,
        David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2 v3] wait: add wait_event_lock_irq() interface
Message-Id: <20121130024842.5326d998.akpm@linux-foundation.org>
In-Reply-To: <1354272161-9173-1-git-send-email-lczerner@redhat.com>
References: <1354272161-9173-1-git-send-email-lczerner@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2012 11:42:40 +0100 Lukas Czerner <lczerner@redhat.com> wrote:

> New wait_event{_interruptible}_lock_irq{_cmd} macros added. This commit
> moves the private wait_event_lock_irq() macro from MD to regular wait
> includes, introduces new macro wait_event_lock_irq_cmd() instead of using
> the old method with omitting cmd parameter which is ugly and makes a use
> of new macros in the MD. It also introduces the _interruptible_ variant.
> 
> The use of new interface is when one have a special lock to protect data
> structures used in the condition, or one also needs to invoke "cmd"
> before putting it to sleep.
> 
> All new macros are expected to be called with the lock taken. The lock
> is released before sleep and is reacquired afterwards. We will leave the
> macro with the lock held.
> 
> Note to DM: IMO this should also fix theoretical race on waitqueue while
> using simultaneously wait_event_lock_irq() and wait_event() because of
> lack of locking around current state setting and wait queue removal.

Does this fix the sparse warning which Fengguang just sent us?
