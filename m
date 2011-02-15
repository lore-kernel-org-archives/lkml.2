Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab1BOO2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:28:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050Ab1BOO2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:28:18 -0500
Message-ID: <4D5A8CCD.1070506@redhat.com>
Date: Tue, 15 Feb 2011 16:25:17 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 1/6] KVM-HDR: KVM Steal time implementation
References: <1297448364-14051-1-git-send-email-glommer@redhat.com> <1297448364-14051-2-git-send-email-glommer@redhat.com>
In-Reply-To: <1297448364-14051-2-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2011 08:19 PM, Glauber Costa wrote:
> To implement steal time, we need the hypervisor to pass the guest information
> about how much time was spent running other processes outside the VM.
> This is per-vcpu, and using the kvmclock structure for that is an abuse
> we decided not to make.
>
> In this patchset, I am introducing a new msr, KVM_MSR_STEAL_TIME, that
> holds the memory area address containing information about steal time
>
> This patch contains the headers for it. I am keeping it separate to facilitate
> backports to people who wants to backport the kernel part but not the
> hypervisor, or the other way around.
>
>
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index ea2dc1a..233374a 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -541,6 +541,7 @@ struct kvm_ppc_pvinfo {
>   #define KVM_CAP_PPC_GET_PVINFO 57
>   #define KVM_CAP_PPC_IRQ_LEVEL 58
>   #define KVM_CAP_ASYNC_PF 59
> +#define KVM_CAP_STEAL_TIME 60
>
>   #ifdef KVM_CAP_IRQ_ROUTING
>

This isn't related to the guest/host interface and should come with the 
hypervisor patch.

-- 
error compiling committee.c: too many arguments to function

