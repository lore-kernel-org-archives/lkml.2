Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab2K0IsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:48:23 -0500
Received: from mx2.parallels.com ([64.131.90.16]:37909 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757963Ab2K0IsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:48:22 -0500
Message-ID: <50B47E40.5030805@parallels.com>
Date: Tue, 27 Nov 2012 12:48:00 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Michael Wolf <mjw@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <riel@redhat.com>, <kvm@vger.kernel.org>,
        <peterz@infradead.org>, <mtosatti@redhat.com>, <mingo@redhat.com>
Subject: Re: [PATCH 0/5] Alter steal time reporting in KVM
References: <20121126203603.28840.38736.stgit@lambeau>
In-Reply-To: <20121126203603.28840.38736.stgit@lambeau>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/27/2012 12:36 AM, Michael Wolf wrote:
> In the case of where you have a system that is running in a
> capped or overcommitted environment the user may see steal time
> being reported in accounting tools such as top or vmstat.  This can
> cause confusion for the end user.  To ease the confusion this patch set
> adds the idea of consigned (expected steal) time.  The host will separate
> the consigned time from the steal time.  The consignment limit passed to the
> host will be the amount of steal time expected within a fixed period of
> time.  Any other steal time accruing during that period will show as the
> traditional steal time.

If you submit this again, please include a version number in your series.

It would also be helpful to include a small changelog about what changed
between last version and this version, so we could focus on that.

As for the rest, I answered your previous two submissions saying I don't
agree with the concept. If you hadn't changed anything, resending it
won't change my mind.

I could of course, be mistaken or misguided. But I had also not seen any
wave of support in favor of this previously, so basically I have no new
data to make me believe I should see it any differently.

Let's try this again:

* Rik asked you in your last submission how does ppc handle this. You
said, and I quote: "In the case of lpar on POWER systems they simply
report steal time and do not alter it in any way.
They do however report how much processor is assigned to the partition
and that information is in /proc/ppc64/lparcfg."

Now, that is a *way* more sensible thing to do. Much more. "Confusing
users" is something extremely subjective. This is specially true about
concepts that are know for quite some time, like steal time. If you out
of a sudden change the meaning of this, it is sure to confuse a lot more
users than it would clarify.





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

