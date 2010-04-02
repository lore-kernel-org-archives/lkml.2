Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab0DBSuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:50:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab0DBSuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:50:10 -0400
Date: Fri, 2 Apr 2010 20:48:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>, Greg KH <greg@kroah.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, stable@kernel.org
Subject: Re: [PATCH 1/1] tty: release_one_tty() forgets to put pids
Message-ID: <20100402184823.GB32229@redhat.com>
References: <201003272121.ADE39095.JLFHOOMtSVOFQF@I-love.SAKURA.ne.jp> <tnxbpe5ygfy.fsf@e102109-lin.cambridge.arm.com> <20100331151719.8a92b302.akpm@linux-foundation.org> <20100402160447.GA19920@redhat.com> <20100402160512.GB19920@redhat.com> <alpine.LFD.2.00.1004021040320.3634@i5.linux-foundation.org> <m14ojtogt6.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14ojtogt6.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02, Eric W. Biederman wrote:
>
> My general paranoia would suggest setting the pids to NULL.  So that
> we don't have the chance of a use after free.

In this case, I don't think this is needed. We are doing
free_tty_struct()->kfree(tty) right after put_pid()s, nobody
can use these pointers or we have another bug.


Most probably this patch is correct (but perhaps it is not the best fix).
Every time tty does put_pid() it should also clear the pointer. But I am
not sure I grepped enough.

Oleg.

