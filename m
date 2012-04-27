Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003Ab2D0N75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 09:59:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758636Ab2D0N7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 09:59:55 -0400
To: Jim Paris <jim@jtan.com>
Cc: linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Milan Broz <mbroz@redhat.com>
Subject: Re: udev missing events?
References: <20120422043655.GA27861@psychosis.jim.sh>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Fri, 27 Apr 2012 09:59:49 -0400
In-Reply-To: <20120422043655.GA27861@psychosis.jim.sh> (Jim Paris's message of "Sun, 22 Apr 2012 00:36:55 -0400")
Message-ID: <y0mr4v9mg16.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jim Paris <jim@jtan.com> writes:

> [...]
> To try to track it further, I wrote a systemtap script (available at
> http://jim.sh/~jim/tmp/monitor.stp).  It dumps the result of
> netlink_broadcast_filtered at lib/kobject_uevent.c:248 [...]

By the way, your monitor.stp contains this bit:

   /* I don't know how to do this better, indexing envp
   if ($env->envp_idx > 0) printf("  %s\n", $env->envp[0]$)
   if ($env->envp_idx > 1) printf("  %s\n", $env->envp[1]$)
   [...]
   if ($env->envp_idx > 9) printf("  %s\n", $env->envp[9]$)
   if ($env->envp_idx > 10) printf("..... more\n")

More idiomatic would be as follows (stap version 0.9.9+):

   for (i=0; i<$env->envp_idx; i++) {
       printf("  %s\n", $env->envp[i]$)
   }

- FChE
