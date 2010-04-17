Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab0DQS6a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 14:58:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574Ab0DQS63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 14:58:29 -0400
Message-ID: <4BCA04D2.1040300@redhat.com>
Date: Sat, 17 Apr 2010 21:58:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] export new cpuid KVM_CAP
References: <1271356648-5108-1-git-send-email-glommer@redhat.com> <1271356648-5108-2-git-send-email-glommer@redhat.com> <1271356648-5108-3-git-send-email-glommer@redhat.com> <1271356648-5108-4-git-send-email-glommer@redhat.com> <1271356648-5108-5-git-send-email-glommer@redhat.com>
In-Reply-To: <1271356648-5108-5-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2010 09:37 PM, Glauber Costa wrote:
> Since we're changing the msrs kvmclock uses, we have to communicate
> that to the guest, through cpuid. We can add a new KVM_CAP to the
> hypervisor, and then patch userspace to recognize it.
>
> And if we ever add a new cpuid bit in the future, we have to do that again,
> which create some complexity and delay in feature adoption.
>
> Instead, what I'm proposing in this patch is a new capability, called
> KVM_CAP_X86_CPUID_FEATURE_LIST, that returns the current feature list
> currently supported by the hypervisor. If we ever want to add or remove
> some feature, we only need to tweak into the HV, leaving userspace untouched.
>
>    

Hm.  We need to update userspace anyway, since we don't like turning 
features on unconditionally (it breaks live migration into an older kernel).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

