Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086Ab0LTTvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 14:51:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744Ab0LTTvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 14:51:04 -0500
Date: Mon, 20 Dec 2010 20:43:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 14/16] ptrace: make SIGCONT notification reliable
	against ptrace
Message-ID: <20101220194354.GA23281@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org> <1291654624-6230-15-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291654624-6230-15-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06, Tejun Heo wrote:
>
> This patch adds a new signal flag SIGNAL_NOTIFY_CONT which is set when
> a task is woken up by SIGCONT and cleared once the event is notified
> to the parent.  SIGNAL_CLD_MASK bits are no longer cleared after
> notification.  Combined with clearing SIGNAL_CLD_MASK if
> !SIGNAL_NOTIFY_CONT on ptrace attach, these bits are set on ptrace
> detach iff the tracee owes a notification to the real parent.
> __ptrace_unlink() is updated to check these bits and reschedule
> SIGCONT notification if necessary.

It turns out I can no longer read the patches today ;)  Will continue
tomorrow with the fresh head.

I must admit, I have some concerns. But most probably I just need
to actually understand what this patch does.

Oleg.

