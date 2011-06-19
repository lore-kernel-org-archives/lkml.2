Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab1FSJuT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 05:50:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab1FSJuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 05:50:17 -0400
Message-ID: <4DFDC63B.3000209@redhat.com>
Date: Sun, 19 Jun 2011 12:49:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH v2 2/7] KVM-HDR: KVM Steal time implementation
References: <1308262856-5779-1-git-send-email-glommer@redhat.com> <1308262856-5779-3-git-send-email-glommer@redhat.com>
In-Reply-To: <1308262856-5779-3-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2011 01:20 AM, Glauber Costa wrote:
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
> index d079aed..79c12a7 100644
> --- a/Documentation/virtual/kvm/msr.txt
> +++ b/Documentation/virtual/kvm/msr.txt
> @@ -185,3 +185,36 @@ MSR_KVM_ASYNC_PF_EN: 0x4b564d02
>
>   	Currently type 2 APF will be always delivered on the same vcpu as
>   	type 1 was, but guest should not rely on that.
> +
> +MSR_KVM_STEAL_TIME: 0x4b564d03
> +
> +	data: 64-byte alignment physical address of a memory area which must be
> +	in guest RAM, plus an enable bit in bit 0. This memory is expected to
> +	hold a copy of the following structure:
> +
> +	struct kvm_steal_time {
> +	  	__u64 steal;
> + 		__u32 version;
> + 		__u32 flags;
> +	 	__u32 pad[6];

Should be 12 to be a 64-byte structure, no?



-- 
error compiling committee.c: too many arguments to function

