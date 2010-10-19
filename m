Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab0JSPE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:04:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:37374 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab0JSPE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:04:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,350,1283756400"; 
   d="scan'208";a="337878451"
Message-ID: <4CBDB385.6080100@linux.intel.com>
Date: Tue, 19 Oct 2010 17:04:37 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Len Brown <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Eric Paris <eparis@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] sysctl: remove sysctl syscall
References: <1287476560-5874-1-git-send-email-amwang@redhat.com>	<1287476560-5874-2-git-send-email-amwang@redhat.com>	<4CBD9B7F.6040307@linux.intel.com> <m1vd4yi977.fsf@fess.ebiederm.org>
In-Reply-To: <m1vd4yi977.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> At the time the deprecation was written we nearly we were in the late
> rc's before anything that cared in practice. glibc has stopped even
> providing a sys_sysctl wrapper now.

What matters are old glibc installations, not new ones.

>> I think it's ok to remove the full tables, but keeping
>> a wrapper just for the functionality glibc use(s/d) is still a good
>> idea.
> I think the only problem should be the arm glibc.  I don't know if
> it's iopl implementation ever got weened off of this.  I tried
> but I didn't have good test machine and submitting patches to
> glibc is much more of a pain than kernel patches.


Eric, I think you have the wrong approach here: it doesn't matter what 
new glibc does,
but what any old glibcs do. If any old one uses it we cannot simply 
remove it.

> To my knowledge there has never been a version of x86 glibc that
> had problems if sys_sysctl returns -ENOSYS, and glibc proper removed
> even that dependency almost as soon as sys_sysctl was deprecated.
>

AFAIK older glibc didn't use some functionality in the kernel if they 
couldn't
figure out the right kernel version. And they were using sysctl for this.



> Last time we discussed this (when I added the compatibility wrapper)
> I couldn't even find a version of glibc that used sysctl, and I could
> not find a distribution old enough that still had a version of glibc
> that used sysctl on x86.

When I did my really old work for sysctl_binary() I ran into this problem.
All glibc binaries on my distribution back then used sysctl.

> We warn on every sys_sysctl value now even the glibc uses and perhaps I
> am blind but I haven't seen any bug reports.  So we should be safe
> turning this off.
>

I don't so. I don't think we can that easily break compatibility, sorry.
Binary compatibility is something very important for Linux.

Anyways I'm fine with removing the bulk of the tables, but not the compat
table for the one glibc uses.

I think the code could be a lot simplified and just provide support
for the single kernel version sysctl though (I had a patch to do that
back then)

-Andi
