Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133Ab1FVWsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 18:48:55 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59726 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759114Ab1FVWsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 18:48:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UuLRcxIBE1ed9v9JBBog2Jqi7kNeFLUt+HnyDk6QXn3OJbA24TwKUWE5HL3Fae+kHb
         DjGOvTxvXKtvCxGc9A8ixkD4C2eCV8XNrJBMf2/oFgtGq3hN1hBOKtX9NBEm0P9ZLRmW
         DJBV8ebrdFOSv5lUkKt/fgziuZRX2YIg188Zk=
Date: Thu, 23 Jun 2011 00:48:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: [GIT PULL v2] sched: Make sleep inside atomic detection work on
 !PREEMPT
Message-ID: <20110622224844.GA3290@somewhere>
References: <1307712622-11104-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307712622-11104-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 03:30:18PM +0200, Frederic Weisbecker wrote:
> Ingo,
> 
> Please pull the sched/core branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	sched/core

Hi Ingo,

I have added Randy's ack on the last patch. To get it, please pull the v2 in
the following branch:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
       sched/core-v2

There are no other changes.

Thanks.

> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (4):
>       sched: Remove pointless in_atomic() definition check
>       sched: Isolate preempt counting in its own config option
>       sched: Make sleeping inside spinlock detection working in !CONFIG_PREEMPT
>       sched: Generalize sleep inside spinlock detection
> 
> 
>  Documentation/DocBook/kernel-hacking.tmpl  |    2 +-
>  Documentation/SubmitChecklist              |    2 +-
>  Documentation/development-process/4.Coding |    2 +-
>  Documentation/ja_JP/SubmitChecklist        |    2 +-
>  Documentation/zh_CN/SubmitChecklist        |    2 +-
>  include/linux/bit_spinlock.h               |    2 +-
>  include/linux/hardirq.h                    |    4 ++--
>  include/linux/kernel.h                     |    2 +-
>  include/linux/pagemap.h                    |    4 ++--
>  include/linux/preempt.h                    |   26 +++++++++++++++++---------
>  include/linux/rcupdate.h                   |   12 ++++++------
>  include/linux/sched.h                      |    2 +-
>  kernel/Kconfig.preempt                     |    3 +++
>  kernel/sched.c                             |    6 ++----
>  lib/Kconfig.debug                          |    9 ++++++---
>  15 files changed, 46 insertions(+), 34 deletions(-)
