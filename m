Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab0EED5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 23:57:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab0EED5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 23:57:23 -0400
Message-ID: <4BE0EC9E.3040508@redhat.com>
Date: Tue, 04 May 2010 17:57:18 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH v2 0/7] Pvclock fixes , version two
References: <1272901927-829-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1272901927-829-1-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2010 05:52 AM, Glauber Costa wrote:
> Here is a new version of this series.
>
> I am definitely leaving any warp calculations out, as Jeremy wisely
> points out that Chuck Norris should perish before we warp.
>
> Also, in this series, I am using KVM_GET_SUPPORTED_CPUID to export
> our features to userspace, as avi suggets. (patch 4/7), and starting
> to use the flag that indicates possible tsc stability (patch 7/7), although
> it is still off by default.
>
> Glauber Costa (7):
>    Enable pvclock flags in vcpu_time_info structure
>    Add a global synchronization point for pvclock
>    change msr numbers for kvmclock
>    export paravirtual cpuid flags in KVM_GET_SUPPORTED_CPUID
>    Try using new kvm clock msrs
>    don't compute pvclock adjustments if we trust the tsc
>    Tell the guest we'll warn it about tsc stability
>
>   arch/x86/include/asm/kvm_para.h    |   13 ++++++++
>   arch/x86/include/asm/pvclock-abi.h |    4 ++-
>   arch/x86/include/asm/pvclock.h     |    1 +
>   arch/x86/kernel/kvmclock.c         |   56 ++++++++++++++++++++++-------------
>   arch/x86/kernel/pvclock.c          |   37 +++++++++++++++++++++++
>   arch/x86/kvm/x86.c                 |   37 +++++++++++++++++++++++-
>   6 files changed, 125 insertions(+), 23 deletions(-)
>
>    
Acked-by: Zachary Amsden <zamsden@redhat.com>

I'll rebase on top of these if they get pulled.

And obviously, there is no point in checking for warp if Chuck Norris 
has perished.  I happen to have a special place in my heart for nunchaku 
masters despite the fact that this created a generation of teenagers who 
insisted they were called numb-chucks.
