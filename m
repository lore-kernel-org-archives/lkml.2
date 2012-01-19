Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab2ASCYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 21:24:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48004 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab2ASCYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 21:24:10 -0500
Date: Wed, 18 Jan 2012 18:24:01 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [RFC] splitting cgroup.c
Message-ID: <20120119022401.GH21533@google.com>
References: <4F177C67.6070907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F177C67.6070907@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 19, 2012 at 10:13:59AM +0800, Li Zefan wrote:
> While working on cgroup xattr, it appeared to me it's better to
> create a cgroup_xattr.c instead of stuffing things into cgroup.c.
> 
> Then I took a look at how big it is.
> 
>     $ ls -l -S kernel/*.c
>     -rw-rw-r--  1 lizf lizf 142717 Jan 18 10:15 cgroup.c
>     -rw-rw-r--  1 lizf lizf 106498 Jan 18 10:15 workqueue.c
>     -rw-rw-r--  1 lizf lizf 105206 Jan 18 10:15 lockdep.c
>     -rw-rw-r--  1 lizf lizf  91321 Jan 18 10:16 module.c
>     
>     $ wc -l kernel/*.c | sort -n -r
>       90397 total
>        5289 cgroup.c
>        4206 lockdep.c
>        3840 workqueue.c
>        3507 module.c

Yeah, cgroup.c one giant file.

> So I think for the sake of readability and maintainability, we'd
> better split cgroup.c into smaller pieces:

I agree that splitting is necessary but IMHO splitting usually tends
to go too far.  Maybe we can split it into two and think about further
splitting later on?  e.g. internal logic vs. userland interfacing.

Thanks.

-- 
tejun
