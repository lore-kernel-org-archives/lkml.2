Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab0DBQV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 12:21:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186Ab0DBQVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 12:21:24 -0400
Date: Fri, 2 Apr 2010 18:19:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-kernel@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, stable@kernel.org
Subject: Re: [PATCH 1/1] tty: release_one_tty() forgets to put pids
Message-ID: <20100402161907.GA21576@redhat.com>
References: <201003272121.ADE39095.JLFHOOMtSVOFQF@I-love.SAKURA.ne.jp> <tnxbpe5ygfy.fsf@e102109-lin.cambridge.arm.com> <20100331151719.8a92b302.akpm@linux-foundation.org> <20100402160447.GA19920@redhat.com> <20100402160512.GB19920@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402160512.GB19920@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02, Oleg Nesterov wrote:
>
> release_one_tty(tty) can be called when tty still has a reference
> to pgrp/session. In this case we leak the pid.
>
> The patch needs the ack from someone who understand tty magic.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

I am sorry, I forgot it needs

	Reported-by: Catalin Marinas <catalin.marinas@arm.com>
	Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

> ---
> 
>  drivers/char/tty_io.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- TTT/drivers/char/tty_io.c~TTY_PID_LEAK	2010-03-17 16:00:59.000000000 +0100
> +++ TTT/drivers/char/tty_io.c	2010-04-02 17:23:07.000000000 +0200
> @@ -1423,6 +1423,8 @@ static void release_one_tty(struct work_
>  	list_del_init(&tty->tty_files);
>  	file_list_unlock();
>  
> +	put_pid(tty->pgrp);
> +	put_pid(tty->session);
>  	free_tty_struct(tty);
>  }
>  

