Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560Ab1I3Wa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 18:30:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:50440 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab1I3Wau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 18:30:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="57857035"
From: Andi Kleen <andi@firstfloor.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
Date: Fri, 30 Sep 2011 15:30:49 -0700
In-Reply-To: <1317395577-14091-1-git-send-email-matt@console-pimps.org> (Matt
	Fleming's message of "Fri, 30 Sep 2011 16:12:52 +0100")
Message-ID: <m21uuxirxi.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Fleming <matt@console-pimps.org> writes:
>
> And just like last time, these patches break ia64 because it
> implements rt_sigprocmask() in assembly. I'll work on the ia64 stuff
> while these patches are being reviewed.

Since we don't want to tie everyone changing signals in the future to
learning IA64 assembler, maybe the best approach would be simply to
change that function to just use the syscall. It can't be that
performance critical and everyone else has it as a syscall too.

I think that would be the best solution for long term maintainability.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
