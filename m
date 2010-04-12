Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0DLU2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 16:28:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475Ab0DLU2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 16:28:34 -0400
Date: Mon, 12 Apr 2010 22:26:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/3] proc: make collect_sigign_sigcatch() rcu-safe
Message-ID: <20100412202614.GA18802@redhat.com>
References: <20100322184133.GA3964@redhat.com> <20100409195325.45D37BD0A@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100409195325.45D37BD0A@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09, Roland McGrath wrote:
>
> > In theory, this ->sighand can be re-used under us (but it can't go away).
> > We could check task->sighand == sighand once again after the main loop
> > to prevent the race with exit/exec, but I don't think this is really
> > needed for fs/proc.
>
> In v2.6.34-rc3-500-g0eddb51 this isn't possible because the calls from
> task_sig() and do_task_stat() are under siglock.

Yes sure. If it is called under ->siglock we have no races we should
worry about.

> Is that locking removed
> by another pending change?

Yes, the next 3/3 patch.

Oleg.

