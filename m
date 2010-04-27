Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0D0MeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:34:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab0D0MeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:34:13 -0400
Message-ID: <4BD6D9C2.6020104@redhat.com>
Date: Tue, 27 Apr 2010 15:34:10 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/22] KVM: MMU: Add infrastructure for two-level page
 walker
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com> <1272364712-17425-12-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1272364712-17425-12-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 01:38 PM, Joerg Roedel wrote:
> This patch introduces a mmu-callback to translate gpa
> addresses in the walk_addr code. This is later used to
> translate l2_gpa addresses into l1_gpa addresses.
>
> +static inline gfn_t gpa_to_gfn(gpa_t gpa)
> +{
> +	return (gfn_t)gpa>>  PAGE_SHIFT;
> +}
> +
>    

This overflows on 32-bit, since gpa_t is u64 and gfn_t is ulong.

-- 
error compiling committee.c: too many arguments to function

