Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab0IFSFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 14:05:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134Ab0IFSFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 14:05:48 -0400
Message-ID: <4C852D6F.5000101@redhat.com>
Date: Mon, 06 Sep 2010 21:05:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        joro@8bytes.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/27] KVM: MMU: Add infrastructure for two-level page
 walker
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com> <1283788566-29186-11-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1283788566-29186-11-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/06/2010 06:55 PM, Joerg Roedel wrote:
> This patch introduces a mmu-callback to translate gpa
> addresses in the walk_addr code. This is later used to
> translate l2_gpa addresses into l1_gpa addresses.

> @@ -534,6 +534,11 @@ static inline gpa_t gfn_to_gpa(gfn_t gfn)
>   	return (gpa_t)gfn<<  PAGE_SHIFT;
>   }
>
> +static inline gfn_t gpa_to_gfn(gpa_t gpa)
> +{
> +	return (gfn_t)gpa>>  PAGE_SHIFT;
> +}
> +

That's a bug - gfn_t may be smaller than gpa_t, so you're truncating 
just before the shift.  Note the casts in the surrounding functions are 
widening, not narrowing.

However, gfn_t is u64 so the bug is only theoretical.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

