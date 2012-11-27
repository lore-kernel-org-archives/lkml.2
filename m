Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab2K0XZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:25:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092Ab2K0XZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:25:15 -0500
Date: Tue, 27 Nov 2012 21:24:42 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, glommer@parallels.com, mingo@redhat.com
Subject: Re: [PATCH 0/5] Alter steal time reporting in KVM
Message-ID: <20121127232442.GA8295@amt.cnet>
References: <20121126203603.28840.38736.stgit@lambeau>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126203603.28840.38736.stgit@lambeau>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 02:36:24PM -0600, Michael Wolf wrote:
> In the case of where you have a system that is running in a
> capped or overcommitted environment the user may see steal time
> being reported in accounting tools such as top or vmstat.

The definition of stolen time is 'time during which the virtual CPU is
runnable to not running'. Overcommit is the main scenario which steal
time helps to detect.

Can you describe the 'capped' case?

>  This can
> cause confusion for the end user.  To ease the confusion this patch set
> adds the idea of consigned (expected steal) time.  The host will separate
> the consigned time from the steal time.  The consignment limit passed to the
> host will be the amount of steal time expected within a fixed period of
> time.  Any other steal time accruing during that period will show as the
> traditional steal time.
> 
> ---
> 
> Michael Wolf (5):
>       Alter the amount of steal time reported by the guest.
>       Expand the steal time msr to also contain the consigned time.
>       Add the code to send the consigned time from the host to the guest
>       Add a timer to allow the separation of consigned from steal time.
>       Add an ioctl to communicate the consign limit to the host.
> 
> 
>  arch/x86/include/asm/kvm_host.h       |   11 +++++++
>  arch/x86/include/asm/kvm_para.h       |    3 +-
>  arch/x86/include/asm/paravirt.h       |    4 +--
>  arch/x86/include/asm/paravirt_types.h |    2 +
>  arch/x86/kernel/kvm.c                 |    8 ++---
>  arch/x86/kernel/paravirt.c            |    4 +--
>  arch/x86/kvm/x86.c                    |   50 ++++++++++++++++++++++++++++++++-
>  fs/proc/stat.c                        |    9 +++++-
>  include/linux/kernel_stat.h           |    2 +
>  include/linux/kvm_host.h              |    2 +
>  include/uapi/linux/kvm.h              |    2 +
>  kernel/sched/core.c                   |   10 ++++++-
>  kernel/sched/cputime.c                |   21 +++++++++++++-
>  kernel/sched/sched.h                  |    2 +
>  virt/kvm/kvm_main.c                   |    7 +++++
>  15 files changed, 120 insertions(+), 17 deletions(-)
> 
> -- 
> Signature
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
