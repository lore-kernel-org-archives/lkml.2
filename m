Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab0DITyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:54:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322Ab0DITyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:54:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/3] proc: make collect_sigign_sigcatch() rcu-safe
In-Reply-To: Oleg Nesterov's message of  Monday, 22 March 2010 19:41:33 +0100 <20100322184133.GA3964@redhat.com>
References: <20100322184133.GA3964@redhat.com>
X-Zippy-Says: I love FRUIT PICKERS!!
Message-Id: <20100409195325.45D37BD0A@magilla.sf.frob.com>
Date: Fri,  9 Apr 2010 12:53:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In theory, this ->sighand can be re-used under us (but it can't go away).
> We could check task->sighand == sighand once again after the main loop
> to prevent the race with exit/exec, but I don't think this is really
> needed for fs/proc.

In v2.6.34-rc3-500-g0eddb51 this isn't possible because the calls from
task_sig() and do_task_stat() are under siglock.  Is that locking removed
by another pending change?


Thanks,
Roland
