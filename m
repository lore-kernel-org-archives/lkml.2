Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab0FBPQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 11:16:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932599Ab0FBPQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 11:16:55 -0400
Date: Wed, 2 Jun 2010 11:16:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 0/5] kdump: extract log buffer and registers from
	vmcore on NMI button pressing
Message-ID: <20100602151611.GA3174@redhat.com>
References: <1275464359-1566-1-git-send-email-v.mayatskih@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275464359-1566-1-git-send-email-v.mayatskih@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 09:39:14AM +0200, Vitaly Mayatskikh wrote:
> Sometimes non-interactive dump capture environment silently fails to
> store vmcore due to hardware or software bug. It is hard then to
> understand and fix reasons of system failure in both production and
> dump capture environments to prevent this failure to reoccur. It would
> be quite usefull to see log buffer contents of crashed kernel at
> least.
> 
> This patchset adds possibility for dump capture mode to extract and
> print log buffer and CPU registers from captured vmcore. Also the
> state of running kernel is printed. This action can be triggered via
> NMI button.

Hi Vitaly,

I am not sure what is the problem we are trying to solve here. If we are
unable to capture the dump because second kernel did not boot due to
some dirver issue etc, above patch is not going to help either.

If kernel has booted, then one should be able to capture the dump, filter
it and look at the log buffers and cpu registers.

Most of the failures I have seen in capture kernel is that it was unable
to boot due to either deivce issues or failure in early boot. Once it has
crossed those hurdles, after that capturing the dump is easy part.

How many times does it happen in second kernel that kernel is spinning in
a loop and NMI can still get you information out.

So can you please give some more information about what kind of failures
while capturing the dump you are addressing by this patchset.

Thanks
Vivek
> 
> Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
> 
>  arch/x86/include/asm/elf.h    |   46 +++++
>  arch/x86/include/asm/kdebug.h |    1 +
>  arch/x86/include/asm/nmi.h    |    1 +
>  arch/x86/kernel/apic/nmi.c    |   27 +++
>  arch/x86/kernel/process_32.c  |   22 ++-
>  arch/x86/kernel/process_64.c  |   20 ++-
>  fs/proc/vmcore.c              |  365 +++++++++++++++++++++++++++++++++++++++--
>  include/linux/sysctl.h        |    1 +
>  kernel/sysctl.c               |    7 +
>  kernel/sysctl_binary.c        |    1 +
>  10 files changed, 463 insertions(+), 28 deletions(-)
