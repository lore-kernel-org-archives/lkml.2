Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab1EPQGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:06:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756547Ab1EPQGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:06:39 -0400
Date: Mon, 16 May 2011 18:04:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH UPDATED 8/9] ptrace: move JOBCTL_TRAPPING wait to
	wait(2) and ptrace_check_attach()
Message-ID: <20110516160454.GC15918@redhat.com>
References: <1305301580-9924-1-git-send-email-tj@kernel.org> <1305301580-9924-9-git-send-email-tj@kernel.org> <20110514142230.GD23665@htj.dyndns.org> <20110516121142.GC4898@redhat.com> <20110516133644.GZ23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516133644.GZ23665@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Tejun Heo wrote:
>
> On Mon, May 16, 2011 at 02:11:42PM +0200, Oleg Nesterov wrote:
> > Anyway, restart_syscall() is not right for do_wait(), especially with the
> > next patch. If the caller was woken by the real signal which has a handler,
> > we should not restart without SA_RESTART.
>
> I don't think it really matters and might even be incorrect if we do
> that.  e.g. we would introduce -EINTR failure to WNOHANG waits.

Agreed.

> The only case that I think of where this could be visible is sleeping
> wait(2), checking the state again after being woken up and gets signal
> while waiting for TRAPPING.  In this case, yeap, we should fail with
> -EINTR.

Yes, -EINTR or restart if SA_RESTART.

Oleg.

