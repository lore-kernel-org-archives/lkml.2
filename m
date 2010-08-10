Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab0HJV6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 17:58:03 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50566 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933224Ab0HJV6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:58:00 -0400
Date: Tue, 10 Aug 2010 14:57:41 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Tomasz Buchert <tomasz.buchert@inria.fr>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup_freezer: Freezing and task move race fix
Message-ID: <20100810215741.GC2927@count0.beaverton.ibm.com>
References: <1281470001-14320-1-git-send-email-tomasz.buchert@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281470001-14320-1-git-send-email-tomasz.buchert@inria.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 09:53:21PM +0200, Tomasz Buchert wrote:
> Writing 'FROZEN' to freezer.state file does not
> forbid the task to be moved away from its cgroup
> (for a very short time). Nevertheless the moved task
> can become frozen OUTSIDE its cgroup which puts
> discussed task in a permanent 'D' state.
> 
> This patch forbids migration of either FROZEN
> or FREEZING tasks.
> 
> This behavior was observed and easily reproduced on
> a single core laptop. Program and instructions how
> to reproduce the bug can be fetched from:
> http://pentium.hopto.org/~thinred/repos/linux-misc/freezer_bug.c

Thanks for the report and the test code.

I'm will try to reproduce this race in the next few hours and analyze
it since I'm not sure the patch really fixes the race -- it may only
make the race trigger less frequently.

At the very least the patch won't break the current code since it's
essentially a more-strict version of is_task_frozen_enough() -- it lets
fewer tasks attach/detach to/from frozen cgroups.

Cheers,
	-Matt Helsley
