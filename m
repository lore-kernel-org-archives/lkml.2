Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab0GAOSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 10:18:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab0GAOSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 10:18:21 -0400
Message-ID: <4C2CA3A5.2040802@redhat.com>
Date: Thu, 01 Jul 2010 17:18:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: Remove unnecessary divide operations
References: <1277992812-31945-1-git-send-email-joerg.roedel@amd.com> <1277992812-31945-2-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1277992812-31945-2-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2010 05:00 PM, Joerg Roedel wrote:
> This patch converts unnecessary divide and modulo operations
> in the KVM large page related code into logical operations.
> This allows to convert gfn_t to u64 while not breaking 32
> bit builds.
>
>
>   #define KVM_NR_PAGE_SIZES 2
> -#define KVM_HPAGE_SHIFT(x) (PAGE_SHIFT + ((x) - 1) * 8)
> +#define KVM_HPAGE_GFN_SHIFT(x) (((x) - 1) * 8)
> +#define KVM_HPAGE_SHIFT(x) (PAGE_SHIFT + KVM_HPAGE_GFN_SHIFT(x))
>   #define KVM_HPAGE_SIZE(x) (1UL<<  KVM_HPAGE_SHIFT(x))
>   #define KVM_HPAGE_MASK(x)	(~(KVM_HPAGE_SIZE(x) - 1))
>    

In theory, KVM_HPAGE_SIZE() needs s/1UL/(u64)1/, or KVM_HPAGE_MASK 
becomes truncated if used against a gfn_t.  In practice, KVM_HPAGE_MASK 
is not used at all, so this doesn't matter.

-- 
error compiling committee.c: too many arguments to function

