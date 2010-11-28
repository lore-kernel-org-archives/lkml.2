Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab0K1UvM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 15:51:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab0K1UvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 15:51:11 -0500
Date: Sun, 28 Nov 2010 21:44:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "rjw@sisk.plpavel"@ucw.cz, Jan Kratochvil <jan.kratochvil@redhat.com>
Subject: Re: [PATCH 14/14] ptrace: remove the extra wake_up_process() from
	ptrace_detach()
Message-ID: <20101128204435.GE12896@redhat.com>
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-15-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290768569-16224-15-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today I lost the concentration at 13/14 ;)

Will continue tomorrow. As for this patch,

On 11/26, Tejun Heo wrote:
>
> This wake_up_process() has a turbulent history.  This is a remnant
> from ancient ptrace implementation and patently wrong.  Commit
> 95a3540d (ptrace_detach: the wrong wakeup breaks the ERESTARTxxx
> logic) removed it

Yes. This obviously means I personally like this change. In fact,
I never understood this wakeup, and I was glad to find the reason
to send the patch.

> but the change was reverted later by commit edaba2c5
> (ptrace: revert "ptrace_detach: the wrong wakeup breaks the
> ERESTARTxxx logic ") citing compatibility breakage and general
> brokeness of the whole group stop / ptrace interaction.

Yes. Honestly, I completely forgot the reason, iirc 95a3540d
broke gdb somehow.

Add Jan. IIRC, we had a long discussion after that, and (iirc!)
Jan seems to agree we can kill this wakeup.

Oleg.

