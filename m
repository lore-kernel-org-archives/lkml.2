Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab1BCUtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 15:49:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab1BCUtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 15:49:46 -0500
Date: Thu, 3 Feb 2011 21:41:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>
Cc: jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: [PATCH 0/1] (Was: ptrace: clean transitions between TASK_STOPPED
	and TRACED)
Message-ID: <20110203204122.GA26371@redhat.com>
References: <1296227324-25295-1-git-send-email-tj@kernel.org> <1296227324-25295-11-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296227324-25295-11-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28, Tejun Heo wrote:
>
> Currently, if the task is STOPPED on ptrace attach, it's left alone
> and the state is silently changed to TRACED on the next ptrace call.

In particular, this means that it is very hard to attach correctly.
Any ptrace request needs STOPPED/TRACED tracee, but apart from wait()
there is no simple way to verify this and many applications (imho
rightly) assume that wait() after PTRACE_ATTACH should work.

While this patch should fix this old known problem, it needs more
discussion.

Tejun, Roland, perhaps it makes sense to fix this partcular problem
first? Personally I do not know, but as Jan reports this is really
annoying for gdb at least.

Oleg.

