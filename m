Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab0EaSGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 14:06:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab0EaSGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 14:06:17 -0400
Date: Mon, 31 May 2010 20:04:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, ebiederm@xmission.com, lizf@cn.fujitsu.com,
       matthltc@us.ibm.com, menage@google.com
Subject: Re: [RFC] [PATCH 2/2] cgroups: make procs file writable
Message-ID: <20100531180446.GA16249@redhat.com>
References: <20100530013002.GA762@ghc01.ghc.andrew.cmu.edu> <20100530013303.GC762@ghc01.ghc.andrew.cmu.edu> <20100531175242.GA14691@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531175242.GA14691@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31, Oleg Nesterov wrote:
>
> I only glanced into one function, cgroup_attach_proc(), and some things
> look "obviously wrong". Sorry, I can't really read these patches now,
> most probably I misunderstood the code...

And, forgot to mention, I do not understand the PF_EXITING check in
attach_task_by_pid() (and some others).

At first glance, it buys nothing. PF_EXITING can be set right after
the check. And, what if we have the process with the exited group-leader?
In that case we can't use tgid to move this process?

Oleg.

