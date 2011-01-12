Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab1ALUsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 15:48:21 -0500
Received: from host1.dyn.jankratochvil.net ([89.250.240.48]:56749 "EHLO
	host1.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755462Ab1ALUsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 15:48:19 -0500
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jan 2011 15:48:18 EST
Date: Wed, 12 Jan 2011 21:41:36 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        rjw@sisk.pl
Subject: Re: [PATCH 1/4] signal: fix SIGCONT notification code
Message-ID: <20110112204136.GB13830@host1.dyn.jankratochvil.net>
References: <1293016398-18001-1-git-send-email-tj@kernel.org>
 <1293016398-18001-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293016398-18001-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Dec 2010 12:13:15 +0100, Tejun Heo wrote:
> If SIGCONT is received while the child process is stopped, the code should
> be CLD_CONTINUED.  If SIGCONT is recieved while the child process is in the
> process of being stopped, it should be CLD_STOPPED.

If a process does
	kill (PID, SIGSTOP);
	<varying delay, possibly even from a different process>
	kill (PID, SIGCONT);

does it mean the PID's parent may get different waitid() results?
Or even that PID will finally remain still `T (stopped)'?

I do not see it has any userland impact, the
PTRACE_ATTACH-to-T(stopped)-process is already racy for different reasons.


Thanks,
Jan
