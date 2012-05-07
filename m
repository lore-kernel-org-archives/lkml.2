Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab2EGUFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:05:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:32990 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757571Ab2EGUFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:05:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163077486"
Subject: Re: [PATCH 1/2] coredump: flush the fpu exit state for proper
 multi-threaded core dump
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: hpa@zytor.com, mingo@elte.hu, oleg@redhat.com, suresh@aristanetworks.com,
        linux-kernel@vger.kernel.org
Date: Mon, 07 May 2012 13:09:01 -0700
In-Reply-To: <CA+55aFwsZu6YhfeKp17TuiZuyxEXgReXVUMh+_drM7410SBiyg@mail.gmail.com>
References: <1336417641-29771-1-git-send-email-suresh.b.siddha@intel.com>
	 <CA+55aFwsZu6YhfeKp17TuiZuyxEXgReXVUMh+_drM7410SBiyg@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1336421341.19423.4.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 12:15 -0700, Linus Torvalds wrote:
> On Mon, May 7, 2012 at 12:07 PM, Suresh Siddha
> <suresh.b.siddha@intel.com> wrote:
> >
> > Fix this by explicitly flushing the fpu state in do_exit() by calling
> > prepare_to_copy()
> 
> Ugh, I hate this one.
> 
> We're making the exit path more expensive for almost no gain. The FPU
> state is dead in 99.9% of all cases.
> 
> Why isn't this a core-dump-only case?
> 

Today we do this unlazy_fpu() (which is what prepare_to_copy does)
already as part of the first schedule() in the exit path. I am just
making it explicit by calling prepare_to_copy() before exit_mm() which
synchronizes all the threads before the first thread goes with the core
dump.

I don't think I am adding any more cost to the existing path, unless I
am missing something.

thanks,
suresh

