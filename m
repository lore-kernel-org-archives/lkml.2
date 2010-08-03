Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab0HCT7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 15:59:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754466Ab0HCT7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 15:59:16 -0400
Date: Tue, 3 Aug 2010 12:58:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com,
        menage@google.com, oleg@redhat.com
Subject: Re: [PATCH v4 0/2] cgroups: implement moving a threadgroup's
 threads atomically with cgroup.procs
Message-Id: <20100803125827.0822e6ab.akpm@linux-foundation.org>
In-Reply-To: <20100730235649.GA22644@ghc17.ghc.andrew.cmu.edu>
References: <20100730235649.GA22644@ghc17.ghc.andrew.cmu.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jul 2010 19:56:49 -0400
Ben Blum <bblum@andrew.cmu.edu> wrote:

> This patch series implements a write function for the 'cgroup.procs'
> per-cgroup file, which enables atomic movement of multithreaded
> applications between cgroups. Writing the thread-ID of any thread in a
> threadgroup to a cgroup's procs file causes all threads in the group to
> be moved to that cgroup safely with respect to threads forking/exiting.
> (Possible usage scenario: If running a multithreaded build system that
> sucks up system resources, this lets you restrict it all at once into a
> new cgroup to keep it under control.)

I can see how that would be useful.  No comments from anyone else?

patch 1/2 makes me cry with all those ifdefs.  Maybe helper functions
would help, but not a lot.

patch 2/2 looks very complicated.
