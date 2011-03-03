Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab1CCOUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:20:34 -0500
Received: from shutemov.name ([188.40.19.243]:56248 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758518Ab1CCOUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:20:31 -0500
Date: Thu, 3 Mar 2011 16:20:30 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH, v8 0/3] *** SUBJECT HERE ***
Message-ID: <20110303142030.GA9980@shutemov.name>
References: <1299161947-9903-1-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299161947-9903-1-git-send-email-kirill@shutemov.name>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 04:19:04PM +0200, Kirill A. Shutsemov wrote:
> From: Kirill A. Shutemov <kirill@shutemov.name>
> 
> *** BLURB HERE ***

Oops.

Changelog:

v8:
 - change hiearchy rules
 - introduce timer_slack.effective_slack_ns
 - get_task_timer_slack() -> task_get_effective_timer_slack()
 - task_get_effective_timer_slack() splited in separate patch
 - implement PR_GET_EFFECTIVE_TIMERSLACK

v7:
 - totally reworked interface and rewritten from scratch
   (See Documentation/cgroups/timer_slack.txt for more information)
v6:
 - add documentation
 - use notifier_call_chain() instead of check hook
 - fix validate_change()
 - cleanup
v5:
 - -EBUSY on writing to timer_slack.min_slack_ns/max_slack_ns if a child has
   wider min-max range
v4:
 - hierarchy support
 - drop dummy_timer_slack_check()
 - workaround lockdep false (?) positive
 - allow 0 as timer slack value
v3:
 - rework interface
 - s/EXPORT_SYMBOL/EXPORT_SYMBOL_GPL/
v2:
 - fixed with CONFIG_CGROUP_TIMER_SLACK=y
v1:
 - initial revision

> Kirill A. Shutemov (3):
>   hrtimer: introduce effective timer slack
>   hrtimer: implement PR_GET_EFFECTIVE_TIMERSLACK
>   cgroups: introduce timer slack controller
> 
>  Documentation/cgroups/timer_slack.txt |   64 +++++++++++++++++
>  fs/select.c                           |    7 +--
>  include/linux/cgroup_subsys.h         |    6 ++
>  include/linux/prctl.h                 |    6 ++
>  include/linux/sched.h                 |   10 +++
>  init/Kconfig                          |    8 ++
>  kernel/Makefile                       |    1 +
>  kernel/cgroup_timer_slack.c           |  124 +++++++++++++++++++++++++++++++++
>  kernel/fork.c                         |    4 +
>  kernel/futex.c                        |    4 +-
>  kernel/hrtimer.c                      |    2 +-
>  kernel/sys.c                          |    3 +
>  12 files changed, 231 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/cgroups/timer_slack.txt
>  create mode 100644 kernel/cgroup_timer_slack.c
> 
> -- 
> 1.7.4.1
> 

-- 
 Kirill A. Shutemov
